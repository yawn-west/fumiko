FROM python:3.13-slim

WORKDIR /app

RUN pip install --root-user-action=ignore --upgrade pip poetry

COPY pyproject.toml poetry.lock poetry.toml README.md ./
COPY fumiko/ fumiko/

RUN poetry install --without dev --no-interaction

ENTRYPOINT ["poetry", "run", "python", "-m", "fumiko.main"]
