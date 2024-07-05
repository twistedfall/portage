# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="e8791e2d8b1d1672439b78d31271a8cf74d6a16d"
TARBALL_VERSION="${PV}-2-g${COMMIT:0:7}"

PYTHON_COMPAT=( python3_{10..12} )
inherit autotools python-r1 toolchain-funcs

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/2.0-4"
KEYWORDS="~amd64 ~arm arm64 ~loong ppc ~ppc64 ~riscv ~s390 x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	python? ( >=dev-python/cython-0.17[${PYTHON_USEDEP}] )
"

DOCS=( AUTHORS NEWS README.md )

S="${WORKDIR}/${PN}-${COMMIT}"

BUILD_DIR="${S}_build"

src_prepare() {
	default
	echo -n "${TARBALL_VERSION}" > "${S}/.tarball-version"
	eautoreconf
}

src_configure() {
	local ECONF_SOURCE="${S}"

	do_configure() {
		mkdir -p "${BUILD_DIR}" || die
		pushd "${BUILD_DIR}" >/dev/null || die
		econf --disable-static "${@}"
		popd >/dev/null || die
	}

	do_configure_python() {
		local -x PYTHON_LDFLAGS="$(python_get_LIBS)"
		do_configure "$@"
	}

	# Don't prefer clang.
	tc-export CC CXX

	do_configure --without-cython
	use python && python_foreach_impl do_configure_python
}

src_compile() {
	local native_builddir=${BUILD_DIR}
	ln -s "${native_builddir}/src/libplist-2.0.la" \
		"${native_builddir}/src/libplist.la" || die

	python_compile() {
		emake -C "${BUILD_DIR}"/cython \
			VPATH="${S}/cython:${native_builddir}/cython" \
			plist_la_LIBADD="${native_builddir}/src/libplist-2.0.la"
	}

	pushd "${BUILD_DIR}" >/dev/null || die
	emake
	use python && python_foreach_impl python_compile
	popd >/dev/null || die
}

src_test() {
	emake -C "${BUILD_DIR}" check
}

src_install() {
	python_install() {
		emake -C "${BUILD_DIR}/cython" \
			VPATH="${S}/cython:${native_builddir}/cython" \
			DESTDIR="${D}" install
	}

	local native_builddir=${BUILD_DIR}
	pushd "${BUILD_DIR}" >/dev/null || die
	emake DESTDIR="${D}" install
	use python && python_foreach_impl python_install
	popd >/dev/null || die

	einstalldocs

	if use python ; then
		insinto /usr/include/plist/cython
		doins cython/plist.pxd
	fi

	find "${ED}" -name '*.la' -delete || die
}
