# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="2a0a6d57df3791419dfcda070d9ba6189f518bd5"
TARBALL_VERSION="${PV}-212-g${COMMIT:0:7}"

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools python-r1

DESCRIPTION="Support library to communicate with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

# While COPYING* doesn't mention 'or any later version', all the headers do, hence use +
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/1.0-6" # based on SONAME of libimobiledevice-1.0.so
KEYWORDS="~amd64 ~arm ~arm64 ~loong ppc ~ppc64 ~riscv ~x86"
IUSE="doc gnutls python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=app-pda/libimobiledevice-glue-1.3.0
	>=app-pda/libplist-2.3.0:=
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
	python? (
		${PYTHON_DEPS}
		app-pda/libplist[python(-),${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
# <cython-3 for bug #898666
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	python? ( dev-python/cython[${PYTHON_USEDEP}] )
"

BUILD_DIR="${S}_build"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	echo -n "${TARBALL_VERSION}" > "${S}/.tarball-version"
	eautoreconf
}

src_configure() {
	local ECONF_SOURCE=${S}

	local myeconfargs=( $(use_enable static-libs static) )
	use gnutls && myeconfargs+=( --disable-openssl )

	do_configure() {
		mkdir -p "${BUILD_DIR}" || die
		pushd "${BUILD_DIR}" >/dev/null || die
		econf "${myeconfargs[@]}" "${@}"
		popd >/dev/null || die
	}

	do_configure_python() {
		# Bug 567916
		local -x PYTHON_LDFLAGS="$(python_get_LIBS)"
		do_configure "$@"
	}

	do_configure --without-cython
	use python && python_foreach_impl do_configure_python
}

src_compile() {
	python_compile() {
		emake -C "${BUILD_DIR}"/cython \
			VPATH="${S}/cython:$1/cython" \
			imobiledevice_la_LIBADD="$1/src/libimobiledevice-1.0.la"
	}

	emake -C "${BUILD_DIR}"
	use python && python_foreach_impl python_compile "${BUILD_DIR}"

	if use doc; then
		doxygen "${BUILD_DIR}"/doxygen.cfg || die
	fi
}

src_install() {
	python_install() {
		emake -C "${BUILD_DIR}/cython" install \
			DESTDIR="${D}" \
			VPATH="${S}/cython:$1/cython"
	}

	emake -C "${BUILD_DIR}" install DESTDIR="${D}"
	use python && python_foreach_impl python_install "${BUILD_DIR}"
	use doc && dodoc docs/html/*

	if use python; then
		insinto /usr/include/${PN}/cython
		doins cython/imobiledevice.pxd
	fi

	find "${D}" -name '*.la' -delete || die
}
