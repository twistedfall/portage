EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1 git-r3 cmake-utils

DESCRIPTION="Library for interfacing with IIO devices"
HOMEPAGE="https://wiki.analog.com/resources/tools-software/linux-software/libiio"
EGIT_REPO_URI="https://github.com/analogdevicesinc/libiio"
EGIT_COMMIT="7ce5cd5b508389077aedaaa4d5f1c0b08b78ded5"


LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libxml2
	sys-devel/bison
	sys-devel/flex
	dev-libs/cdk
	net-dns/avahi
	doc? ( app-doc/doxygen )
	"
DEPEND=""

src_configure() {
	python_setup
	cmake-utils_src_configure
}
