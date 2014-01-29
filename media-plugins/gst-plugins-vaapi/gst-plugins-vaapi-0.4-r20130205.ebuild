
EAPI=2
inherit eutils git-2 autotools

EGIT_REPO_URI="git://gitorious.org/vaapi/gstreamer-vaapi.git"
EGIT_BRANCH="0.4-branch"
EGIT_COMMIT="5bd3c8da8a940f65232c59c7c2ae0cce9682bdcc"

KEYWORDS="~amd64 ~x86"
IUSE="X opengl wayland doc"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=media-libs/gstreamer-0.10.36:0.10
	>=media-libs/gst-plugins-base-0.10.36:0.10
	>=media-libs/gst-plugins-bad-0.10.23:0.10
	"
DEPEND="
	${RDEPEND}
	wayland? ( dev-libs/wayland )
	doc? ( dev-util/gtk-doc )
	"

src_prepare() {
	NO_CONFIGURE=1 ./autogen.sh
}

src_configure() {
	econf \
		$(use_enable X x11) \
		$(use_enable opengl glx) \
		$(use_enable wayland) \
		$(use_enable doc gtk-doc)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README NEWS
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
