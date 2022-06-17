# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="d2ff7969dcd0a12e4f18f63dab03e6cd03054fcb"

inherit autotools

DESCRIPTION="Library with common code used by the libraries and tools around the libimobiledevice project"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.2.0:=
"
DEPEND="
	${RDEPEND}
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}
