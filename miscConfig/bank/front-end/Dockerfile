# Usa un'immagine base di Nginx per servire i file statici
FROM nginx:alpine
 
# Copia i file HTML, CSS e immagine nella cartella di Nginx
COPY dashboard.html /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/
COPY register.html /usr/share/nginx/html/
COPY transfer.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
COPY logo.png /usr/share/nginx/html/
  
  
# Copia il file nginx.conf personalizzato
COPY nginx.conf /etc/nginx/nginx.conf  

# Espone la porta 80 per il server web
EXPOSE 80
