
EAPI=5

inherit rpm

DESCRIPTION="Brother HL-1210 CUPSwrapper printer driver"
HOMEPAGE="http://support.brother.com/g/b/downloadhowto.aspx?c=es&lang=es&prod=hl1212w_us_eu&os=127&dlid=dlf101548_000&flang=4&type3=560"
SRC_URI="http://download.brother.com/welcome/dlf101548/${PN}-${PV}-1.i386.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="$WORKDIR"

RDEPEND="=net-print/hl1210wlpr-${PV}"

QA_FLAGS_IGNORED="/opt/brother/Printers/HL1210W/cupswrapper/brcupsconfig4"

src_install()
{
	insinto /
	doins -r opt
	dodir "/usr/libexec/cups/filter/"
	dosym "/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W" "/usr/libexec/cups/filter/brother_lpdwrapper_HL1210W"
	dodir "/usr/share/cups/model"
	dosym "/opt/brother/Printers/HL1210W/cupswrapper/brother-HL1210W-cups-en.ppd" "/usr/share/cups/model/brother-HL1210W-cups-en.ppd"
}
