# GDO Configuration

There are quite a few configurations you would expect.
In GDO, there are no config files.
You control GDO configuration with environment variables.

# GDO Environment Variables

Here are the environment variables and their defaults.

    # Application
    export GDO_ENV="dev"
    export GDO_DEFAULT_MODULE="Core"
    export GDO_DEFAULT_METHOD="Index"
    # HTTPD
    export GDO_HTTP_SCHEMA="http"
    export GDO_HTTP_DOMAIN="localhost"
    export GDO_HTTP_PORT="80"
    # Logger
    export GDO_LOG_LEVEL=6
    export GDO_LOG_PATH="~/.gdo/log/"
    # Database
	export GDO_DB_HOST="localhost"
	export GDO_DB_USER="rubygdo"
	export GDO_DB_PASS="rubygdo"
	export GDO_DB_NAME="rubygdo"
	export GDO_DB_DEBUG=1
    # Mailer
    export GDO_BOT_MAIL="gdor@gizmore.org"
    export GDO_BOT_NAME="RubyGDO Security Bot"
