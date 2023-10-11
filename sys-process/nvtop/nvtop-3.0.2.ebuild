# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

NVIDIA_PV="535.113.01"

DESCRIPTION="NVIDIA GPUs htop like monitoring tool"
HOMEPAGE="https://github.com/Syllo/nvtop"

SRC_URI="
	https://github.com/Syllo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"

IUSE="unicode video_cards_adreno video_cards_amdgpu video_cards_apple video_cards_intel video_cards_nvidia"

RDEPEND="
	sys-libs/ncurses:0=
	video_cards_nvidia? ( x11-drivers/nvidia-drivers )
	video_cards_amdgpu? ( x11-libs/libdrm[video_cards_amdgpu] )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local CMAKE_CONF="
		-DCMAKE_BUILD_TYPE=Release
		-DCURSES_NEED_WIDE=$(usex unicode)
		-DMSM_SUPPORT=$(usex video_cards_adreno)
		-DAMDGPU_SUPPORT=$(usex video_cards_amdgpu)
		-DAPPLE_SUPPORT=$(usex video_cards_apple)
		-DINTEL_SUPPORT=$(usex video_cards_intel)
		-DNVIDIA_SUPPORT=$(usex video_cards_nvidia)
	"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		${CMAKE_CONF}
	)

	cmake_src_configure
}
