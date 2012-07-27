
DESCRIPTION="Quotes from ithappens.ru"
HOMEPAGE="http://ithappens.ru/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-misc/fortune-mod"

DEPEND=">=dev-lang/python-2.4"

src_unpack() {
	cd "${WORKDIR}"
	einfo "Fetching new quotes file..."
	/usr/bin/env python "${FILESDIR}/genithappensfortunes.py" || die Cannot fetch file
}

src_compile() {
	cd "${WORKDIR}"
	einfo "Converting encoding from UTF-8..."
	cat ithappens.ru | iconv -f utf8 > ithappens.ru.conv
	mv ithappens.ru.conv ithappens.ru
	einfo "Generating index..."
	strfile ithappens.ru || die Cannot create index
}

src_install() {
	insinto /usr/share/fortune
	doins "${WORKDIR}/ithappens.ru" "${WORKDIR}/ithappens.ru.dat"
}
