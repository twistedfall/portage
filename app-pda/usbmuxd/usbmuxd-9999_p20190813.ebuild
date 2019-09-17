# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
AUTOTOOLS_AUTORECONF=1
inherit autotools udev user

HASH="1afa7350f9da03365f3b8f98dcb763b396e52723"

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.1.7
	>=app-pda/libplist-1.12
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${HASH}"

pkg_setup() {
	enewgroup plugdev
	enewuser usbmux -1 -1 -1 "usb,plugdev"
}

src_prepare() {
	default
	eautoreconf
}
