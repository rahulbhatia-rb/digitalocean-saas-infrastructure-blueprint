FROM python:3.12-alpine
RUN addgroup -S app && adduser -S -G app app
WORKDIR /app
COPY app.py .
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:8080/healthz || exit 1
CMD ["python", "app.py"]

