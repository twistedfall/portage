
EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="ABBYY Lingvo dictionaries decompiler."
HOMEPAGE="https://github.com/nongeneric/lsd2dsl"

EGIT_REPO_URI="https://github.com/nongeneric/lsd2dsl.git"
EGIT_BRANCH="master"
EGIT_COMMIT="v0.3.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="
	dev-libs/libzip
	dev-libs/boost
	dev-util/cmake
	dev-qt/qtcore:5
	media-libs/libvorbis
	media-libs/libsndfile
	debug? ( dev-cpp/gtest )
	sys-devel/gcc:4.9
"

IUSE="debug"

src_configure() {
        local mycmakeargs=( "$(use !debug && echo "-DCMAKE_RELEASE=TRUE")" )
        cmake-utils_src_configure
}

src_install()
{
	dobin "${BUILD_DIR}"/lsd2dsl
}
