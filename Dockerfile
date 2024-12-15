# Базовый образ с последней версией Python
FROM python:3.12-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libopencv-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем Poetry
RUN pip install --no-cache-dir poetry

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем только pyproject.toml и poetry.lock для кэширования слоев
COPY pyproject.toml poetry.lock ./

# Устанавливаем только продакшен зависимости (без dev)
RUN poetry config virtualenvs.create false && \
    poetry install --only main --no-root

# Копируем всё приложение
COPY . .

# Устанавливаем зависимости разработки (если нужно)
ARG INSTALL_DEV=false
RUN if [ "$INSTALL_DEV" = "true" ]; then poetry install --with dev --no-root; fi

# Указываем порт для приложения
EXPOSE 5000

# Команда для запуска Flask
CMD ["uvicorn", "app.main:asgi_app", "--host", "0.0.0.0", "--port", "5000"]
