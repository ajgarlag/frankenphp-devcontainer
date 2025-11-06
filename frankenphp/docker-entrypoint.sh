#!/bin/sh
set -e

if [ "$1" = 'frankenphp' ] || [ "$1" = 'php' ] || [ "$1" = 'bin/console' ]; then
	if [ -f composer.json ] && [ -z "$(ls -A 'vendor/' 2>/dev/null)" ]; then
		composer install --prefer-dist --no-progress --no-interaction
	fi

	if [ -f /usr/sbin/gosu ]; then
		for path in composer.lock vendor var /data /config
		do
			chown -R vscode:vscode $path
			setfacl -R -m u:vscode:rwX -m u:vscode:rwX $path
			setfacl -dR -m u:vscode:rwX -m u:vscode:rwX $path
		done
	fi

	echo 'PHP app ready!'
fi

if [ -f /usr/sbin/gosu ]; then
	exec /usr/sbin/gosu vscode docker-php-entrypoint "$@"
else
	exec docker-php-entrypoint "$@"
fi
