# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="2ec5354a6ff2ba5e2740eabe7402186f29294f79"

inherit autotools

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://cgit.libimobiledevice.org/${PN}.git/snapshot/${PN}-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
LICENSE="GPL-2+ LGPL-2.1+" # tools/*.c is GPL-2+, rest is LGPL-2.1+
SLOT="0/2.0-6" # based on SONAME of libusbmuxd-2.0.so
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.2.0:=
	app-pda/libimobiledevice-glue
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex kernel_linux '' --without-inotify)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
