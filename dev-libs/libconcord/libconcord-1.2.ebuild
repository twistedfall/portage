# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )
inherit eutils autotools python-r1

MY_P="concordance-${PV}"

DESCRIPTION="Library for programming the Logitech Harmony universal remote"
HOMEPAGE="http://www.phildev.net/concordance/"
SRC_URI="mirror://sourceforge/concordance/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="python"

DEPEND="virtual/libusb:0
	dev-libs/zziplib
	dev-libs/hidapi"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN}"

src_configure() {
	econf --disable-mime-update
}

src_install() {
	einstall

	dodoc README
	dodoc ../Changelog ../TODO

	if use python ; then
		cd "${S}/bindings/python"
		python_foreach_impl python_domodule libconcord.py
	fi
}
