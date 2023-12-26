# Use the minimal Alpine-based Node.js image
FROM node:21-bookworm

USER root

# Add a non-root user and switch to it
#RUN adduser --disabled-password --gecos '' appuser

# Create a directory to hold the application code
WORKDIR /usr/src/app

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget firefox-esr -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Clone bpmn-auto-layout repository and install its dependencies
RUN git clone https://github.com/bpmn-io/bpmn-auto-layout.git \
    && cd bpmn-auto-layout \
    && npm install \
    #&& npm link \
    && cd .. \
    && rm -rf bpmn-auto-layout/.git 
    #&& npm link bpmn-auto-layout

# Copy the bpmn-auto-layout into node_modules
#RUN mv bpmn-auto-layout node_modules/

# Install express and body-parser
RUN npm install express body-parser bpmn-to-image

# Copy server.js and other necessary files into the container
COPY server.js .
#COPY package.json .
COPY public/ public/

#USER 1000
#ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/firefox
#ENV PUPPETEER_PRODUCT=firefox

# Expose port 3000 and start the server
EXPOSE 3000
CMD ["node", "--experimental-modules", "server.js"]
