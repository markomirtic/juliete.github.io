#!/bin/bash

# Habibi Eats Docker Build and Run Script
echo "🍽️  Habibi Eats Docker Build Script"
echo "================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first:"
    echo "   🐳 macOS: Download Docker Desktop from https://docker.com/products/docker-desktop"
    echo "   🐧 Linux: sudo apt-get install docker.io (Ubuntu/Debian) or sudo yum install docker (RHEL/CentOS)"
    echo "   🪟 Windows: Download Docker Desktop from https://docker.com/products/docker-desktop"
    exit 1
fi

# Function to build the Docker image
build_image() {
    echo "🏗️  Building Habibi Eats Docker image..."
    docker build -t habibi-eats .
    
    if [ $? -eq 0 ]; then
        echo "✅ Docker image built successfully!"
    else
        echo "❌ Failed to build Docker image"
        exit 1
    fi
}

# Function to run the Docker container
run_container() {
    echo "🚀 Starting Habibi Eats container..."
    
    # Stop any existing container
    docker stop habibi-eats-app 2>/dev/null
    docker rm habibi-eats-app 2>/dev/null
    
    # Run the new container
    docker run -d \
        --name habibi-eats-app \
        -p 8080:80 \
        habibi-eats
    
    if [ $? -eq 0 ]; then
        echo "✅ Container started successfully!"
        echo "🌐 Access your application at: http://localhost:8080"
        echo ""
        echo "📋 Container status:"
        docker ps --filter name=habibi-eats-app
        echo ""
        echo "📝 To view logs: docker logs habibi-eats-app"
        echo "🛑 To stop: docker stop habibi-eats-app"
    else
        echo "❌ Failed to start container"
        exit 1
    fi
}

# Function to use docker-compose
run_with_compose() {
    echo "🐳 Starting with Docker Compose..."
    
    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose is not installed. Using regular docker run instead..."
        run_container
        return
    fi
    
    docker-compose down 2>/dev/null
    docker-compose up -d --build
    
    if [ $? -eq 0 ]; then
        echo "✅ Docker Compose services started successfully!"
        echo "🌐 Access your application at: http://localhost:8080"
        echo ""
        echo "📝 To view logs: docker-compose logs -f"
        echo "🛑 To stop: docker-compose down"
    else
        echo "❌ Failed to start services with Docker Compose"
        exit 1
    fi
}

# Main menu
case "${1:-menu}" in
    "build")
        build_image
        ;;
    "run")
        run_container
        ;;
    "compose")
        run_with_compose
        ;;
    "all"|"")
        build_image
        echo ""
        run_container
        ;;
    "menu"|*)
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  build      - Build the Docker image only"
        echo "  run        - Run the container (builds first if needed)"
        echo "  compose    - Use Docker Compose to start services"
        echo "  all        - Build and run (default)"
        echo ""
        echo "Examples:"
        echo "  ./docker-build.sh build"
        echo "  ./docker-build.sh run" 
        echo "  ./docker-build.sh compose"
        echo "  ./docker-build.sh        # Builds and runs"
        ;;
esac