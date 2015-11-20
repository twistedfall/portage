
EAPI="5"

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

src_install()
{
	cp -r "${S}/opt" "${D}"
	dodir "/usr/libexec/cups/filter/"
	ln -s "/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W" "${D}/usr/libexec/cups/filter"
	dodir "/usr/share/cups/model"
	ln -s "/opt/brother/Printers/HL1210W/cupswrapper/brother-HL1210W-cups-en.ppd" "${D}/usr/share/cups/model"
}
