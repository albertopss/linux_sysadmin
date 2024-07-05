# Dockerfile for DNSChef

# Use the official Python image from Docker Hub
FROM python:3.8-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install DNSChef and its dependencies
RUN pip install dnschef

# Expose DNSChef port (default is 53)
EXPOSE 53

# Specify the command to run DNSChef when the container starts
CMD ["dnschef", "--interface", "0.0.0.0", "--fakeip", "YOUR_IP_HERE"]
