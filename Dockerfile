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

<<<<<<< HEAD
# Create necessary directories for APT if they don't exist and set permissions
=======
# Create necessary directories for APT if they don't exist
>>>>>>> 4071c2ad0364a197fe3d4f92d4870c7de482865d
RUN mkdir -p /var/lib/apt/lists/partial && \
    chmod -R 777 /var/lib/apt/lists

# Install Node.js from the NodeSource binary distributions
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs

<<<<<<< HEAD
# Clean up APT when done
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

=======
>>>>>>> 4071c2ad0364a197fe3d4f92d4870c7de482865d
# Optionally switch back to the original user (from Jupyter base image)
USER $NB_UID
