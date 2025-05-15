EAPI=8
PLOCALES="ar_SA ay_BO be_BY bg_BG crowdin cs_CZ de_CH de_DE el_GR eo_UY es_AR es_BO es_ES fa_IR fi_FI fr_FR hi_IN hu_HU ie_001 it_IT ja_JP jbo_EN kab_KAB ko_KR lt_LT mk_MK nl_NL pl_PL pt_BR pt_PT qu_PE ru_RU sk_SK sq_AL sr_SP sv_SE tg_TJ tk_TM tr_TR uk_UA vi_VN zh_CN zh_TW"

inherit desktop cmake plocale

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.org/"
REV_TAG="c737d944"
MY_PV="${PV%_*}"
SRC_URI="https://github.com/xiaoyifang/${PN}/archive/refs/tags/v${MY_PV}-alpha.${REV_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ffmpeg openzim"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	app-i18n/opencc
	>=app-text/hunspell-1.2:=
	dev-libs/eb
	dev-libs/lzo
	dev-libs/xapian
	dev-qt/qtbase:6[X,gui,network,sql,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtspeech:6
	dev-qt/qtsvg:6
	dev-qt/qtwebengine:6
	media-libs/libvorbis
	sys-libs/zlib
	virtual/libiconv
	ffmpeg? (
		media-video/ffmpeg:0=
	)
	openzim? (
		app-arch/libzim
	)
	!app-text/goldendict
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qttools:6[assistant,linguist]
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${MY_PV}-alpha.${REV_TAG}"

src_prepare() {
	default

	local loc_dir="${S}/locale"
	plocale_find_changes "${loc_dir}" "" ".ts"
	rm_loc() {
		rm -vf "locale/${1}.ts" || die
	}
	plocale_for_each_disabled_locale rm_loc

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_FFMPEG_PLAYER=$(usex ffmpeg)
		-DWITH_ZIM=$(usex openzim)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
