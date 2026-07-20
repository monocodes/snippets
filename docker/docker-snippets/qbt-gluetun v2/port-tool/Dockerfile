FROM python:3.10-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV QBT_USERNAME=admin
ENV QBT_PASSWORD=adminadmin
ENV QBT_HOST=qbt
ENV QBT_WEBUI_PORT=8080
ENV VERIFY_QBT_WEBUI_CERT='False'

ENV GLUETUN_PORT_FILE='/tmp/gluetun/forwarded_port'

CMD ["python", "-u", "main.py"]