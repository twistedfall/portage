# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-10.2.161.23_pre20101117.ebuild,v 1.1 2010/12/01 13:51:02 lack Exp $

EAPI=3

inherit eutils

DESCRIPTION="Standalone Adobe Flash player"
HOMEPAGE="http://www.adobe.com/support/flashplayer/downloads.html"
SRC_URI="!debug? ( http://download.macromedia.com/pub/flashplayer/updaters/10/flashplayer_10_sa.tar.gz )
          debug? ( http://download.macromedia.com/pub/flashplayer/updaters/10/flashplayer_10_sa_debug.tar.gz )"
RESTRICT="nomirror"

LICENSE="WWEULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug"

RDEPEND=">=sys-libs/glibc-2.4
	x86? ( x11-libs/gtk+:2 )
	amd64? ( app-emulation/emul-linux-x86-gtklibs )"

DEPEND=""

src_install()
{
	exeinto "/opt/Adobe/${PN}/bin"
	PLAYER="flashplayer"
	if use debug;
	then
		PLAYER="${PLAYER}debugger"
	fi
	doexe "${PLAYER}"
	dosym "/opt/Adobe/${PN}/bin/${PLAYER}" "/opt/bin/flashplayer"
}
