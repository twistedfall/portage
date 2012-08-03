# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2 eutils

DESCRIPTION="Userspace controler for mbm-gpsd"
HOMEPAGE="http://mbm.sourceforge.net/"
EGIT_REPO_URI="git://mbm.git.sourceforge.net/gitroot/mbm/${PN}"
EGIT_BOOTSTRAP="./autogen.sh --with-distro=gentoo"
EGIT_PATCHES="${FILESDIR}/mbm-gps-control-glib.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	gnome-base/gconf
	x11-libs/gtk+:2
	sci-geosciences/mbm-gpsd
	"
DEPEND="${RDEPEND}"

src_unpack() {
	git-2_src_unpack
	epatch "${FILESDIR}/mbm-gps-control-glib.patch"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc COPYING NEWS README || die
}
