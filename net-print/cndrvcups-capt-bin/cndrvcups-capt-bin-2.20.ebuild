
EAPI="2"

DESCRIPTION="Driver for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://files.canon-europe.com/files/soft40567/software/CAPT_Printer_Driver_for_Linux_V220_uk_EN.tar.gz"

LICENSE="Canon-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=net-print/cndrvcups-common-bin-${PV}
         app-emulation/emul-linux-x86-baselibs
         net-print/cups
         net-libs/gnutls
         sys-libs/zlib"

DEPEND="app-arch/rpm2targz"

S="${WORKDIR}/cndrvcups-capt-${PV}-1.x86_64"

src_unpack()
{
	unpack "${A}"
	rpmunpack "${WORKDIR}/CAPT_Printer_Driver_for_Linux_V220_uk_EN/64-bit_Driver/RPM/cndrvcups-capt-${PV}-1.x86_64.rpm"
}

src_install()
{
	dodir /usr
	cp -r "${S}/usr/bin" "${S}/usr/lib64" "${S}/usr/sbin" "${S}/usr/share" -t "${D}/usr"
	dodir /usr/libexec/
	mv "${D}/usr/lib64"/cups "${D}/usr/libexec"
	dodir /usr/lib32
	cp -r "${S}/usr/lib/"* "${D}/usr/lib32/"
	cp -r "${S}/usr/local/bin" "${S}/usr/local/lib64" "${S}/usr/local/share" -t "${D}/usr"
}
