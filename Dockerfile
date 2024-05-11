# Base image from Kubeflow's container registry with Jupyter and TensorFlow
FROM bigdata-150.kr-central-2.kcr.dev/kc-kubeflow/jupyter-tensorflow-cuda-full:v1.0.1.py38

# Ensure we are using root to perform system operations
USER root

# Update and install necessary system dependencies
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

# Resolve any dpkg issues from interrupted installs
RUN dpkg --configure -a

# Upgrade pip and install Python packages from requirements.txt
COPY requirements.txt /tmp/
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Install and update Node.js to a suitable version
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Set the initial working directory for the application
WORKDIR /app

# Assuming ComfyUI repository is cloned in the Docker context under /ComfyUI
# Navigate to the ComfyUI directory where package.json is located
WORKDIR /ComfyUI/test-ui

# Debug: List the contents of the directory to confirm files are present
RUN ls -la

# Additional debug step: Check if package.json is in the expected directory
RUN if [ ! -f package.json ]; then echo "package.json not found"; exit 1; fi

# Install JS dependencies
RUN npm install

# Optional: Run tests if necessary
# RUN npm run test

# Copy the entire contents of ComfyUI into the final working directory
COPY . /app

# Set environment variables for Kubeflow to recognize the JupyterLab as a proper UI
ENV NB_PREFIX /
ENV JUPYTER_ENABLE_LAB yes

# Expose port 8888 for JupyterLab
EXPOSE 8888

# Configure container to run Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''", "--NotebookApp.allow_origin='*'", "--NotebookApp.base_url=${NB_PREFIX}"]

# Switch back to the non-root user for security reasons
USER jovyan
