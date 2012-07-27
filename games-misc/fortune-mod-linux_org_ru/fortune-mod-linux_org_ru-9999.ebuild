
DESCRIPTION="Quotes from linux.org.ru"
HOMEPAGE="http://lorquotes.ru/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-misc/fortune-mod"

src_unpack()
{
	cd ${WORKDIR}
	einfo "Fetching new quotes file..."
	rm fortraw.php &> /dev/null
	wget -nv "http://lorquotes.ru/fortraw.php" || die Cannot fetch file
}

src_compile()
{
	cd ${WORKDIR}
	einfo "Converting encoding from KOI8-R"...
	cat fortraw.php | iconv -f koi8r > linux.org.ru || die Cannot convert encoding
	einfo "Generating index..."
	strfile linux.org.ru || die Cannot create index
}

src_install()
{
	insinto /usr/share/fortune
	doins ${WORKDIR}/linux.org.ru ${WORKDIR}/linux.org.ru.dat
}
