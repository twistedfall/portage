# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/iwl3160-7260-bt-ucode/iwl3160-7260-bt-ucode-37.8.10_p1.ebuild,v 1.1 2014/11/17 13:44:23 gienah Exp $

EAPI=5
inherit linux-info git-r3

DESCRIPTION="Firmware for Intel (R) Wireless 3160, 7260, 7265 Bluetooth"
HOMEPAGE="http://wireless.kernel.org/en/users/Drivers/iwlwifi"

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git"
EGIT_COMMIT="1406ec112423c8f70d503d3cd44c6f8e147f7ac3"

LICENSE="ipw3945"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="!sys-kernel/linux-firmware[-savedconfig]"

CONFIG_CHECK="~IWLMVM"
ERROR_IWLMVM="CONFIG_IWLMVM is required to be enabled in /usr/src/linux/.config for the kernel to be able to load the Intel (R) Wireless 3160, 7260, 7265 firmware"

pkg_pretend() {
	if kernel_is lt 3 10 0; then
		ewarn "Your kernel version is ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}."
		ewarn "This microcode image requires a kernel >= 3.10.0."
	fi
}

src_install() {
	insinto /lib/firmware/intel
	doins "${S}/intel/ibt-hw-37.7.10-fw-1.0.1.2d.d.bseq"
	doins "${S}/intel/ibt-hw-37.7.10-fw-1.0.2.3.d.bseq"
	doins "${S}/intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq"
	doins "${S}/intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq"
	doins "${S}/intel/ibt-hw-37.7.bseq"
	doins "${S}/intel/ibt-hw-37.8.10-fw-1.10.2.27.d.bseq"
	doins "${S}/intel/ibt-hw-37.8.10-fw-1.10.3.11.e.bseq"
	doins "${S}/intel/ibt-hw-37.8.10-fw-22.50.19.14.f.bseq"
	doins "${S}/intel/ibt-hw-37.8.bseq"
}
