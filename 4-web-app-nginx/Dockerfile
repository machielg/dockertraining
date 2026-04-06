FROM nginx

COPY index.html /usr/share/nginx/html
RUN hostname webserver
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]