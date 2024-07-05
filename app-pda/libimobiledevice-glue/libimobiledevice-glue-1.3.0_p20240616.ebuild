# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="362f7848ac89b74d9dd113b38b51ecb601f76094"
TARBALL_VERSION="${PV}-7-g${COMMIT:0:7}"

inherit autotools

DESCRIPTION="Library with common code used by the libraries and tools around the libimobiledevice project"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="LGPL-2.1+"
SLOT="0/0.2.0"
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
