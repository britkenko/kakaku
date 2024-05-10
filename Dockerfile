FROM bigdata-150.kr-central-2.kcr.dev/kc-kubeflow/jupyter-tensorflow-cuda-full:v1.0.1.py38

WORKDIR /app

# Update and install system dependencies
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

# Upgrade pip and install Python packages
RUN pip install --upgrade pip && \
    pip install flask django numpy pandas scipy matplotlib seaborn jupyterlab

# Install Node.js for frontend requirements
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install -y nodejs

# Copy the local code to the container
COPY . /app

# Set the command to run on container start
CMD ["python", "main.py"]

# Set environment variables for Kubeflow to recognize the JupyterLab as a proper UI
ENV NB_PREFIX /
ENV JUPYTER_ENABLE_LAB=yes

# Expose port 8888 for JupyterLab
EXPOSE 8888

# Configure container to be compatible with Kubeflow's Jupyter web interface
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''", "--NotebookApp.allow_origin='*'", "--NotebookApp.base_url=${NB_PREFIX}"]
