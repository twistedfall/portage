# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=a6b6c35d1550acbd2552d49c2fe38115deec8fc0

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/1.0-6" # based on SONAME of libimobiledevice-1.0.so
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="doc gnutls readline static-libs"

RDEPEND="
	app-pda/libimobiledevice-glue:=
	>=app-pda/libplist-2.3:=
	>=app-pda/libusbmuxd-2.0.2:=
	>=app-pda/libtatsu-1.0.0:=
	gnutls? (
		dev-libs/libgcrypt:0
		>=dev-libs/libtasn1-1.1
		>=net-libs/gnutls-2.2.0
	)
	!gnutls? (
		dev-libs/openssl:0=
	)
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

src_prepare() {
	default
	echo ${PV}-${MY_COMMIT} > "${S}"/.tarball-version
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-cython
		$(use_enable static-libs static)
	)
	use gnutls && myeconfargs+=( --disable-openssl )
	# --with-readline also causes readline to not be used
	use readline || myeconfargs+=( --without-readline )
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake

	if use doc; then
		doxygen doxygen.cfg || die
	fi
}

src_install() {
	emake install DESTDIR="${D}"

	use doc && dodoc docs/html/*

	find "${D}" -name '*.la' -delete || die
}
