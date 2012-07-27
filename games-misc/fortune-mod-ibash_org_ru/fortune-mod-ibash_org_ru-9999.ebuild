
DESCRIPTION="Quotes from ibash.org.ru"
HOMEPAGE="http://ibash.org.ru/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-misc/fortune-mod"

DEPEND=">=dev-lang/python-2.4"

src_unpack()
{
	cd ${WORKDIR}
	einfo "Fetching new quotes file..."
	/usr/bin/env python "${FILESDIR}/geniborfortunes.py" || die Cannot fetch file
}

src_compile()
{
	cd ${WORKDIR}
	einfo "Converting encoding from UTF-8..."
	cat ibash.org.ru | iconv -f utf8 > ibash.org.ru.conv
	mv ibash.org.ru.conv ibash.org.ru
	einfo "Generating index..."
	strfile ibash.org.ru || die Cannot create index
}

src_install()
{
	insinto /usr/share/fortune
	doins ${WORKDIR}/ibash.org.ru ${WORKDIR}/ibash.org.ru.dat
}
