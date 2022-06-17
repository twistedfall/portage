# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="2839789bdb581ede7c331b9b4e07e0d5a89d7d18"

inherit autotools systemd udev

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="systemd"

DEPEND="
	acct-user/usbmux
	app-pda/libimobiledevice-glue
	>=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.2:=
	virtual/libusb:1"

RDEPEND="
	${DEPEND}
	virtual/udev
"

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
		$(use_with systemd) \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		--with-udevrulesdir="$(get_udevdir)"/rules.d
}
