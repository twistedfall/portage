
EAPI=2
inherit eutils git-2 autotools

EGIT_REPO_URI="git://gitorious.org/vaapi/gstreamer-vaapi.git"
EGIT_BRANCH="master"
EGIT_COMMIT="9f3c01097567a0f235eedc381b3904842c800767"

KEYWORDS="~amd64 ~x86"
IUSE="doc ffmpeg opengl"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=media-libs/gstreamer-0.10.36
	>=media-libs/gst-plugins-base-0.10.36
	>=media-libs/gst-plugins-bad-0.10.23
	"
DEPEND="
	${RDEPEND}
	doc? ( dev-util/gtk-doc )
	ffmpeg? ( media-video/ffmpeg )
	"

src_prepare() {
	NO_CONFIGURE=1 ./autogen.sh
}

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable ffmpeg) \
		$(use_enable opengl glx) \
		$(use_enable opengl vaapi-glx) \
		$(use_enable opengl vaapisink-glx)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README NEWS
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
