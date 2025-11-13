# Используем официальный образ R
FROM r-base:4.3.0

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Создаем директорию для работы
WORKDIR /HW8

# Копируем файлы в контейнер
COPY script.R /HW8/
COPY Пациенты.xlsx /HW8/

# Устанавливаем R пакеты
RUN R -e "install.packages('readxl', repos='https://cloud.r-project.org/')"

# Запускаем скрипт
CMD ["Rscript", "script.R"]