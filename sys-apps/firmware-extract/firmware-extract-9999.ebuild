# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit git-r3

DESCRIPTION="firmware-extract"
HOMEPAGE="http://linux.dell.com/cgi-bin/gitweb/gitweb.cgi?p=${PN}.git;a=summary"
EGIT_REPO_URI="git://linux.dell.com/${PN}.git"
EGIT_BOOTSTRAP="./autogen.sh --prefix=/usr --sysconfdir=/etc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
         sys-apps/firmware-tools
         sys-apps/firmware-addon-dell
         dev-python/sqlobject
         "
src_install() {
	emake prefix=/usr DESTDIR="${D}" install || die "install failed"
}
