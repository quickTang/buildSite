log_format log_qm '"$remote_addr"\t"$http_sign"\t"$http_time"\t"$status"\t"$time_local"\t"$request_time"\t"$upstream_response_time"\t"$http_x_forwarded_for"\t"$remote_addr"\t"$host"\t"$http_Authorization"\t"$resp_body"\t"$request_body"\t"$request_method"\t"$uri"\t"$query_string"\t"$body_bytes_sent"\t"$http_referer"\t"$bytes_sent"\t"$upstream_status"\t"$upstream_addr"\t"$http_clientType"\t"$http_user_agent"';

 upstream rocktckj.com {
	server 127.0.0.1:7082 weight=1 max_fails=2 fail_timeout=60s;
}

server
{
       
     listen 80;
	 listen 443 ssl;
     server_name rocktckj.com  www.rocktckj.com tonghukj.com www.tonghukj.com;
     root /usr/local/openresty/nginx/html;
     index index.htm index.html index.php; #默认文件
#	 if ($host != 'www.rocktckj.com') {
#		rewrite ^/(.*)$ http://www.baidu.com/$1 permanent;
#	 }

	valid_referers server_names;
     if ($invalid_referer) {
           set $ua U;
     }
     limit_req zone=iwanvi_req burst=20 nodelay;


		lua_need_request_body on;
		set $resp_body "";

        body_filter_by_lua '
        local resp_body = string.sub(ngx.arg[1], 1, 1000)
        ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body
        if ngx.arg[2] then
             ngx.var.resp_body = ngx.ctx.buffered
        end
        ';
#		location ／  {
#		 rewrite  ^/(.*)$  http://www.rocktckj.com/guanwang/index.html  permanent;
#		#return 500;
#		}
		location = /home/init/ad {
		default_type application/json;
		lua_code_cache on;
		content_by_lua_file /usr/local/openresty/luascript/rocktckj.com/initad.lua;
		}
		#默认请求
       location ~ ^/$  {
		#     #定义首页索引文件的名称
		      root /usr/local/openresty/nginx/html;
		}


    
	#location ~* ^.+\.(js|css|png|jpg|gif)$ {
	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|ico|js|css)$ {
		root /usr/local/openresty/nginx/html;
		proxy_temp_path /usr/local/openresty/nginx/html;
		access_log   off;
		expires      30d;
    }
	
	location = /favicon.ico{
		access_log off;
		log_not_found off;
	}


access_log  /data/nginx-log/rocktckj.com/access.log log_qm;
error_log  /data/nginx-log/rocktckj.com/error.log;
}
