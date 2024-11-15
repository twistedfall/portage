# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="a7f0543fb1ecb20ac7121c0fd77297200e0e43fc"
TARBALL_VERSION="${PV}-3-g${COMMIT:0:7}"

inherit autotools

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"
LICENSE="GPL-2+ LGPL-2.1+" # tools/*.c is GPL-2+, rest is LGPL-2.1+
SLOT="0/2.0-7" # based on SONAME of libusbmuxd-2.0.so
KEYWORDS="~amd64 ~arm ~arm64 ~loong ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.3.0:=
	app-pda/libimobiledevice-glue
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	echo -n "${TARBALL_VERSION}" > "${S}/.tarball-version"
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
