FROM python:3.13-slim as builder

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip poetry

COPY pyproject.toml poetry.lock README.md ./
COPY fumiko/ fumiko/
RUN poetry config virtualenvs.create false \
    && poetry install --without dev --no-interaction --no-cache


FROM python:3.13-alpine as runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
PYTHONUNBUFFERED=1 \
PYTHONPATH=/app

WORKDIR /app

RUN addgroup -S fumiko && adduser -S fumiko -G fumiko
USER fumiko

COPY --from=builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/
COPY --from=builder /app/fumiko/ /app/fumiko/

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD python -c "import fumiko; print('Health check passed')" || exit 1

ENTRYPOINT ["python", "-m", "fumiko.main"]
