# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
EGIT_REPO_URI="https://github.com/libimobiledevice/libusbmuxd"
EGIT_COMMIT="b097ea39f391f5c2c83d8f4687843a3634f7cd54"

# tools/iproxy.c is GPL-2+, everything else is LGPL-2.1+
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/4" # based on SONAME of libusbmuxd.so
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="kernel_linux static-libs"

RDEPEND=">=app-pda/libplist-1.12:=
	virtual/libusb:1
	>=app-pda/usbmuxd-1.1.0"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=( $(use_enable static-libs static) )
	use kernel_linux || myeconfargs+=( --without-inotify )

	econf "${myeconfargs[@]}"
}
