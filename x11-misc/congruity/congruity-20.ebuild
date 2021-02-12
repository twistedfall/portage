# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{3_7,3_8,3_9} )
inherit python-single-r1 xdg-utils

DESCRIPTION="GUI application for programming Logitech Harmony"
HOMEPAGE="http://sourceforge.net/projects/congruity"
SRC_URI="mirror://sourceforge/congruity/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/libconcord-1.0[python]
	dev-python/wxpython:2.8
	>=dev-python/suds-0.4"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" \
		RUN_UPDATE_DESKTOP_DB=0 \
		install

	python_doscript "${ED}/usr/bin/${PN}"
	python_doscript "${ED}/usr/bin/mhgui"

	dodoc Changelog README.txt
}

pkg_postinst() {
	xdg_desktop_database_update
}
