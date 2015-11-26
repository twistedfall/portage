# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xrandr/xrandr-1.4.3.ebuild,v 1.1 2014/10/22 17:25:10 chithanh Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="primitive command line interface to RandR extension"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/libXrandr-1.4
	x11-libs/libXrender
	x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/scale.patch" )

src_install() {
	xorg-2_src_install
	rm -f "${ED}"/usr/bin/xkeystone || die
}