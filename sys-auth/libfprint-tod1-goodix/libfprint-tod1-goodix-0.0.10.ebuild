EAPI=8

inherit git-r3 udev

DESCRIPTION="Proprietary userspace driver for the Goodix fingerprint reader on the Dell XPS 2020"
HOMEPAGE="https://launchpad.net/libfprint-2-tod1-goodix"
EGIT_REPO_URI="https://git.launchpad.net/libfprint-2-tod1-goodix"
EGIT_BRANCH="ubuntu/jammy-devel"
EGIT_COMMIT="683f9385877543529734d858a3831130939155dc"

LICENSE="Proprietary"
SLOT="0"
KEYWORDS="~amd64"
IUSE="53xc 550a"

RDEPEND="
	acct-group/plugdev
	>=sys-auth/libfprint-1.94.9[tod]
"

src_install() {
	udev_dorules lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules
	exeinto "/usr/$(get_libdir)/libfprint-2/tod-1"
	if use 53xc; then
		doexe usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-0.0.6.so
	fi
	if use 550a; then
		doexe usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-550a-0.0.9.so
	fi
	dodoc debian/changelog debian/copyright
}

