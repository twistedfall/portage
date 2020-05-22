EAPI=7

inherit linux-info linux-mod git-r3

EGIT_REPO_URI="https://github.com/danieleds/als.git"
EGIT_BRANCH="master"
EGIT_COMMIT="569f5845a7efc3dbd22f59aa0d9ccec1be2e4b55"

KEYWORDS="~amd64"

DESCRIPTION="ALS (Ambient Light Sensor) ACPI Driver"
HOMEPAGE="https://github.com/danieleds/als"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

MODULE_NAMES="als(misc:${S})"
BUILD_TARGETS="all"

src_prepare() {
	epatch "${FILESDIR}"/Chromacity.patch
}

src_compile() {
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}
