
EAPI=4

inherit cmake-utils git-2

DESCRIPTION="ABBYY Lingvo dictionaries decompiler."
HOMEPAGE="https://github.com/nongeneric/lsd2dsl"

EGIT_REPO_URI="https://github.com/nongeneric/lsd2dsl.git"
EGIT_BRANCH="master"
EGIT_COMMIT="055af2fd798ad191fc3fc0178026ae258efcac38"

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
"

IUSE="debug"
mycmakeargs=( "$(use !debug && echo "-DCMAKE_RELEASE=TRUE")" )

src_install()
{
	dobin "${BUILD_DIR}"/lsd2dsl
}
