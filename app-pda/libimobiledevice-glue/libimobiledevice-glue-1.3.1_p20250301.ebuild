# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=c915351cb322d041afabc04f780eb35142cdaea5

DESCRIPTION="Support library for libimobiledevice projects"
HOMEPAGE="https://github.com/libimobiledevice/libimobiledevice-glue"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="LGPL-2.1+"
SLOT="0/0.1.0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"

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
