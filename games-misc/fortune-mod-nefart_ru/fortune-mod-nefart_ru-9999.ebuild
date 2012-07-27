
DESCRIPTION="Quotes from nefart.ru"
HOMEPAGE="http://nefart.ru/"
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
	/usr/bin/env python "${FILESDIR}/gennefartfortunes.py" || die Cannot fetch file
}

src_compile()
{
	cd ${WORKDIR}
	einfo "Converting encoding from UTF-8..."
	cat nefart.ru | iconv -f utf8 > nefart.ru.conv
	mv nefart.ru.conv nefart.ru
	einfo "Generating index..."
	strfile nefart.ru || die Cannot create index
}

src_install()
{
	insinto /usr/share/fortune
	doins ${WORKDIR}/nefart.ru ${WORKDIR}/nefart.ru.dat
}
