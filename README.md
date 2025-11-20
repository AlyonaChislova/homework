# Mass Spec Joins

## Как пользоваться

### 1. Сгенерировать данные
```
python scripts/generate_data.py
```

### 2. Создать output
```
mkdir output
chmod 777 output
```

### 3. Собрать контейнер
```
docker build -t mass-spec-joins .
```

### 4. Запустить
```
docker run --rm -v $(pwd)/input:/app/input -v $(pwd)/output:/app/output mass-spec-joins
```
