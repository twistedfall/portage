# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info linux-mod

DESCRIPTION="r8152 driver for Realtek 8153 USB NICs"
HOMEPAGE="http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=13&PFid=56&Level=5&Conn=4&DownTypeID=3&GetDown=false"
SRC_URI="http://12244.wpc.azureedge.net/8012244/drivers/rtdrivers/cn/nic/0007-${PN}.53-${PV}.bz2 -> ${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULE_NAMES="r8152(net:${S})"
BUILD_TARGETS="modules"
CONFIG_CHECK="!USB_RTL8152"

ERROR_USB_RTL8152="${P} requires Realtek RTL8152/RTL8153 Based USB Ethernet Adapters (CONFIG_USB_RTL8152) to be DISABLED"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}
