# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=5bdc4dcda97bee0a304609fbab54e71489243253

DESCRIPTION="A tool to interact with the installation_proxy of an Apple's iDevice"
HOMEPAGE="https://libimobiledevice.org"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.zip -> ${P}.zip"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.3.0:=
	>=dev-libs/libzip-0.8"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	echo ${PV}-${MY_COMMIT} > "${S}"/.tarball-version
	eautoreconf
}

