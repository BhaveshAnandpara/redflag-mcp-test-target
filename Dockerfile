FROM python:3.12-slim

RUN pip install --no-cache-dir excel-mcp-server

WORKDIR /app
RUN mkdir -p /app/workbooks

# Render sets $PORT at runtime; fall back to 8000 for a local run.
# EXCEL_MCP_AUTH_TOKEN must be set as an env var on the host (Render dashboard, or
# `docker run -e`) — never baked into the image.
CMD ["sh", "-c", "excel-mcp-server streamable-http --host 0.0.0.0 --port ${PORT:-8000} --allow-dir /app/workbooks"]
