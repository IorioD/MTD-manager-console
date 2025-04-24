# Usa una versione di Python come base
FROM python:3.9

# Imposta la directory di lavoro all'interno del container
WORKDIR /app

# Copia i file del progetto nel container
COPY app.py /app
COPY requirements.txt /app

# Installa le dipendenze del progetto
RUN pip install --no-cache-dir -r requirements.txt

# Esponi la porta su cui il server Gunicorn girerà
EXPOSE 5000

# Avvia il server Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]