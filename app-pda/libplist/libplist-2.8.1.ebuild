# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_COMMIT=678b1a34693b86ae1787fa470dcb7203ffd0ef3f

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/2.0-12" # based on SONAME of libplist-2.0.so
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default
	printf '%s\n' "${PV}" > .tarball-version || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--without-cython
		--without-fuzzers
		--without-sanitizers
		$(use_with test tests)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
