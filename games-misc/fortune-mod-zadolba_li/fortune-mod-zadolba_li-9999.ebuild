
DESCRIPTION="Quotes from zadolba.li"
HOMEPAGE="http://zadolba.li/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="games-misc/fortune-mod"

src_unpack() {
	cd "${WORKDIR}"
	einfo "Fetching new quotes file..."
	/usr/bin/env python "${FILESDIR}/genzadolbalifortunes.py" || die Cannot fetch file
}

src_compile() {
	cd "${WORKDIR}"
	einfo "Converting encoding from UTF-8..."
	cat zadolba.li | iconv -f utf8 > zadolba.li.conv
	mv -f zadolba.li.conv zadolba.li
	einfo "Generating index..."
	strfile zadolba.li || die Cannot create index
}

src_install() {
	insinto /usr/share/fortune
	doins "${WORKDIR}/zadolba.li" "${WORKDIR}/zadolba.li.dat"
}
