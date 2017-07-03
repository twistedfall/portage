
EAPI=5

inherit rpm

DESCRIPTION="Brother HL-1210 LPR printer driver"
HOMEPAGE="http://support.brother.com/g/b/downloadend.aspx?c=eu_ot&lang=en&prod=hl1212w_us_eu&os=128&dlid=dlf101547_000&flang=4&type3=559"
SRC_URI="http://download.brother.com/welcome/dlf101549/${PN}-${PV}-1.i386.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="$WORKDIR"

RDEPEND="net-print/cups"

QA_FLAGS_IGNORED="
	opt/brother/Printers/HL1210W/lpd/rawtobr3
	opt/brother/Printers/HL1210W/lpd/brprintconflsr3
	opt/brother/Printers/HL1210W/inf/braddprinter
"

src_compile()
{
	echo \[psconvert2\] >> "${S}/opt/brother/Printers/HL1210W/inf/brHL1210Wfunc"
	echo pstops=/usr/libexec/cups/filter/pstops >> "${S}/opt/brother/Printers/HL1210W/inf/brHL1210Wfunc"
}

src_install()
{
	cp -r "${S}"/* -t "${D}/"
	dosym "/opt/brother/Printers/HL1210W/inf/brHL1210Wrc" "/etc/opt/brother/Printers/HL1210W/inf/brHL1210Wrc"
	exeinto "/usr/bin"
	doexe "${FILESDIR}/brprintconflsr3_HL1210W"
}
