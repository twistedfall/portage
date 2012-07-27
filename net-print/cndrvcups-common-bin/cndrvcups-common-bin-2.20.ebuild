
DESCRIPTION="Common files for Canon printers"
HOMEPAGE="http://www.canon-europe.com/"
SRC_URI="http://files.canon-europe.com/files/soft40355/software/o1113enx_l_ufr220.zip"
EAPI="2"

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
	rpmunpack "${WORKDIR}/UK/64-bit_Driver/RPM/cndrvcups-common-${PV}-1.x86_64.rpm"
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
