
EAPI="2"

DESCRIPTION="Quotes from bash.im"
HOMEPAGE="http://bash.im/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+abyssbest"

RDEPEND="games-misc/fortune-mod"

DEPEND=">=dev-lang/python-2.4"

src_unpack()
{
	cd ${WORKDIR}
	einfo "Fetching new quotes file..."
	GENOPTS=
	if use abyssbest;
	then
		GENOPTS="${GENOPTS} --abyssbest"
	fi
	/usr/bin/env python "${FILESDIR}/genborfortunes.py" ${GENOPTS} || die Cannot fetch file
}

src_compile()
{
	cd ${WORKDIR}
	einfo "Converting encoding from UTF-8..."
	cat bash.im | iconv -f utf-8 > bash.im.conv
	mv bash.im.conv bash.im
	einfo "Generating index..."
	strfile bash.im || die Cannot create index
}

src_install()
{
	insinto /usr/share/fortune
	doins ${WORKDIR}/bash.im ${WORKDIR}/bash.im.dat
}
