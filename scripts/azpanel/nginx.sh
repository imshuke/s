#!/bin/bash
apt update -y
apt install -y git
git clone https://github.com/azpanel/azpanel.git /azpanel
echo 'user  root;

worker_processes auto;
worker_cpu_affinity auto;

error_log  /azpanel/nginx_error.log  crit;

pid        /run/nginx.pid;

#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 51200;

events
    {
        use epoll;
        worker_connections 51200;
        multi_accept off;
        accept_mutex off;
    }

http
    {
        include       mime.types;
        default_type  application/octet-stream;

        server_names_hash_bucket_size 128;
        client_header_buffer_size 32k;
        large_client_header_buffers 4 32k;
        client_max_body_size 50m;

        sendfile on;
        sendfile_max_chunk 512k;
        tcp_nopush on;

        keepalive_timeout 60;

        tcp_nodelay on;

        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        fastcgi_buffer_size 64k;
        fastcgi_buffers 4 64k;
        fastcgi_busy_buffers_size 128k;
        fastcgi_temp_file_write_size 256k;

        gzip on;
        gzip_min_length  1k;
        gzip_buffers     4 16k;
        gzip_http_version 1.1;
        gzip_comp_level 2;
        gzip_types     text/plain application/javascript application/x-javascript text/javascript text/css application/xml application/xml+rss;
        gzip_vary on;
        gzip_proxied   expired no-cache no-store private auth;
        gzip_disable   "MSIE [1-6]\.";

        #limit_conn_zone $binary_remote_addr zone=perip:10m;
        ##If enable limit_conn_zone,add "limit_conn perip 10;" to server section.

        server_tokens off;
        access_log off;

server
    {
        listen 80 default_server reuseport;
        #listen [::]:80 default_server ipv6only=on;
        server_name _;
        index index.html index.htm index.php default.html default.htm default.php;
        root  /azpanel/public;

        location / {
            if (!-e $request_filename) {
                rewrite ^(.*)$ /index.php?s=/$1 last;
                break;
            }
        }

        location ~ [^/]\.php(/|$)
        {
            try_files $uri =404;
            fastcgi_pass  php:9000;
            fastcgi_index index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include fastcgi_params;
        }

        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires      30d;
        }

        location ~ .*\.(js|css)?$
        {
            expires      12h;
        }

        location ~ /.well-known {
            allow all;
        }

        location ~ /\.
        {
            deny all;
        }

        access_log  /azpanel/azpanel.log;    
    }
}' > /etc/nginx/nginx.conf

echo "nginx running...."
nginx -g "daemon off;"
