
EAPI=6

inherit cmake-utils

DESCRIPTION="ABBYY Lingvo dictionaries decompiler."
HOMEPAGE="https://github.com/nongeneric/lsd2dsl"
SRC_URI="https://github.com/nongeneric/lsd2dsl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

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
	dev-cpp/gtest
"

IUSE="debug"

PATCHES=(
	"${FILESDIR}/minizip.patch"
	"${FILESDIR}/tests.patch"
)

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/console/lsd2dsl
	dobin "${BUILD_DIR}"/gui/lsd2dsl-qtgui
}
