# Use Jupyter's scipy notebook with Python 3.11 as the base image
FROM jupyter/scipy-notebook:python-3.11 as base

# Set the working directory
WORKDIR /app

# Copy the requirements file and pre-build check script to the container
COPY requirements.txt pre_build_check.sh /app/

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the ComfyUI project into the container
COPY ComfyUI/tests-ui /app/ComfyUI

# Change the working directory to ComfyUI
WORKDIR /app/ComfyUI

# Run pre-build checks
RUN /app/pre_build_check.sh

# Ensure user is root for package installations
USER root

# Create necessary directories for APT if they don't exist
RUN mkdir -p /var/lib/apt/lists/partial && \
    chmod -R 777 /var/lib/apt/lists

# Install Node.js from the NodeSource binary distributions
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs

# Optionally switch back to the original user (from Jupyter base image)
USER $NB_UID
