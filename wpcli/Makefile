WP_CLI=wp-cli --allow-root

install: configure-db configure-admin-user configure-site-url configure

configure-db:
	@echo "Configuring Wordpress database..."
	$(WP_CLI) core config \
		--dbhost=${WORDPRESS_DB_HOST} \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${WORDPRESS_DB_PASSWORD} \
		--locale=${WORDPRESS_LOCALE} \
		--skip-check \
		--force

configure-admin-user:
	@echo "Configuring Wordpress Admin User..."
	$(WP_CLI) core install \
		--admin_user=${WORDPRESS_ADMIN_USER} \
		--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
		--admin_email=${WORDPRESS_ADMIN_EMAIL} \
		--url=${WORDPRESS_WEBSITE_URL_WITHOUT_HTTP} \
		--title=$(WORDPRESS_WEBSITE_TITLE)

configure-site-url:
	@echo "Configuring Wordpress Site URL parameters..."
	$(WP_CLI) option update siteurl ${WORDPRESS_WEBSITE_URL}
	$(WP_CLI) option update home ${WORDPRESS_WEBSITE_URL}

configure:
	@echo "Configuring Wordpress parameters..."

	$(WP_CLI) option update timezone_string "Europe/Bucharest"
	$(WP_CLI) option update WPLANG ${WORDPRESS_LOCALE}
	$(WP_CLI) rewrite structure $(WORDPRESS_WEBSITE_POST_URL_STRUCTURE)
