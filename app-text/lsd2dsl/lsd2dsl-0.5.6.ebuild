
EAPI=8

inherit cmake

DESCRIPTION="ABBYY Lingvo dictionaries decompiler."
HOMEPAGE="https://github.com/nongeneric/lsd2dsl"
SRC_URI="https://github.com/nongeneric/lsd2dsl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="
	dev-cpp/gtest
	dev-libs/boost
	dev-libs/libfmt
	dev-libs/libzip
	dev-qt/qtcore:5
	dev-util/cmake
	media-libs/libsndfile
	media-libs/libvorbis
"

IUSE="debug"

PATCHES=(
	"${FILESDIR}/minizip.patch"
	"${FILESDIR}/no-werror.patch"
)

src_configure() {
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/console/lsd2dsl
	dobin "${BUILD_DIR}"/gui/lsd2dsl-qtgui
}
