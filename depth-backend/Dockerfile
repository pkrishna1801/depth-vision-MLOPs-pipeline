# Development stage
FROM python:3.9-slim AS development

# Install system dependencies including curl for health checks
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Install Depth Anything V2
RUN git clone https://github.com/DepthAnything/Depth-Anything-V2.git /app/depth_anything_v2

# Install additional packages
RUN pip install --no-cache-dir opencv-python transformers

# Create checkpoints directory and download model
RUN mkdir -p /app/checkpoints
RUN wget -O /app/checkpoints/depth_anything_v2_vits.pth \
    "https://huggingface.co/depth-anything/Depth-Anything-V2-Small/resolve/main/depth_anything_v2_vits.pth?download=true"

# Copy application code
COPY . .

# Set Python path to include Depth-Anything-V2
ENV PYTHONPATH="/app:/app/Depth-Anything-V2"
ENV FLASK_APP=app.py
ENV FLASK_ENV=development
ENV PYTHONUNBUFFERED=1

EXPOSE 5050

# Health check for development
HEALTHCHECK --interval=30s --timeout=30s --start-period=90s --retries=3 \
    CMD curl -f http://localhost:5050/health || exit 1

# Use Flask development server (make sure your app.py uses host='0.0.0.0', port=5050)
CMD ["python", "app.py"]

# Production stage
FROM python:3.9-slim AS production

# Install system dependencies including curl for health checks
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Install Depth Anything V2
RUN git clone https://github.com/DepthAnything/Depth-Anything-V2.git /app/Depth-Anything-V2

# Install additional packages (no pip install -e . needed)
RUN pip install --no-cache-dir opencv-python transformers

# Create checkpoints directory and download model
RUN mkdir -p /app/checkpoints
RUN wget -O /app/checkpoints/depth_anything_v2_vits.pth \
    "https://huggingface.co/depth-anything/Depth-Anything-V2-Small/resolve/main/depth_anything_v2_vits.pth?download=true"

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app \
    && mkdir -p /home/app/.config/Ultralytics \
    && mkdir -p /home/app/.cache/torch \
    && mkdir -p /home/app/.cache/huggingface \
    && chown -R app:app /app \
    && chown -R app:app /home/app

# Switch to non-root user
USER app

# Set Python path and config directories
ENV PYTHONPATH="/app:/app/depth_anything_v2"
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1
ENV TORCH_HOME="/home/app/.cache/torch"
ENV HF_HOME="/home/app/.cache/huggingface"

EXPOSE 5050

# Health check for production
HEALTHCHECK --interval=30s --timeout=30s --start-period=90s --retries=3 \
    CMD curl -f http://localhost:5050/health || exit 1

# Use gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5050", "--workers", "1", "--timeout", "300", "--worker-class", "sync", "--max-requests", "100", "app:app"]