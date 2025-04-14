# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1

MY_COMMIT=bbf2838a474c287e28ed6d348ee252ddaeb9aab0

DESCRIPTION="Mount Apple iPhone/iPod Touch file systems for backup purposes"
HOMEPAGE="https://www.libimobiledevice.org/ https://github.com/libimobiledevice/ifuse/"
SRC_URI="https://github.com/libimobiledevice/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	>=app-pda/libimobiledevice-1.3.0:=
	>=app-pda/libplist-2.2:=
	sys-fs/fuse:0
"
RDEPEND="
	${DEPEND}
	app-pda/usbmuxd
"
BDEPEND="virtual/pkgconfig"

DOC_CONTENTS="Only use this filesystem driver to create backups of your data.
The music database is hashed, and attempting to add files will cause the
iPod/iPhone to consider your database unauthorised.
It will respond by wiping all media files, requiring a restore through iTunes."

PATCHES=(
	"${FILESDIR}/chmod.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
