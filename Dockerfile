FROM r-base:latest

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

RUN R -e "install.packages('dplyr', repos='https://cloud.r-project.org/')"

WORKDIR /app

COPY run.R /app/run.R

CMD ["Rscript", "run.R"]
