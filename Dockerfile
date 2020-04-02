# ========================== Prepare ===========================
FROM openjdk:11-jre-slim AS prepare

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget unzip

RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip
RUN wget -q -O /tmp/chrome_key.pub https://dl.google.com/linux/linux_signing_key.pub 
RUN unzip /tmp/chromedriver.zip -d /tmp

# ========================= Main image =========================
FROM openjdk:11-jre-slim

LABEL maintainer="Pawel <inne.poczta@gmail.com>"

COPY --from=prepare /tmp/chromedriver /usr/local/bin/
COPY --from=prepare /tmp/chrome_key.pub /tmp/chrome_key.pub

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends gnupg

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-key add /tmp/chrome_key.pub && \
    apt-get update && \
    apt-get install -y --no-install-recommends google-chrome-stable

USER 65534
