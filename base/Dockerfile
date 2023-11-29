ARG BASE_IMAGE
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV SHELL=/bin/bash \
    PYTHONUNBUFFERED=True \
    DEBIAN_FRONTEND=noninteractive \
    HF_HOME="/runpod-volume/.cache/huggingface/" \
    HF_DATASETS_CACHE="/runpod-volume/.cache/huggingface/datasets/" \
    DEFAULT_HF_METRICS_CACHE="/runpod-volume/.cache/huggingface/metrics/" \
    DEFAULT_HF_MODULES_CACHE="/runpod-volume/.cache/huggingface/modules/" \
    HUGGINGFACE_HUB_CACHE="/runpod-volume/.cache/huggingface/hub/" \
    HUGGINGFACE_ASSETS_CACHE="/runpod-volume/.cache/huggingface/assets/" \
    HF_HUB_ENABLE_HF_TRANSFER="1" 

WORKDIR /

# Update, upgrade, install packages and clean up
RUN apt-get update --yes && \
    apt-get upgrade --yes && \

    # Basic Utilities
    apt install --yes --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    file \
    git \
    inotify-tools \
    libgl1 \
    vim \
    nginx \
    openssh-server \
    procps \
    rsync \
    sudo \
    software-properties-common \
    unzip \
    wget \
    zip && \

    # Build Tools and Development
    apt install --yes --no-install-recommends \
    build-essential \
    make \
    cmake \
    libblas-dev \
    liblapack-dev \
    libffi-dev \
    libhdf5-serial-dev \
    libssl-dev \
    libopencv-dev \
    tesseract-ocr \
    libtesseract-dev && \

    # File Systems and Storage
    apt install --yes --no-install-recommends \
    cifs-utils \
    nfs-common && \

    # Install python
    apt-get install --yes --no-install-recommends \
    python3-pip \
    python3-dev && \

    update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    ln -s $(which pip3) /usr/local/bin/pip && \

    # Cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \

    # Set locale
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Install poetry
RUN pip install --upgrade pip && \
    pip install poetry==1.7.1 && \
    poetry config virtualenvs.create false

# pip bug fix
RUN rm -r ~/.cache/pip/selfcheck/

# NGINX Proxy
COPY --from=proxy nginx.conf /etc/nginx/nginx.conf
COPY --from=proxy readme.html /usr/share/nginx/html/readme.html

# Copy the README.md
COPY README.md /usr/share/nginx/html/README.md

# Start Scripts
COPY --from=scripts start.sh /
COPY post_start.sh /
RUN chmod +x /start.sh && \
    chmod +x /post_start.sh

# Welcome Message
COPY --from=logo runpod.txt /etc/runpod.txt
RUN echo 'cat /etc/runpod.txt' >> /root/.bashrc
RUN echo 'echo -e "\nFor detailed documentation and guides, please visit:\n\033[1;34mhttps://docs.runpod.io/\033[0m and \033[1;34mhttps://blog.runpod.io/\033[0m\n\n"' >> /root/.bashrc

CMD ["/start.sh"]
