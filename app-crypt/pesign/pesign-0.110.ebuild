# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib user systemd

DESCRIPTION="Tools for manipulating signed PE-COFF binaries"
HOMEPAGE="https://github.com/rhinstaller/pesign"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/nspr
	dev-libs/openssl:0
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/28080bf77972b39c120d581ca94bca719341a94c.patch
}

src_install() {
	default

	# remove some files that don't make sense for Gentoo installs
	rm -rf "${ED}/etc/" "${ED}/usr/share/doc/pesign/" || die

	# create .so symlink
	ln -s libdpe.so "${ED}/usr/$(get_libdir)/libdpe.so.0"
	
	systemd_dotmpfilesd "${FILESDIR}/pesign.conf"
}

pkg_postinst() {
	enewgroup pesign
	enewuser pesign -1 -1 -1 pesign
}