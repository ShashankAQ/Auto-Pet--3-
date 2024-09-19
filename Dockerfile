FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-runtime


RUN groupadd -r algorithm && \
    useradd -m --no-log-init -r -g algorithm algorithm && \
    mkdir -p /opt/algorithm /input /output /output/images/automated-petct-lesion-segmentation && \
    chown -R algorithm:algorithm /opt/algorithm /input /output


RUN apt-get update && apt-get install -y curl dos2unix

# Switch to the algorithm user
USER algorithm

# Set working directory
WORKDIR /opt/algorithm

# Update PATH environment variable
ENV PATH="/home/algorithm/.local/bin:${PATH}"

# Copy necessary files and set ownership
COPY --chown=algorithm:algorithm requirements.txt /opt/algorithm/
COPY --chown=algorithm:algorithm process.py /opt/algorithm/
COPY --chown=algorithm:algorithm model.py /opt/algorithm/
COPY --chown=algorithm:algorithm model2.py /opt/algorithm/
COPY --chown=algorithm:algorithm dataset.py /opt/algorithm/
COPY --chown=algorithm:algorithm utils.py /opt/algorithm/
COPY --chown=algorithm:algorithm download_model_weights.sh /opt/algorithm/
COPY --chown=algorithm:algorithm input/images/ct /opt/algorithm/input/images/ct
COPY --chown=algorithm:algorithm input/images/pet /opt/algorithm/input/images/pet
#COPY --chown=algorithm:algorithm /output/images/automated-petct-lesion-segmentation /opt/algorithm/output/images/automated-petct-lesion-segmentation
RUN dos2unix /opt/algorithm/download_model_weights.sh

# Install Python requirements
RUN python -m pip install --user -U pip && \
    python -m pip install --user -r requirements.txt && \
    mkdir -p /opt/algorithm/nnUNet_raw && \
    mkdir -p /opt/algorithm/nnUNet_preprocessed && \
    mkdir -p /opt/algorithm/nnUNet_raw_data_base/nnUNet_raw_data/Task001_TCIA/imagesTs && \
    mkdir -p /opt/algorithm/nnUNet_raw_data_base/nnUNet_raw_data/Task001_TCIA/result

# Define environment variables for nnUNet paths
ENV nnUNet_raw="/opt/algorithm/nnUNet_raw"
ENV nnUNet_preprocessed="/opt/algorithm/nnUNet_preprocessed"
ENV nnUNet_results="/opt/algorithm/nnUNet_results"

# Entry point for the container
ENTRYPOINT ["python", "-m", "process", "$0", "$@"]
