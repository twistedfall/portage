
EAPI="2"

DESCRIPTION="Driver for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100004596/03/Linux_CAPT_PrinterDriver_V260_uk_EN.tar.gz"

LICENSE="Canon-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=net-print/cndrvcups-common-bin-${PV}
         app-emulation/emul-linux-x86-baselibs
         app-emulation/emul-linux-x86-popt
         net-print/cups
         net-libs/gnutls
         sys-libs/zlib
         x11-libs/pangox-compat"

DEPEND="app-arch/rpm2targz"

S="${WORKDIR}/cndrvcups-capt-${PV}-1.x86_64"

src_unpack()
{
	unpack "${A}"
	rpmunpack "${WORKDIR}/Linux_CAPT_PrinterDriver_V260_uk_EN/64-bit_Driver/RPM/cndrvcups-capt-${PV}-1.x86_64.rpm"
}

src_install()
{
	cp -r "${S}/etc" "${D}"
	dodir /usr
	cp -r "${S}/usr/bin" "${S}/usr/lib64" "${S}/usr/sbin" "${S}/usr/share" -t "${D}/usr"
	dodir /usr/libexec/
	mv "${D}/usr/lib64"/cups "${D}/usr/libexec"
	dodir /usr/lib32
	cp -r "${S}/usr/lib/"* "${D}/usr/lib32/"
	cp -r "${S}/usr/local/bin" "${S}/usr/local/lib64" "${S}/usr/local/share" -t "${D}/usr"
}
