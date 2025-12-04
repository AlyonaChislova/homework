import argparse
import sys
import pandas as pd


def guess_key_column(mass_spectrometry_columns, metadata_columns):
    CANDIDATE_KEYS = ["sample_id", "SampleID", "sample", "Sample"]

    for candidate in CANDIDATE_KEYS:
        if candidate in mass_spectrometry_columns and candidate in metadata_columns:
            return candidate
    return None


def main():
    parser = argparse.ArgumentParser(description="Выполнить три антиджоина.")
    parser.add_argument("--mass-spec", required=True)
    parser.add_argument("--metadata", required=True)
    parser.add_argument("--mass-without-metadata", required=True)
    parser.add_argument("--metadata-without-mass", required=True)
    parser.add_argument("--mismatched-samples", required=True)

    args = parser.parse_args()

    mass_spectrometry_df = pd.read_csv(args.mass_spec)
    metadata_df = pd.read_csv(args.metadata)

    key_column = guess_key_column(mass_spectrometry_df.columns, metadata_df.columns)
    if key_column is None:
        sys.stderr.write(
            f"Не найден ключевой столбец!\n"
            f"mass columns: {list(mass_spectrometry_df.columns)}\n"
            f"meta columns: {list(metadata_df.columns)}\n"
        )
        sys.exit(1)

    #находим записи масс-спектрометрии без соответствующих метаданных
    mass_with_metadata_flag = mass_spectrometry_df.merge(
        metadata_df[[key_column]].drop_duplicates(),
        on=key_column,
        how="left",
        indicator=True
    )
    mass_without_metadata_df = mass_with_metadata_flag[
        mass_with_metadata_flag["_merge"] == "left_only"
    ].drop(columns=["_merge"])

    #находим записи метаданных без соответствующих масс-спектрометрий
    metadata_with_mass_flag = metadata_df.merge(
        mass_spectrometry_df[[key_column]].drop_duplicates(),
        on=key_column,
        how="left",
        indicator=True
    )
    metadata_without_mass_df = metadata_with_mass_flag[
        metadata_with_mass_flag["_merge"] == "left_only"
    ].drop(columns=["_merge"])

    #собираем все несовпадающие ID
    all_mismatched_ids = pd.concat(
        [mass_without_metadata_df[[key_column]], metadata_without_mass_df[[key_column]]],
        ignore_index=True
    ).drop_duplicates()
    all_mismatched_ids = all_mismatched_ids.rename(columns={key_column: "sample_id_mismatched"})

    #сохраняем результаты
    mass_without_metadata_df.to_csv(args.mass_without_metadata, index=False)
    metadata_without_mass_df.to_csv(args.metadata_without_mass, index=False)
    all_mismatched_ids.to_csv(args.mismatched_samples, index=False)


if __name__ == "__main__":
    main()
