# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd udev

DESCRIPTION="DisplayLink USB Graphics Software"
HOMEPAGE="https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu"
SRC_URI="${P}.zip"
P_REV="63.33"

LICENSE="DisplayLink"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="systemd"

QA_PREBUILT="/opt/displaylink/DisplayLinkManager"
RESTRICT="fetch"

DEPEND="app-admin/chrpath"
RDEPEND=">=sys-devel/gcc-4.8.3
	>=x11-drivers/evdi-1.7.0
	virtual/libusb:1
	|| ( x11-drivers/xf86-video-modesetting >=x11-base/xorg-server-1.17.0 )
	!systemd? ( sys-power/pm-utils )"

pkg_nofetch() {
	einfo "Please download DisplayLink USB Graphics Software for Ubuntu 5.8.zip from"
	einfo "http://www.displaylink.com/downloads/ubuntu"
	einfo "and rename it to ${P}.zip"
}

src_unpack() {
	default
	sh ./"${PN}"-"${PV}-${P_REV}".run --noexec --target "${P}"
}

src_install() {
	if [[ ( $(gcc-major-version) -eq 5 && $(gcc-minor-version) -ge 1 ) || $(gcc-major-version) -gt 5 ]]; then
		MY_UBUNTU_VERSION=1604
	else
		MY_UBUNTU_VERSION=1404
	fi

	einfo "Using package for Ubuntu ${MY_UBUNTU_VERSION} based on your gcc version: $(gcc-version)"

	case "${ARCH}" in
		amd64)	MY_ARCH="x64" ;;
		*)		MY_ARCH="${ARCH}" ;;
	esac

	DLM="${S}/${MY_ARCH}-ubuntu-${MY_UBUNTU_VERSION}/DisplayLinkManager"

	dodir /opt/displaylink
	dodir /var/log/displaylink

	exeinto /opt/displaylink
	chrpath -d "${DLM}"
	doexe "${DLM}"

	insinto /opt/displaylink
	doins *.spkg

	udev_dorules "${FILESDIR}/99-displaylink.rules"

	insinto /opt/displaylink
	insopts -m0755
	newins "${FILESDIR}/udev.sh" udev.sh
	if use systemd; then
		newins "${FILESDIR}/pm-systemd-displaylink" suspend.sh
		dosym /opt/displaylink/suspend.sh /lib/systemd/system-sleep/displaylink.sh
		systemd_dounit "${FILESDIR}/dlm.service"
	else
		newins "${FILESDIR}/pm-displaylink" suspend.sh
		dosym /opt/displaylink/suspend.sh /etc/pm/sleep.d/displaylink.sh
		newinitd "${FILESDIR}/rc-displaylink-1.3" dlm
	fi
}

pkg_postinst() {
	einfo "The DisplayLinkManager Init is now called dlm"
	einfo ""
	einfo "You should be able to use xrandr as follows:"
	einfo "xrandr --setprovideroutputsource 1 0"
	einfo "Repeat for more screens, like:"
	einfo "xrandr --setprovideroutputsource 2 0"
	einfo "Then, you can use xrandr or GUI tools like arandr to configure the screens, e.g."
	einfo "xrandr --output DVI-1-0 --auto"
}
