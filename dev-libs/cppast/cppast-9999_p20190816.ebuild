# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib git-r3

DESCRIPTION="Library to parse and work with the C++ AST"
HOMEPAGE="https://github.com/foonathan/cppast"
EGIT_REPO_URI="https://github.com/foonathan/${PN}"
EGIT_COMMIT="a89ebcdf0a9cb4040fd39b7a4892cc1a0cb4ecbb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools examples test"
RDEPEND="
	sys-devel/llvm
	sys-devel/clang
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/catch )
"

PATCHES=(
	"${FILESDIR}"/use-system-catch.patch
	"${FILESDIR}"/correct-cmake-flags.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCPPAST_BUILD_TOOL=$(usex tools)
		-DCPPAST_BUILD_EXAMPLE=$(usex examples)
		-DCPPAST_BUILD_TEST=$(usex test)
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	if use tools; then
		dobin tool/cppast
	fi
	dolib.so lib_cppast_tiny_process.so
	dolib.so src/libcppast.so
}
