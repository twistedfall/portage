# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-mod

DESCRIPTION="Extensible Virtual Display Interface"
HOMEPAGE="https://github.com/DisplayLink/evdi"
REV="65e12fca334f2f42396f4e8d16592d53cab34dd6"
SRC_URI="https://github.com/DisplayLink/evdi/archive/${REV}.zip -> ${P}.zip"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="x11-libs/libdrm"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

CONFIG_CHECK="~FB_VIRTUAL ~!INTEL_IOMMU"

PATCHES=( "${FILESDIR}/kernel-5.13.patch" )

S="${WORKDIR}/${PN}-${REV}"

MODULE_NAMES="evdi(video:${S}/module)"

pkg_setup() {
	linux-mod_pkg_setup
}

src_compile() {
	export KVER=${KV_FULL}
	linux-mod_src_compile
	cd "${S}/library"
	default
	mv libevdi.so libevdi.so.0
}

src_install() {
	linux-mod_src_install
	dolib.so library/libevdi.so.0
	dosym libevdi.so.0 "/usr/$(get_libdir)/libevdi.so"
}
