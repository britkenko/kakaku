# Use an official TensorFlow CUDA full image as a parent image
FROM bigdata-150.kr-central-2.kcr.dev/kc-kubeflow/jupyter-tensorflow-cuda-full:v1.0.1.py38

# Set a working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    dpkg \
    git \
    curl \
    ca-certificates \
    bzip2 \
    libx11-6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install any additional packages
RUN pip install --upgrade pip && \
    pip install flask django numpy pandas scipy matplotlib seaborn jupyterlab

# Install Node.js for any potential frontend requirements
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install -y nodejs

# Copy the local code to the container
COPY . /app

# Set the command to run on container start
CMD ["python", "main.py"]
