
EAPI=7

inherit eutils

DESCRIPTION="QR decoder library"
HOMEPAGE="https://github.com/dlbeer/quirc"

SRC_URI="https://github.com/dlbeer/quirc/archive/v${PV}.tar.gz -> quirc-${PV}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs demos"

RDEPEND="
	demos? ( virtual/jpeg )
"

src_compile() {
	CFLAGS+=" -fPIC"
	make libquirc.so
	if use static-libs ; then
		make libquirc.a
	fi
	if use demos ; then
		make quirc-scanner
	fi
}

src_install() {
	doheader lib/quirc.h
	dolib.so libquirc.so.1.0
	dosym libquirc.so.1.0 /usr/$(get_libdir)/libquirc.so
	if use static-libs ; then
		dolib.a libquirc.a
	fi
	if use demos ; then
		dobin quirc-scanner
	fi
}
