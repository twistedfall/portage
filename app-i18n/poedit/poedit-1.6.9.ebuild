# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/poedit/poedit-1.5.5.ebuild,v 1.8 2014/08/10 17:51:57 slyfox Exp $

EAPI=5
WX_GTK_VER=3.0

inherit eutils fdo-mime flag-o-matic wxwidgets

DESCRIPTION="Cross-platform gettext catalogs (.po files) editor"
HOMEPAGE="http://poedit.net/"
SRC_URI="https://github.com/vslavik/${PN}/releases/download/v${PV}-oss/${P}.tar.gz"

LICENSE="MIT CC-BY-2.5 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64" 
IUSE="spell"

RDEPEND="
	dev-libs/boost
	>=sys-libs/db-4.7[cxx]
	x11-libs/wxGTK:3.0[X]
	dev-libs/expat
	dev-libs/icu
	dev-cpp/luceneplusplus
	spell? ( app-text/gtkspell:2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	append-flags -fno-strict-aliasing
	econf $(use_enable spell spellchecking)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
