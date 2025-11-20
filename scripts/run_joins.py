import os
import sys
import logging
import pandas as pd

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    stream=sys.stdout,
)

INPUT_DIR = "/app/input"
OUTPUT_DIR = "/app/output"

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    try:
        os.chmod(OUTPUT_DIR, 0o777)
    except:
        pass

    metadata = pd.read_csv(os.path.join(INPUT_DIR, "sample_metadata.csv"))
    ms = pd.read_csv(os.path.join(INPUT_DIR, "ms_results.csv"))
    q = pd.read_csv(os.path.join(INPUT_DIR, "quality_data.csv"))

    logging.info("Делаю INNER JOIN…")
    inner = metadata.merge(ms, on="sample_id", how="inner").merge(q, on="sample_id", how="inner")
    inner.to_csv(os.path.join(OUTPUT_DIR, "join_inner.csv"), index=False)

    logging.info("Делаю LEFT JOIN…")
    left = metadata.merge(ms, on="sample_id", how="left").merge(q, on="sample_id", how="left")
    left.to_csv(os.path.join(OUTPUT_DIR, "join_left.csv"), index=False)

    logging.info("Делаю RIGHT JOIN…")
    right = metadata.merge(ms, on="sample_id", how="right").merge(q, on="sample_id", how="left")
    right.to_csv(os.path.join(OUTPUT_DIR, "join_right.csv"), index=False)

    logging.info("Делаю OUTER JOIN…")
    outer = metadata.merge(ms, on="sample_id", how="outer").merge(q, on="sample_id", how="outer")
    outer.to_csv(os.path.join(OUTPUT_DIR, "join_outer.csv"), index=False)

    logging.info("Готово!")

if __name__ == "__main__":
    main()
