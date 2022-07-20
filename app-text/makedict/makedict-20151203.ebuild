
EAPI=6

inherit eutils cmake-utils git-r3

DESCRIPTION="Dictionary converter"
HOMEPAGE="https://github.com/soshial/xdxf_makedict"

EGIT_REPO_URI="git://github.com/soshial/xdxf_makedict.git"
EGIT_COMMIT="163ae7f142446eaa6717525cc7e26c7575b4df5f"

PATCHES=(
	"${FILESDIR}/glib.patch"
	"${FILESDIR}/readme_path.patch"
)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
