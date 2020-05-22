# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV^^}
MY_PV=${MY_PV/_/-}
inherit desktop qmake-utils git-r3

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.org/"

EGIT_REPO_URI="https://github.com/goldendict/goldendict"
EGIT_COMMIT="a378acc0df33ff33f6f961b706894559bc5849b0"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cjk debug ffmpeg"

RDEPEND="
	app-arch/bzip2
	>=app-text/hunspell-1.5:=
	dev-libs/eb
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/libvorbis
	media-libs/tiff:0
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	cjk? (
		app-i18n/opencc
	)
	ffmpeg? (
		media-libs/libao
		media-video/ffmpeg:0=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-qtsingleapplication-unbundle.patch"
	"${FILESDIR}/goldendict-xdg.patch"
)

src_prepare() {
	default

	# disable git
	sed -i \
		-e '/git describe/s/^/#/' \
		${PN}.pro || die

	# fix installation path
	sed -i \
		-e '/PREFIX = /s:/usr/local:/usr:' \
		${PN}.pro || die

	# add trailing semicolon
	sed -i -e '/^Categories/s/$/;/' redist/${PN}.desktop || die
}

src_configure() {
	local myconf=()
	use ffmpeg || myconf+=( CONFIG+=no_ffmpeg_player )
	use cjk && myconf+=( CONFIG+=chinese_conversion_support )

	eqmake5 "${myconf[@]}" goldendict.pro
}

src_install() {
	dobin ${PN}
	domenu redist/${PN}.desktop
	doicon redist/icons/${PN}.png

	insinto /usr/share/apps/${PN}/locale
	doins locale/*.qm

	insinto /usr/share/${PN}/help
	doins help/*.qch
}
