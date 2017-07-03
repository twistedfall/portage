
EAPI=5

inherit eutils cmake-utils git-r3

DESCRIPTION="Dictionary converter"
HOMEPAGE="https://github.com/soshial/xdxf_makedict"

EGIT_REPO_URI="git://github.com/soshial/xdxf_makedict.git"
EGIT_COMMIT="5d4be74f56ea57261676288227c5a9d68e2f9eb1"

PATCHES=( "${FILESDIR}/glib.patch" )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
