# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd udev

MY_COMMIT=523f7004dce885fe38b4f80e34a8f76dc8ea98b5

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="selinux systemd"

DEPEND="
	>=app-pda/libimobiledevice-1.3.0:=
	app-pda/libimobiledevice-glue:=
	>=app-pda/libplist-2.6:=
	virtual/libusb:1=
"
RDEPEND="
	${DEPEND}
	acct-user/usbmux
	virtual/udev
	selinux? ( sec-policy/selinux-usbmuxd )
	systemd? ( sys-apps/systemd )
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	echo ${PV}-${MY_COMMIT} > "${S}"/.tarball-version
	eautoreconf
}

src_configure() {
	econf \
		"$(use_with systemd)" \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)" \
		--with-udevrulesdir="$(get_udevdir)"/rules.d
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
}
