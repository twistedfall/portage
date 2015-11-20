# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils vcs-snapshot

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

MY_PN="NetworkManager-ssh"
DESCRIPTION="SSH VPN integration for NetworkManager"
HOMEPAGE="https://github.com/danfruehauf/${MY_PN}"
SRC_URI="https://github.com/danfruehauf/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk test"

RDEPEND="
	>=dev-libs/dbus-glib-0.74
	>=net-misc/networkmanager-0.9.8
	virtual/ssh
	gtk? (
		>=x11-libs/gtk+-2.91.4:3
		gnome-base/gnome-keyring
		gnome-base/libgnome-keyring
	)
"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		--with-gtkver=3 \
		$(use_with gtk gnome) \
		$(use_with test tests)
}
