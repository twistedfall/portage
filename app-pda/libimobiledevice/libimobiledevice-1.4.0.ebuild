# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=149f7623c672c1fa73122c7119a12bfc0012f2ac

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/1.0-6" # based on SONAME of libimobiledevice-1.0.so
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="doc gnutls readline static-libs"

RDEPEND="
	>=app-pda/libimobiledevice-glue-1.3.0:=
	>=app-pda/libplist-2.3:=
	>=app-pda/libusbmuxd-2.0.2:=
	>=app-pda/libtatsu-1.0.3:=
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
	printf '%s\n' "${PV}" > .tarball-version || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-cython
		--without-mbedtls
		$(use_with gnutls)
		$(use_with !gnutls openssl)
		$(use_enable static-libs static)
	)
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

	use doc && dodoc -r docs/html

	find "${D}" -name '*.la' -delete || die
}
