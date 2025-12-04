from pathlib import Path

BASEDIR = Path(workflow.basedir).resolve()
CONTAINERS_DIR = BASEDIR / "containers"

DOWNLOAD_CONTAINER = f"docker-archive://{CONTAINERS_DIR / 'ms-download.tar'}"
PROCESS_CONTAINER = f"docker-archive://{CONTAINERS_DIR / 'ms-process.tar'}"

rule all:
    input:
        "output/mass_without_metadata.csv",
        "output/metadata_without_mass.csv",
        "output/mismatched_samples.csv"

rule download_data:
    output:
        mass_spec="input/mass_spec_results.csv",
        metadata="input/sample_metadata.csv"
    container:
        DOWNLOAD_CONTAINER
    shell:
        r"""
        set -euo pipefail
        mkdir -p input

        wget -O {output.mass_spec} \
          "https://storage.yandexcloud.net/students-common/mass_spec_results.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJELqVUR2I4aFR9yju0lZmQ%2F20251129%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20251129T075802Z&X-Amz-Expires=2592000&X-Amz-Signature=8696243c988ba07aaf3b8c3bbf6ef9eedaff7c5d6e4364aea6087493c19e3e39&X-Amz-SignedHeaders=host&response-content-disposition=attachment"

        wget -O {output.metadata} \
          "https://storage.yandexcloud.net/students-common/sample_metadata.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJELqVUR2I4aFR9yju0lZmQ%2F20251129%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20251129T075822Z&X-Amz-Expires=2592000&X-Amz-Signature=10e1273d1fcbd5cba59ca00125eb26a4406c14a0ce39c97bcdd5a266493e8015&X-Amz-SignedHeaders=host&response-content-disposition=attachment"
        """

rule anti_joins:
    input:
        mass_spec="input/mass_spec_results.csv",
        metadata="input/sample_metadata.csv"
    output:
        mass_without_metadata="output/mass_without_metadata.csv",
        metadata_without_mass="output/metadata_without_mass.csv",
        mismatched_samples="output/mismatched_samples.csv"
    container:
        PROCESS_CONTAINER
    shell:
        r"""
        set -euo pipefail
        mkdir -p output

        python /work/anti_joins.py \
            --mass-spec {input.mass_spec} \
            --metadata {input.metadata} \
            --mass-without-metadata {output.mass_without_metadata} \
            --metadata-without-mass {output.metadata_without_mass} \
            --mismatched-samples {output.mismatched_samples}
        """
