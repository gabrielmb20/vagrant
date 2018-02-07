# Varnish 4.1.1-1ubuntu0.2
vcl 4.0;


# Imports
import std;
import directors;   
# --------------------------------------------------------------------------------------------
# Pruebas de Salud (Health Check) sobre los Backends
# --------------------------------------------------------------------------------------------
probe backend_healthcheck {
	# Se veririca accediendo la / del sitio web
	.url = "/";
	# Una respuesta que tarde más de 10s indicaría que el backend no está con problemas
	.timeout = 20s;
	# Se realizan 6 pruebas en total
   	.window = 5;
	# Si 3 de las 6 pruebas fallan, se considera enfermo (sick) al backend
   	.threshold = 3;
	# Cada 15s se realizan las pruebas
   	.interval = 20s;
}


backend joomla01 {
        .host = "10.20.30.43";
        .port = "80";
        .connect_timeout = 20s;
	.probe = backend_healthcheck;
}

backend joomla02 {
	.host = "10.20.30.44";
        .port = "80";
        .connect_timeout = 20s;
	.probe = backend_healthcheck;
}

backend app01 {
        .host = "10.20.30.47";
        .port = "3000";
        .connect_timeout = 15s;
        .probe = backend_healthcheck;
}


backend app02 {
        .host = "10.20.30.48";
        .port = "3000";
        .connect_timeout = 15s;
        .probe = backend_healthcheck;
}

# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
sub vcl_init {
    	new rsn_joomla_director = directors.round_robin();
    	rsn_joomla_director.add_backend(joomla01);
	rsn_joomla_director.add_backend(joomla02);
	
	new rsn_app_director = directors.round_robin();
	rsn_app_director.add_backend(app01);
	rsn_app_director.add_backend(app02);

} # Fin vcl_init


# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
sub vcl_recv {
	if (req.http.host ~ "(?i)^(www.)?rsn.ucr.ac.cr") {
        	set req.http.host = "rsn.ucr.ac.cr";
                set req.backend_hint = rsn_joomla_director.backend();

        }
        elsif (req.http.host ~ "(?i)^(rsnapiusr.)?ucr.ac.cr") {
                set req.http.host = "rsnapiusr.ucr.ac.cr";
                set req.backend_hint = rsn_app_director.backend();
        }

# -------------------------------------------------------------------------------------------------------------------------

    # Non-RFC2616 or CONNECT which is weird.
	if (
        	req.method != "GET" &&
	        req.method != "HEAD" &&
        	req.method != "PUT" &&
	        req.method != "POST" &&
        	req.method != "TRACE" &&
	        req.method != "OPTIONS" &&
        	req.method != "DELETE"
    	) {
        	return (pipe);
	} 

    	# We only deal with GET and HEAD by default
	if (req.method != "GET" && req.method != "HEAD") {
        	return (pass);
    	}	

	# Don't cache HTTP authorization/authentication pages and pages with certain headers or cookies
    	if (
        	req.http.Authorization ||
        	req.http.Authenticate ||
        	req.http.X-Logged-In == "True" ||
        	req.http.Cookie ~ "userID" ||
        	req.http.Cookie ~ "joomla_[a-zA-Z0-9_]+"
    	) {
        return (pass);
    	}

    	if(
        	req.url ~ "^/administrator" ||
        	req.url ~ "^/component/banners" ||
        	req.url ~ "^/component/socialconnect" ||
        	req.url ~ "^/component/users" ||
        	req.url ~ "^/contact" ||
        	req.url ~ "^/connect" 
    	) {
        	return (pass);
    	}

    	# No almacenar en caché las solicitudes ajax
    	if(req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache") {
        	return (pass);
    	}

	# Compruebe el encabezado "X-Logged-In" (usado por K2 y otras aplicaciones) para identificar si el visitante es un invitado, 
	# luego elimine cualquier cookie (incluidas las cookies de sesión) siempre que no se trate de una solicitud POST.

    	if(req.http.X-Logged-In == "False" && req.method != "POST") {
        	unset req.http.Cookie;
    	}

    	# Manejar correctamente distintos tipos de codificación
    	if (req.http.Accept-Encoding) {
      		if (req.url ~ "\.(jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf)$") {
        	# No point in compressing these
        	unset req.http.Accept-Encoding;
      		} 
		elseif (req.http.Accept-Encoding ~ "gzip") {
        		set req.http.Accept-Encoding = "gzip";
      		} 
		elseif (req.http.Accept-Encoding ~ "deflate") {
        		set req.http.Accept-Encoding = "deflate";
      		} 
		else {
        		# unknown algorithm (aka crappy browser)
        		unset req.http.Accept-Encoding;
      		}		
    	}

    	# Cache files with these extensions
    	#if (req.url ~ "\.(js|css|jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf)$") {
    	#	return (hash);
    	#}

    	# Remove all cookies for static files & deliver directly
    	if (
		req.url ~ "^[^?]*\.(7z|avi|bmp|bz2|css|csv|doc|docx|eot|flac|flv|gif|gz|ico|jpeg|jpg|js|less|mka|mkv|mov|mp3|mp4|mpeg|mpg|odt|ogg|ogm|opus|otf|pdf|png|ppt|pptx|rar|rtf|svg|svgz|swf|tar|tbz|tgz|ttf|txt|txz|wav|webm|webp|woff|woff2|xls|xlsx|xml|xz|zip)(\?.*)?$"
	){
        	unset req.http.Cookie;
        	return (hash);
    	}

	return (hash);

} # Fin vcl_recv


# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
sub vcl_backend_response {
    	# No almacenar en caché respuestas 50x
    	if (
        	beresp.status == 500 ||
        	beresp.status == 502 ||
        	beresp.status == 503 ||
 		beresp.status == 504
    	) {
        	return (abandon);
    	}

    	if(
        	bereq.url ~ "^/administrator" ||
	        bereq.url ~ "^/component/banners" ||
        	bereq.url ~ "^/component/socialconnect" ||
	        bereq.url ~ "^/component/users" ||
        	bereq.url ~ "^/contact" ||
	        bereq.url ~ "^/connect" 
    	) {
        	set beresp.uncacheable = true;
	        return (deliver);
    	}

    	# No almacenar en caché páginas de autorización/autenticación HTTP y páginas con ciertos encabezados o cookies
    	if (
        	bereq.http.Authorization ||
        	bereq.http.Authenticate ||
        	bereq.http.X-Logged-In == "True" ||
	        bereq.http.Cookie ~ "userID" ||
        	bereq.http.Cookie ~ "joomla_[a-zA-Z0-9_]+" 
    	) {
        	set beresp.uncacheable = true;
	        return (deliver);
   	}

    	# Permitir contenido obsoleto, en caso de que el backend se caiga
    	set beresp.grace = 24h;

    	# Cuánto tiempo Varnish mantendrá el contenido en caché
    	set beresp.ttl = 60s;

   	if (
		bereq.url ~ "^[^?]*\.(7z|avi|bmp|bz2|css|csv|doc|docx|eot|flac|flv|gif|gz|ico|jpeg|jpg|js|less|mka|mkv|mov|mp3|mp4|mpeg|mpg|odt|ogg|ogm|opus|otf|pdf|png|ppt|pptx|rar|rtf|svg|svgz|swf|tar|tbz|tgz|ttf|txt|txz|wav|webm|webp|woff|woff2|xls|xlsx|xml|xz|zip)(\?.*)?$"
	){
        	unset beresp.http.set-cookie;
	        set beresp.do_stream = true;
    	}

    	if (beresp.http.Cache-Control !~ "max-age" || beresp.http.Cache-Control ~ "max-age=0") {
        	set beresp.http.Cache-Control = "public, max-age=300, stale-while-revalidate=300, stale-if-error=300";
    	}

    	return (deliver);
} # Fin vcl_backend_response

# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
# **********************************************************************************************************************************************
sub vcl_hit {
        if (obj.ttl >= 0s) {
                # Una solicitud estándar, entregarla desde la memoria caché
                return (deliver);
        }
        elsif (std.healthy(req.backend_hint)) {
                if (obj.ttl + 30m > 0s) {
                        # La página expiró dentro de un tiempo de gracia limitado y el back-end está en buen estado: 
			# entregue desde el caché mientras el caché se actualiza asincrónicamente
                        return (deliver);
                } else {
                        # La página expiró hace mucho tiempo, solicitar a los backends
                        return (fetch);
                }
        }
        else {
                if (obj.ttl + obj.grace > 0s) {
                        # El backend no está saludable, entregar la página desde caché
                        # durante todo el tiempo de gracia definido vcl_backend_response
			# beresp.grace = 24h
                        return (deliver);
                } else {
                        # La página se considera experidada luego de todo el tiempo de gracia
			# y los backends se consideran enfermos. Tratar de contactar a los backends
			# de todas formas.
                        return (fetch);
                }
        }
}
