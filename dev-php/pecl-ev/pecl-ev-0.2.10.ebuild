# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-event/pecl-event-1.8.0.ebuild,v 1.4 2014/01/18 18:36:40 pacho Exp $

EAPI="5"

PHP_EXT_NAME="ev"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="CREDITS EXPERIMENTAL INSTALL.md README.md LICENSE"

USE_PHP="php5-4 php5-5"

inherit php-ext-pecl-r2 confutils eutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides interface to libev library"
LICENSE="PHP-3"
SLOT="0"

DEPEND=""

RDEPEND="${DEPEND}"

IUSE="debug"

src_configure() {
	enable_extension_enable "ev-debug" "debug" 0

	php-ext-source-r2_src_configure
}
