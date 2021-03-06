<VirtualHost *:80>
	# ServerName {{getv "/base/domain"}}
	DocumentRoot /var/www/html
	ErrorLog /var/log/apache2/{{getv "/base/domain"}}.error.log
	CustomLog /var/log/apache2/{{getv "/base/domain"}}-access.log combined

	<Directory /var/www/html/>
		Require all granted
		Options FollowSymlinks
		AllowOverride all
	</Directory>

	# Apache Reverse Proxy for Islandora
	ProxyRequests Off
	ProxyPreserveHost On
	
	<Proxy *>
		AddDefaultCharset off
		Order deny,allow
		Allow from all
	</Proxy>

	AllowEncodedSlashes NoDecode
	## Fedora
	ProxyPass /fedora/get http://fedora:8080/fedora/get
	ProxyPassReverse /fedora/get http://fedora:8080/fedora/get
	ProxyPass /fedora/services http://fedora:8080/fedora/services
	ProxyPassReverse /fedora/services http://fedora:8080/fedora/services
	ProxyPass /fedora/describe http://fedora:8080/fedora/describe
	ProxyPassReverse /fedora/describe http://fedora:8080/fedora/describe
	ProxyPass /fedora/risearch http://fedora:8080/fedora/risearch
	ProxyPassReverse /fedora/risearch http://fedora:8080/fedora/risearch
	## Images
	ProxyPass /adore-djatoka http://image-services:8080/adore-djatoka
	ProxyPassReverse /adore-djatoka http://image-services:8080/adore-djatoka
	ProxyPass /iiif/2 http://image-services:8080/cantaloupe/iiif/2 nocanon
	ProxyPassReverse /iiif/2 http://image-services:8080/cantaloupe/iiif/2
	ProxyPass /cantaloupe/iiif/2 http://image-services:8080/cantaloupe/iiif/2 nocanon
	ProxyPassReverse /cantaloupe/iiif/2 http://image-services:8080/cantaloupe/iiif/2

	## We cannot use self-signed certs with adore-djatoka (which will be deprecated.)
	RewriteEngine On
    RewriteCond %{QUERY_STRING} (.*)https(.*)
    RewriteRule ^/adore-djatoka/resolver /adore-djatoka/resolver?%1http%2 [L,PT]

</VirtualHost>
