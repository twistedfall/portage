# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="e3eb2e224781f6522e2cf63c35c2c249747d648d"
TARBALL_VERSION="${PV}-2-g${COMMIT:0:7}"

inherit autotools

DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs"

RDEPEND=">=app-pda/libplist-2.3:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	echo -n "${TARBALL_VERSION}" > "${S}/.tarball-version"
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
