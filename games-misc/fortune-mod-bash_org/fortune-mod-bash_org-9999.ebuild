
DESCRIPTION="Quotes from bash.org"
HOMEPAGE="http://bash.org/"
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
	/usr/bin/env python "${FILESDIR}/genbashfortunes.py" || die Cannot fetch file
}

src_compile()
{
	cd ${WORKDIR}
	einfo "Converting encoding from UTF-8..."
	cat bash.org | iconv -f utf-8 > bash.org.conv
	mv bash.org.conv bash.org
	einfo "Generating index..."
	strfile bash.org || die Cannot create index
}

src_install()
{
	insinto /usr/share/fortune
	doins ${WORKDIR}/bash.org ${WORKDIR}/bash.org.dat
}
