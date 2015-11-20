
EAPI=4

inherit cmake-utils git-r3

DESCRIPTION="ABBYY Lingvo dictionaries decompiler."
HOMEPAGE="https://github.com/nongeneric/lsd2dsl"

EGIT_REPO_URI="https://github.com/nongeneric/lsd2dsl.git"
EGIT_COMMIT="95b90aea1faff15d54661ff0d0f5f9bd2569eab3"

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
	dev-qt/qtwidgets:5
	dev-qt/qtcore:5
"

IUSE="debug"
mycmakeargs=( "$(use !debug && echo "-DCMAKE_RELEASE=TRUE")" )

src_install()
{
	dobin "${BUILD_DIR}"/lsd2dsl
	dobin "${BUILD_DIR}"/qtgui/lsd2dsl-qtgui
}
