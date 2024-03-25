# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="360619c5f721f93f0b9d8af1a2df0b926fbcf281"
TARBALL_VERSION="${PV}-56-g${COMMIT:0:7}"

inherit autotools systemd udev

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="selinux systemd"

DEPEND="
	acct-user/usbmux
	app-pda/libimobiledevice-glue
	>=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.3:=
	virtual/libusb:1=
"

RDEPEND="
	${DEPEND}
	virtual/udev
	selinux? ( sec-policy/selinux-usbmuxd )
	systemd? ( sys-apps/systemd )
"

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
