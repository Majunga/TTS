ARG BASE=nvidia/cuda:11.8.0-base-ubuntu22.04
FROM ${BASE}

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends gcc g++ make python3 python3-dev python3-pip python3-venv python3-wheel espeak-ng libsndfile1-dev && rm -rf /var/lib/apt/lists/*
RUN pip3 install llvmlite --ignore-installed

# Install Dependencies:
RUN pip3 install torch torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
RUN rm -rf /root/.cache/pip

# Copy TTS repository contents:
WORKDIR /root
COPY . /root

RUN make install
ENV CUDA_VISIBLE_DEVICES=0
ENTRYPOINT ["python3", "TTS/server/server.py", "--model_path", "/root/.local/share/tts/tts_models--multilingual--multi-dataset--xtts_v2", "--config_path", "/root/.local/share/tts/tts_models--multilingual--multi-dataset--xtts_v2/config.json", "--use_cuda", "true"]
