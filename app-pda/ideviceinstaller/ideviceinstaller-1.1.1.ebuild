# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool to interact with the installation_proxy of an Apple's iDevice"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://www.libimobiledevice.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.1.4:=
	>=app-pda/libplist-1.8:=
	>=dev-libs/libzip-0.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

