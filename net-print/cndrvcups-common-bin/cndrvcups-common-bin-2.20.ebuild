
EAPI="2"

DESCRIPTION="Common files for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://files.canon-europe.com/files/soft40567/software/CAPT_Printer_Driver_for_Linux_V220_uk_EN.tar.gz"

LICENSE="Canon-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""

DEPEND="app-arch/rpm2targz"

S="${WORKDIR}/cndrvcups-common-${PV}-1.x86_64"

src_unpack()
{
	unpack "${A}"
	rpmunpack "${WORKDIR}/CAPT_Printer_Driver_for_Linux_V220_uk_EN/64-bit_Driver/RPM/cndrvcups-common-${PV}-1.x86_64.rpm"
}

src_install()
{
	cp -r "${S}/etc" "${D}"
	dodir /usr
	cp -r "${S}/usr/bin" "${S}/usr/include" "${S}/usr/lib64" "${S}/usr/share" -t "${D}/usr"
	dodir /usr/lib32
	cp -r "${S}/usr/lib/"* "${D}/usr/lib32/"
	cp -r "${S}/usr/local/bin" "${S}/usr/local/share" -t "${D}/usr"
}
