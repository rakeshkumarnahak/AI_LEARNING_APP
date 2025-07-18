# Use official Python base image
FROM python:3.11-slim


# Install system deps
RUN apt-get update && apt-get install -y \
    gcc libpq-dev curl && \
    apt-get clean

# Set working directory
WORKDIR /app

# Install Python deps
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Collect static files (if needed)
# RUN python manage.py collectstatic --noinput

# Expose port 8080 (App Runner expects this port)
EXPOSE 8080

# Run migrations + start Gunicorn
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8080"]
