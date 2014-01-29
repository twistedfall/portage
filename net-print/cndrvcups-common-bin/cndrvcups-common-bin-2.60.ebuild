
EAPI="2"

DESCRIPTION="Common files for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/03/Linux_CAPT_PrinterDriver_V260_uk_EN.tar.gz"

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
	rpmunpack "${WORKDIR}/Linux_CAPT_PrinterDriver_V260_uk_EN/64-bit_Driver/RPM/cndrvcups-common-${PV}-1.x86_64.rpm"
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
