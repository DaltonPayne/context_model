# Use an official Python runtime as a parent image
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

# Set the working directory in the container
WORKDIR /app

# Increase the file descriptor limit
RUN ulimit -n 65536

# Copy the current directory contents into the container at /app
COPY . /app

RUN pip3 install --no-cache-dir \
    torch==2.1.0 \
    torchvision==0.16.0 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install additional required packages
RUN pip install --no-cache-dir transformers pillow accelerate psutil

# Download and cache the model and tokenizer
RUN python -c "from transformers import AutoModel, AutoTokenizer; \
    AutoModel.from_pretrained('openbmb/MiniCPM-Llama3-V-2_5', trust_remote_code=True); \
    AutoTokenizer.from_pretrained('openbmb/MiniCPM-Llama3-V-2_5', trust_remote_code=True)"

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable using the correct format
ENV NAME=World

# Run handler.py when the container launches
CMD ["python", "handler.py"]
