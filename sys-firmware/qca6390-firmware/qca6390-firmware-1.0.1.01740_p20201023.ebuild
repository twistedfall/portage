# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info

REV="2d55a0ae2563e8aebd9159d63a2455811eec0263"
DESCRIPTION="Firmware files for ath11k, a mac80211 driver for Qualcomm Technologies 802.11ax devices"
HOMEPAGE="https://github.com/kvalo/ath11k-firmware"
SRC_URI="https://github.com/kvalo/ath11k-firmware/archive/${REV}.zip -> ${P}.zip"
RESTRICT="strip"

LICENSE="qca-firmware"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/ath11k-firmware-${REV}"

src_compile() {
	true
}

src_install() {
	insinto /lib/firmware/ath11k/QCA6390/hw2.0
	doins QCA6390/hw2.0/1.0.1/WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1/amss.bin
	doins QCA6390/hw2.0/1.0.1/WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1/m3.bin
	doins QCA6390/hw2.0/board-2.bin
}
