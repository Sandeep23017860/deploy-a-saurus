# Step 1: Use an official Python runtime as a parent image.
# We use 'slim' because it's a smaller version, making our image faster to download.
FROM python:3.9-slim

# Step 2: Set the working directory inside the container to /app.
# All subsequent commands will run from this directory.
WORKDIR /app

# Step 3: Copy the dependencies file first.
# This is a key optimization. Docker layers are cached. If requirements.txt doesn't change,
# Docker will reuse the cached layer from a previous build, speeding things up.
COPY requirements.txt .

# Step 4: Install the dependencies.
# --no-cache-dir saves space in the final image.
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Copy the rest of your application's code into the container.
COPY . .

# Step 6: Set environment variables for Flask.
# This tells the 'flask' command which file to run and makes it accessible
# outside the container.
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Step 7: Expose the port the app runs on.
# Flask's default port is 5000.
EXPOSE 5000

# Step 8: Define the command to run your app.
# This is what executes when the container starts.
CMD ["flask", "run"]