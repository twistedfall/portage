# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=8c99bf42a1513876a373325f7e6742ab5005ded3

DESCRIPTION="Chrome DevTools Protocol proxy for the iOS Safari Remote Web Inspector"
HOMEPAGE="https://github.com/google/ios-webkit-debug-proxy"
SRC_URI="https://github.com/google/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.2.0:=
	>=app-pda/libusbmuxd-2.0.0:=
	app-pda/usbmuxd
	>=dev-libs/openssl-1.1.0:0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-examples-includes.patch" )

src_prepare() {
	default
	sed -i 's/ -Werror//g' configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
