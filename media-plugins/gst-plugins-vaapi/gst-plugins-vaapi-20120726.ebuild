
EAPI=2
inherit eutils git-2 autotools

EGIT_REPO_URI="git://gitorious.org/vaapi/gstreamer-vaapi.git"
EGIT_BRANCH="master"
EGIT_COMMIT="22b2c2cb4fb29d566abab57c557391ea1cf8e32a"

KEYWORDS="~amd64 ~x86"
IUSE="X opengl wayland doc"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=media-libs/gstreamer-0.10.36
	>=media-libs/gst-plugins-base-0.10.36
	>=media-libs/gst-plugins-bad-0.10.23
	"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
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
	dodoc AUTHORS README COPYING NEWS
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
