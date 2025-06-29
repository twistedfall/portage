# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=19d6bec393c9f9b31ccb090059f59268da32e281

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2+ LGPL-2.1+" # tools/*.c is GPL-2+, rest is LGPL-2.1+
SLOT="0/2.0-7" # based on SONAME of libusbmuxd-2.0.so
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="
	>=app-pda/libimobiledevice-glue-1.2.0:=
	>=app-pda/libplist-2.3.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	echo ${PV}-${MY_COMMIT} > "${S}"/.tarball-version
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(usex kernel_linux '' --without-inotify)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
