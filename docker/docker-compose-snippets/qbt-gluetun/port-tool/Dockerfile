FROM python:3.10-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install -U pip
RUN pip install -r requirements.txt

COPY . .

ENV QBT_USERNAME=admin
ENV QBT_PASSWORD=adminadmin
ENV QBT_HOST=host.docker.internal
ENV QBT_WEBUI_PORT=8080
ENV GLUETUN_HOST=host.docker.internal
ENV GLUETUN_CTRL_PORT=8000
ENV VERIFY_QBT_WEBUI_CERT='False'

CMD python -u main.py