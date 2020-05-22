# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit git-r3

DESCRIPTION="gpsd-conform daemon for mobile broadband devices f3507g, f3607gw and f5521gw"
HOMEPAGE="http://mbm.sourceforge.net/"
EGIT_REPO_URI="git://mbm.git.sourceforge.net/gitroot/mbm/${PN}"
EGIT_BOOTSTRAP="./autogen.sh --with-distro=gentoo"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc COPYING NEWS README || die
}

