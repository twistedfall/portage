
EAPI=4

inherit git-2

DESCRIPTION="FUSE and libmtp based filesystem for accessing MTP devices"
HOMEPAGE="https://github.com/kiorky/jmtpfs"

EGIT_REPO_URI="https://github.com/kiorky/jmtpfs.git"
EGIT_BRANCH="master"
EGIT_COMMIT="672a223586bab53c802f7e56b45a0f2c5d0bf6fe"

DEPEND="
	sys-fs/fuse
	media-libs/libmtp
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
