FROM python:3.9-slim AS base_image
ENV PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

ARG USERNAME=container
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG WORK_DIR=/home/$USERNAME

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --create-home --shell /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME
WORKDIR $WORK_DIR

COPY --chown=$USERNAME . .

ENV VENV_PATH=$WORK_DIR/venv
ENV PATH="$VENV_PATH/bin:$PATH"
RUN python -m venv $VENV_PATH

RUN python -m pip install -r requirements.txt

CMD ["python", "main.py"]
