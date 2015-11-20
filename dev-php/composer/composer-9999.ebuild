# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpunit/phpunit-4.3.1.ebuild,v 1.4 2015/04/14 18:12:46 grknight Exp $

EAPI=5

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://getcomposer.org/"

SRC_URI="https://getcomposer.org/installer -> composer-installer.php"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

DEPEND="dev-lang/php:*[phar,xml]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	return
}

src_install() {
	mkdir -p "${D}/usr/bin/"
 	php "${DISTDIR}/composer-installer.php" --install-dir="${D}/usr/bin/" --filename="composer" --quiet
}
 