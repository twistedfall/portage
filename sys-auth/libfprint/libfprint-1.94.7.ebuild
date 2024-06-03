# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson udev

MY_P="${PN}-v${PV}"

DESCRIPTION="Library to add support for consumer fingerprint readers"
HOMEPAGE="
	https://cgit.freedesktop.org/libfprint/libfprint
	https://gitlab.freedesktop.org/libfprint/libfprint
	https://gitlab.freedesktop.org/3v1n0/libfprint/-/tree/tod
"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples gtk-doc +introspection tod-1"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev
	dev-libs/nss
	dev-python/pygobject
	dev-libs/libgusb
	x11-libs/pixman
	examples? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? (
		dev-libs/gobject-introspection
		dev-libs/libgusb[introspection]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.94.1-test-timeout.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	if use tod-1; then
		# create patch with git diff --text origin/release-1.94.7..v1.94.6+tod1 > tod-1.94.6.patch
		eapply "${FILESDIR}/tod-${PV}.patch"
	else
		"${FILESDIR}/${PN}-1.94.7-skip-test-dep.patch"
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use examples gtk-examples)
		$(meson_use gtk-doc doc)
		$(meson_use introspection introspection)
		-Ddrivers=all
		-Dinstalled-tests=false
		-Dudev_rules=enabled
		-Dudev_rules_dir=$(get_udevdir)/rules.d
	)

	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
