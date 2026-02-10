# Development stage
FROM python:3.9-slim AS development

# Install system dependencies including curl for health checks
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Clone YOLOv5 repository
RUN git clone https://github.com/ultralytics/yolov5.git /app/yolov5
RUN pip install -r /app/yolov5/requirements.txt

# Copy application code
COPY . .

# Set Python path to include yolov5
ENV PYTHONPATH="/app:/app/yolov5"
ENV FLASK_APP=app.py
ENV FLASK_ENV=development
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

# Health check for development
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Use Flask development server (make sure your app.py uses host='0.0.0.0')
CMD ["python", "app.py"]

# Production stage
FROM python:3.9-slim AS production

# Install system dependencies including curl for health checks
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Clone YOLOv5 repository
RUN git clone https://github.com/ultralytics/yolov5.git /app/yolov5
RUN pip install -r /app/yolov5/requirements.txt

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app \
    && mkdir -p /home/app/.config/Ultralytics \
    && mkdir -p /home/app/.cache/torch \
    && chown -R app:app /home/app

# Switch to non-root user
USER app

# Set Python path and config directories
ENV PYTHONPATH="/app:/app/yolov5"
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1
ENV YOLO_CONFIG_DIR="/home/app/.config/Ultralytics"
ENV TORCH_HOME="/home/app/.cache/torch"

EXPOSE 5000

# Health check for production
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Use gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "1", "--timeout", "300", "--worker-class", "sync", "--max-requests", "100", "app:app"]