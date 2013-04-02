EAPI="2"

inherit eutils

DESCRIPTION="A library for instrumenting- and integrating with all aspects of the Unity shell"
HOMEPAGE="https://launchpad.net/libunity"
SRC_URI="http://launchpad.net/${PN}/6.0/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="introspection"

DEPEND="
	dev-libs/glib:2
	dev-libs/dee
	dev-libs/libgee:0
	dev-libs/libdbusmenu
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"

src_configure()
{
	econf $(use_enable introspection)
}

src_install()
{
	emake DESTDIR="${D}" install
}
