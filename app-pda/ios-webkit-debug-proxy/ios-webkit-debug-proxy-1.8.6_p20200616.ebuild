# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

HASH="6d499e016fe3f8db982dad8bb9297c5b0969e576"

DESCRIPTION="A DevTools proxy (Chrome Remote Debugging Protocol) for iOS devices (Safari Remote Web Inspector)."
HOMEPAGE="https://github.com/google/ios-webkit-debug-proxy"
SRC_URI="https://github.com/google/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.2.0_p20191113
	app-pda/usbmuxd
	app-pda/libplist
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${HASH}"

src_prepare() {
	default
	eautoreconf
}
