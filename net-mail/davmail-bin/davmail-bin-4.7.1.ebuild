EAPI=5

inherit base eutils

KEYWORDS="~amd64 ~x86"
DESCRIPTION="DavMail POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway"
HOMEPAGE="http://davmail.sourceforge.net/"

MY_PN="${PN/-bin}"
MY_PV="${PV}-2416"

SRC_URI="
	amd64? ( mirror://sourceforge/${MY_PN}/${MY_PN}-linux-x86_64-${MY_PV}.tgz )
	x86? ( mirror://sourceforge/${MY_PN}/${MY_PN}-linux-x86-${MY_PV}.tgz )
"
RDEPEND="virtual/jdk"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

PATCHES=(
	"${FILESDIR}/davmail.sh-basepath-fix.patch"
)

if use amd64; then
	S="${WORKDIR}/${MY_PN}-linux-x86_64-${MY_PV}"
elif use x86; then
	S="${WORKDIR}/${MY_PN}-linux-x86-${MY_PV}"
fi

src_install()
{
	dodir "/opt/${MY_PN}"
	cp -r "${S}/lib" "${D}/opt/${MY_PN}/"
	insinto "/opt/${MY_PN}"
	doins "davmail.jar"
	exeinto "/opt/${MY_PN}"
	doexe "davmail.sh"
	dosym "/opt/${MY_PN}/davmail.sh" "/opt/bin/${MY_PN}"
}
