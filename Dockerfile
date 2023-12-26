# Use the minimal Alpine-based Node.js image
FROM ubuntu:22.04

RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y nano less git curl \
          make ca-certificates gnupg \ 
          #libglib2.0-0 libnss3 \
          glib2.0 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
          libdbus-1-3 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 \
          libgbm1 libasound2 libpango-1.0-0 libcairo2 libatspi2.0-0 libgtk-3-0

RUN mkdir -p /etc/apt/keyrings && \
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install nodejs -y

#USER root

# Add a non-root user and switch to it
#RUN useradd -m user
#RUN adduser --disabled-password --gecos '' appuser

# Create a directory to hold the application code
WORKDIR /usr/src/app

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
#RUN apt-get update && apt-get install gnupg wget firefox-esr -y && \
#  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
#  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
#  apt-get update && \
#  apt-get install google-chrome-stable -y --no-install-recommends && \
#  rm -rf /var/lib/apt/lists/*

# Clone bpmn-auto-layout repository and install its dependencies
#RUN git clone https://github.com/bpmn-io/bpmn-auto-layout.git \
#    && cd bpmn-auto-layout \
#    && npm install \
#    #&& npm link \
#    && cd .. \
#    && rm -rf bpmn-auto-layout/.git 
#    #&& npm link bpmn-auto-layout

# Copy the bpmn-auto-layout into node_modules
#RUN mv bpmn-auto-layout node_modules/

# Install express and body-parser
#RUN npm install express body-parser bpmn-to-image

# Copy server.js and other necessary files into the container
COPY server.js .
COPY package.json .
COPY public/ public/
#COPY set-puppeteer.sh .

#USER 1000
#ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome
#ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/firefox
#ENV PUPPETEER_PRODUCT=firefox


#RUN chown -R user:user /usr/src/app
#RUN chmod a+x ./set-puppeteer.sh

# Switch to 'user'
#USER user
#ENV NPM_CONFIG_CACHE=/usr/src/app/.npm
#ENV NPM_CONFIG_PREFIX=/usr/src/app/.npm-global
RUN npm install

# Expose port 3000 and start the server
EXPOSE 3000

#ENTRYPOINT ["/usr/src/app/set-puppeteer.sh"]
CMD ["node", "--experimental-modules", "server.js"]
