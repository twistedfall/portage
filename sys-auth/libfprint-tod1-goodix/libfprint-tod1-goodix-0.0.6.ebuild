EAPI=8

inherit git-r3 udev

DESCRIPTION="Proprietary userspace driver for the Goodix fingerprint reader on the Dell XPS 2020"
HOMEPAGE="https://launchpad.net/libfprint-2-tod1-goodix"
EGIT_REPO_URI="https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-goodix/+git/libfprint-2-tod1-goodix"
EGIT_COMMIT="0.0.6-0ubuntu1_somerville1"

LICENSE="Proprietary"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	acct-group/plugdev
	>=sys-auth/libfprint-1.90.3
"

src_install() {
	udev_dorules lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules
	exeinto "/usr/$(get_libdir)/libfprint-2/tod-1"
	doexe usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-0.0.6.so
	dodoc debian/changelog debian/copyright
}
