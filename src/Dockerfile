# syntax=docker/dockerfile:1.4
FROM python:3.11-slim
# FROM public.ecr.aws/docker/library/python:3.11.9-slim

WORKDIR /app

COPY . .

RUN pip3 install -r requirements.txt

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
