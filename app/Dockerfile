# Base Image 
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json* /.
RUN npm install

# Copy the rest of the app source code
COPY . .

# Expose the port
EXPOSE 3000

# Start the app 
CMD ["npm", "start"]