# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit python-single-r1 toolchain-funcs

HASH="0a54991e669e8636b129a60e9ff5baa2fc91d1af"

DESCRIPTION="TCP tunneling over RDP virtual channels (rdesktop/FreeRDP)"
HOMEPAGE="https://github.com/v-e-o/rdp2tcp"
SRC_URI="https://github.com/v-e-o/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HASH}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+python server"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="python? ( ${PYTHON_DEPS} )"
BDEPEND="server? ( dev-util/mingw64-toolchain[abi_x86_32] )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_compile() {
	# Client and server share ../common objects, and every sub-Makefile
	# starts with "clean_common", so targets must be built one at a time.
	emake -j1 -C client \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall -I../common" \
		LDFLAGS="${LDFLAGS}"

	if use server; then
		local -x PATH="${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}"
		# Host CFLAGS/LDFLAGS are not suitable for the PE cross target.
		local crossflags="${CROSSCFLAGS:--O2 -pipe} -Wall -D_WIN32_WINNT=0x0501 -I../common"
		local arch
		for arch in 32 64; do
			emake -j1 -C server -f Makefile.mingw${arch} \
				CFLAGS="${crossflags}" BUILD_CFLAGS=
			# Both Makefiles write server/rdp2tcp.exe
			mv server/rdp2tcp.exe rdp2tcp-win${arch}.exe || die
			emake -j1 -C server -f Makefile.mingw${arch} clean
		done
	fi
}

src_install() {
	dobin client/rdp2tcp

	if use python; then
		python_doscript tools/rdp2tcp.py
	fi

	if use server; then
		local arch
		for arch in 32 64; do
			insinto /usr/share/${PN}/win${arch}
			newins rdp2tcp-win${arch}.exe rdp2tcp.exe
		done
	fi

	dodoc AUTHORS ChangeLog FAQ README TODO
}

pkg_postinst() {
	elog "Start the client from your RDP client, for example:"
	elog "  xfreerdp /v:host /rdp2tcp:${EROOT}/usr/bin/rdp2tcp"
	elog "  rdesktop -r addin:rdp2tcp:${EROOT}/usr/bin/rdp2tcp host  (needs OOP patch)"
	if use server; then
		elog
		elog "Upload the matching server binary to the Terminal Server:"
		elog "  ${EROOT}/usr/share/${PN}/win32/rdp2tcp.exe"
		elog "  ${EROOT}/usr/share/${PN}/win64/rdp2tcp.exe"
	fi
}
