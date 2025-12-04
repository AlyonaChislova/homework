# Mass-Spec Snakemake Pipeline

Выполняет:

* скачивание двух файлов данных в контейнере
* три антиджоина между mass\_spec\_results.csv и sample\_metadata.csv
* полную оркестрацию пайплайна через Snakemake
* генерацию rulegraph.png и filegraph.png

Структура такая:
.
├── Snakefile
├── containers
│   ├── Dockerfile.download
│   └── Dockerfile.process
├── scripts
│   └── anti\_joins.py
└── README.md

