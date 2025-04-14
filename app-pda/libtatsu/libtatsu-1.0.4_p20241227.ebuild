# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=7e1647b9883ff1daa6363de20af2c4129ed45dcd

DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ppc ~ppc64 ~riscv ~x86"

RDEPEND=">=app-pda/libplist-2.3:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	echo ${PV}-${MY_COMMIT} > "${S}"/.tarball-version
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
