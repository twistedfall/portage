# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DRI=dri
XORG_EAUTORECONF=yes
EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/driver/xf86-video-intel"
EGIT_COMMIT="82293901da23d79fd074e5255fda5c95405d52de"

inherit linux-info xorg-2 git-r3

unset SRC_URI

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~x86 ~amd64-fbsd -x86-fbsd"
IUSE="debug +sna +udev uxa xvmc"

REQUIRED_USE="
	|| ( sna uxa )
"

RDEPEND="x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.29[video_cards_intel]
	sna? (
		>=x11-base/xorg-server-1.10
	)
	udev? (
		virtual/udev
	)
	xvmc? (
		x11-libs/libXvMC
		>=x11-libs/libxcb-1.5
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}
	>=x11-proto/dri2proto-2.6
	x11-proto/dri3proto
	x11-proto/presentproto
	x11-proto/resourceproto"

PATCHES=(
#	"${FILESDIR}"/xf86-video-intel-2.99.917-sna-udev-fstat.patch
#	"${FILESDIR}"/xf86-video-intel-2.99.917-uxa-udev-fstat.patch
#	"${FILESDIR}"/xf86-video-intel-2.99.917-libdrm-kernel-4_0-crash.patch
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable dri)
		$(use_enable sna)
		$(use_enable uxa)
		$(use_enable udev)
		$(use_enable xvmc)
		--disable-dri3
	)
	xorg-2_src_configure
}

pkg_postinst() {
	if linux_config_exists \
		&& ! linux_chkconfig_present DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "	      i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
}
