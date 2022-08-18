# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Library to parse and work with the C++ AST"
HOMEPAGE="https://github.com/foonathan/cppast"
EGIT_REPO_URI="https://github.com/foonathan/${PN}"
EGIT_COMMIT="b155d6abccdf97b6940a0543e93354cb05a2ed04"

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

	cmake_src_configure
}

multilib_src_install() {
	if use tools; then
		dobin tool/cppast
	fi
	dolib.so lib_cppast_tiny_process.so
	dolib.so src/libcppast.so
}
