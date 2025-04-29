FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

# Install aria2 for fast multi-segment downloads
RUN apt-get update && \
    apt-get install apt-utils && \
    apt-get install -y aria2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY download.sh /usr/local/bin/download.sh
RUN chmod +x /usr/local/bin/download.sh

ENTRYPOINT ["/usr/local/bin/download.sh"]
