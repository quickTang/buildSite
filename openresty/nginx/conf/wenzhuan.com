#lua_package_path "/usr/local/openresty/luascript/wenzhuan.com/?.lua;;";

log_format log_wz '"$http_version"\t"$http_selfUserId"\t"$status"\t"$time_local"\t"$request_time"\t"$upstream_response_time"\t"$http_sign"\t"$http_x_forwarded_for"\t"$remote_addr"\t"$host"\t"$http_Authorization"\t"$resp_body"\t"$request_body"\t"$request_method"\t"$uri"\t"$query_string"\t"$body_bytes_sent"\t"$http_referer"\t"$bytes_sent"\t"$upstream_status"\t"$upstream_addr"\t"$http_clientType"\t"$http_user_agent"';


server
{
     listen 80;
	 listen 443 ssl;
     server_name 39.106.120.112;
     root /usr/local/openresty/nginx/html;
     index index.htm index.html index.php; #默认文件

     valid_referers server_names;
     if ($invalid_referer) {
           set $ua U;
     }
     
     limit_req zone=iwanvi_req burst=20 nodelay;

        #location ~ ^/$ {
        #       add_header Content-Type "text/plain;charset=utf-8";
        #       return 200;
       # }
          lua_need_request_body on;
     set $resp_body "";
     #set $req_body ""; 


    body_filter_by_lua '
        local resp_body = string.sub(ngx.arg[1], 1, 1000)
        ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body
        if ngx.arg[2] then
             ngx.var.resp_body = ngx.ctx.buffered
        end
    ';
        location = /api/list/tingshu {
                default_type application/json;
               content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/listtingshu.lua;
        }
		location = /api/list/kanshu {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/listkanshu.lua;
		}
		location = /api/get/tingshu {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/gettingshu.lua;
		}
		location = /api/get/kanshu {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/getkanshu.lua;
		}
		location = /api/listmulu/tingshu {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/listmulutingshu.lua;
		}
		location = /api/listmulu/kanshu {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/listmulukanshu.lua;
		}
		location = /api/user/my {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/info.lua;
		}
		location = /api/read/up {
		default_type application/json;
		content_by_lua_file /usr/local/openresty/luascript/wenzhuan.com/readup.lua;
		}
       #默认请求
        location ~ ^/$  { 
            #定义首页索引文件的名称
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


access_log  /apolo-data/nginx-log/wenzhuan.com/access.log log_wz;
error_log  /apolo-data/nginx-log/wenzhuan.com/error.log;
}
