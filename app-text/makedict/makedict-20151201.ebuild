
EAPI=5

inherit eutils cmake-utils git-r3

DESCRIPTION="Dictionary converter"
HOMEPAGE="https://github.com/soshial/xdxf_makedict"

EGIT_REPO_URI="git://github.com/soshial/xdxf_makedict.git"
EGIT_COMMIT="3bd4ba5c8e823765f78c72aeec0c23ac580ddc52"

PATCHES=( "${FILESDIR}/glib.patch" )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
