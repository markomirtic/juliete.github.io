# 🐳 Docker Setup for Habibi Eats

This document provides complete instructions for containerizing and running the Habibi Eats food delivery website using Docker.

## 📋 Prerequisites

### Install Docker
- **macOS**: Download [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/)
- **Windows**: Download [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)  
- **Linux**: Install via package manager:
  ```bash
  # Ubuntu/Debian
  sudo apt update && sudo apt install docker.io docker-compose
  
  # CentOS/RHEL
  sudo yum install docker docker-compose
  
  # Start Docker service
  sudo systemctl start docker
  sudo systemctl enable docker
  ```

### Verify Installation
```bash
docker --version
docker-compose --version
```

## 🚀 Quick Start

### Option 1: Using the Build Script (Recommended)
```bash
# Make the script executable (if not already)
chmod +x docker-build.sh

# Build and run the application
./docker-build.sh

# Or use specific commands:
./docker-build.sh build    # Build image only
./docker-build.sh run      # Run container
./docker-build.sh compose  # Use Docker Compose
```

### Option 2: Manual Docker Commands
```bash
# Build the image
docker build -t habibi-eats .

# Run the container
docker run -d --name habibi-eats-app -p 8080:80 habibi-eats

# Access the application
open http://localhost:8080
```

### Option 3: Using Docker Compose
```bash
# Start all services
docker-compose up -d --build

# Stop all services  
docker-compose down
```

## 🏗️ Docker Configuration

### Dockerfile Features
- **Base Image**: PHP 8.2 with Apache
- **Web Server**: Apache with mod_rewrite enabled
- **PHP Extensions**: mysqli, pdo, pdo_mysql for database connectivity
- **Security Headers**: X-Content-Type-Options, X-Frame-Options, X-XSS-Protection
- **Caching**: Static asset caching with proper expiration headers
- **Health Check**: Built-in health monitoring

### Container Structure
```
/var/www/html/           # Web root
├── index.html           # Homepage
├── menu.html            # Menu page
├── authentication.html  # Login/Registration
├── Admin.html           # Admin panel
├── Checkout-Flow.html   # Checkout process
├── assets/              # Static assets (CSS, JS, images)
└── forms/               # PHP form handlers
```

### Port Mapping
- **Host**: `http://localhost:8080`
- **Container**: Port 80 (Apache)

## 🔧 Configuration Options

### Environment Variables
The Docker Compose file supports these environment variables:

```yaml
environment:
  # PHP Configuration
  - PHP_UPLOAD_MAX_FILESIZE=10M
  - PHP_POST_MAX_SIZE=10M
  - PHP_MAX_EXECUTION_TIME=60
  
  # Email Configuration (for contact forms)
  - RECEIVING_EMAIL=your-email@example.com
  - SMTP_HOST=smtp.gmail.com
  - SMTP_USERNAME=your-username
  - SMTP_PASSWORD=your-app-password
  - SMTP_PORT=587
```

### Custom Configuration
1. **Change Port**: Modify the port mapping in `docker-compose.yml`:
   ```yaml
   ports:
     - "3000:80"  # Access via http://localhost:3000
   ```

2. **Development Mode**: Uncomment volume mounts for live file editing:
   ```yaml
   volumes:
     - ./public:/var/www/html:ro  # Live reload
   ```

3. **Email Setup**: Update environment variables with your SMTP details

## 📁 File Structure

### Generated Docker Files
```
.
├── Dockerfile              # Container configuration
├── docker-compose.yml      # Multi-service orchestration
├── .dockerignore          # Build context exclusions
├── docker-build.sh        # Build automation script
└── DOCKER.md             # This documentation
```

### Key Features
- **Multi-stage optimization**: Efficient container layering
- **Security hardening**: Non-root user, security headers
- **Development friendly**: Volume mounts for live editing
- **Production ready**: Health checks, restart policies

## 🔍 Development Workflow

### 1. Local Development
```bash
# Start with live file mounting
docker-compose up -d

# Make changes to files in ./public/, ./assets/, etc.
# Changes reflect immediately (if volumes are mounted)

# View logs
docker-compose logs -f habibi-eats
```

### 2. Testing Changes
```bash
# Rebuild after major changes
docker-compose down
docker-compose up -d --build

# Or rebuild just the image
docker build -t habibi-eats . --no-cache
```

### 3. Debugging
```bash
# Access container shell
docker exec -it habibi-eats-app bash

# Check Apache error logs
docker exec habibi-eats-app cat /var/log/apache2/error.log

# Check container health
docker inspect habibi-eats-app | grep -A 5 "Health"
```

## 📊 Monitoring and Logs

### Container Status
```bash
# Check running containers
docker ps

# View container resource usage
docker stats habibi-eats-app
```

### Logs
```bash
# Application logs
docker logs habibi-eats-app

# Follow logs in real-time
docker logs -f habibi-eats-app

# With Docker Compose
docker-compose logs -f
```

### Health Checks
The container includes built-in health monitoring:
- **Endpoint**: `http://localhost/`
- **Interval**: Every 30 seconds
- **Timeout**: 10 seconds
- **Start Period**: 40 seconds

## 🔒 Security Considerations

### Built-in Security
- Non-root user execution
- Security headers (XSS, Content-Type, Frame options)
- Minimal attack surface (only necessary ports exposed)
- Regular base image updates

### Production Recommendations
1. **Use HTTPS**: Set up reverse proxy with SSL/TLS
2. **Environment Variables**: Store sensitive data in environment files
3. **Network Isolation**: Use Docker networks
4. **Resource Limits**: Set memory and CPU constraints
5. **Regular Updates**: Keep base images updated

## 🐛 Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check build logs
docker build -t habibi-eats . --progress=plain

# Check container logs
docker logs habibi-eats-app
```

#### Port Already in Use
```bash
# Find what's using the port
lsof -i :8080

# Use a different port
docker run -d --name habibi-eats-app -p 3000:80 habibi-eats
```

#### Permission Issues (Linux)
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in

# Or run with sudo
sudo docker run -d --name habibi-eats-app -p 8080:80 habibi-eats
```

#### PHP Forms Not Working
1. Verify PHP extensions are installed:
   ```bash
   docker exec habibi-eats-app php -m
   ```
2. Check Apache error logs:
   ```bash
   docker exec habibi-eats-app cat /var/log/apache2/error.log
   ```
3. Ensure proper file permissions

### Performance Tuning
```bash
# Limit resources
docker run -d \
  --name habibi-eats-app \
  --memory=512m \
  --cpus=1.0 \
  -p 8080:80 \
  habibi-eats
```

## 🔄 Deployment Options

### Local Development
Use the provided `docker-compose.yml` as-is.

### Production Deployment
1. **Cloud Platforms**: Deploy to AWS ECS, Google Cloud Run, Azure Container Instances
2. **Container Orchestration**: Use Kubernetes, Docker Swarm
3. **Reverse Proxy**: Set up Nginx/Apache reverse proxy with SSL
4. **Database**: Add MySQL/PostgreSQL service to docker-compose.yml

### Example Production docker-compose.yml
```yaml
version: '3.8'
services:
  habibi-eats:
    image: habibi-eats:latest
    restart: always
    environment:
      - RECEIVING_EMAIL=${RECEIVING_EMAIL}
      - SMTP_HOST=${SMTP_HOST}
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.habibi-eats.rule=Host(\`yourdomain.com\`)"
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PHP Docker Official Images](https://hub.docker.com/_/php)
- [Apache Configuration](https://httpd.apache.org/docs/)

## 🤝 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review container logs: `docker logs habibi-eats-app`
3. Verify Docker installation: `docker --version`
4. Ensure ports aren't conflicts: `lsof -i :8080`

---

**Happy Dockerizing! 🍽️🐳**