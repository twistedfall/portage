# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib eutils versionator
MY_P=${P/_p/-}
S=${WORKDIR}/${PN}-$(get_version_component_range 1-2)
DESCRIPTION="Canon CUPS Capt driver"
HOMEPAGE="http://www.canon.com/"
SRC_URI="http://gdlp01.c-wss.com/gds/1/0100001301/03/${MY_P}.tar.gz"
LICENSE="CANON"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="amd64"

DEPEND="=net-print/cndrvcups-common-2.20
		>=net-print/cups-1.1.17"

dir=/usr/$(get_libdir)

QA_TEXTRELS="${dir:1}/libcaiocaptnet.so.1.0.0"

RDEPEND="${DEPEND}
		>=sys-apps/portage-2.1.1_pre1
		app-text/ghostscript-gpl
		amd64? (
			>=app-emulation/emul-linux-x86-gtklibs-2.0
			>=app-emulation/emul-linux-x86-baselibs-10.0-r1
		)
		!amd64? (
			dev-libs/popt
			dev-libs/libxml2
		)"

pkg_postinst() {
	einfo "To get your printer working you need to restart cupsd"
	einfo
	einfo "/etc/init.d/cupsd restart"
	einfo
	einfo "Now you can add your printer with either the webinterface or lpadmin"
	einfo
	einfo "/usr/sbin/lpadmin -p LBP3010 -m CNCUPSLBP3050CAPTK.ppd -v ccp:/var/ccpd/fifo0 -E"
	einfo
	einfo "Replace 3050 with either on of the following printers:"
	einfo "1120 1210 2900 3000 3050 3200 3210 3300 5000"
	einfo
	einfo "Now you must register the printer in ccpd, if connected with usb"
	einfo
	einfo "/usr/sbin/ccpdadmin -p LBP3010 -o /dev/usb/lp0"
	einfo 
	einfo "Notice that you can't use LPT port with this driver."
	einfo "If you have a network connection to your printer use -o net:<IP OF PRINTER>" 
	einfo "instead of -o /dev/usb/lp0"
	einfo "See manual for more information,  guide-capt-1.3xE.tar.gz at "
	einfo "http://software.canon-europe.com/software/0023675.asp"
	einfo 
	einfo "Now you can go ahead and start the ccpd daemon"
	einfo
	einfo "/etc/init.d/ccpd start"
	einfo
	einfo "If you have more then one printer just create more fifos in"
	einfo "/var/ccpd/ , increase the fifo number for more printers"
	einfo
	einfo "mkfifo -m 600 /var/ccpd/fifo1; chown lp:lp /var/ccpd/fifo1"
	einfo 
	einfo
	ewarn "If you reinstall make sure the fifo is created in /var/ccpd, if not"
	ewarn "just reinstall again. This is due to bug #136199"
	if use amd64; then
		ewarn
		ewarn "The file /usr/lib32/libpopt.so.0.0.0 doesn't exist in any x86 package yet"
		ewarn "The file comes from a Gentoo x86 machine"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix the cups backend path
	for i in backend pstocapt{,2,3}/filter; do
		sed -i -e 's@libdir@libexecdir@' "${i}/Makefile.am"
	done
}

src_configure() {
	cd driver
	NOCONFIGURE=1 ./autogen.sh
	econf --disable-static
	cd ..
	for i in statusui backend pstocapt pstocapt{,2,3} ppd; do
		cd ${i}
		NOCONFIGURE=1 ./autogen.sh
		econf
		cd ..
	done
}

src_compile() {
	for i in statusui driver backend pstocapt{,2,3} ppd; do
		cd ${i}
		emake
		cd ..
	done
}

src_install() {
	for i in statusui driver backend pstocapt{,2,3} ppd; do
		cd ${i}
		make install DESTDIR=${D}
		cd ..
	done

	if use amd64; then
		OABI=${ABI}
		ABI="x86"
		insinto /usr/lib32
		i="libpopt.so.0.0.0"
		[ ! -e ${FILESDIR}/${i} ] && die "You have to download libpopt.so.0.0.0 from http://bugs.gentoo.org/attachment.cgi?id=132734 and put it to ${FILESDIR} manually!"
		dolib.so ${FILESDIR}/${i}
		dosym ${i} /usr/lib32/${i%.?}
		dosym ${i} /usr/lib32/${i%.?.?}
		dosym ${i} /usr/lib32/${i%.?.?.?}
		ABI=${OABI}
	fi

	# Install the libs
	OABI=${ABI}
	has_multilib_profile && ABI="x86"
	for i in $(cd libs; ls *.so.?.?.?; cd ..); do
		dolib.so libs/${i}
		dosym ${i} /usr/$(get_libdir)/${i%.?}
		dosym ${i} /usr/$(get_libdir)/${i%.?.?}
		dosym ${i} /usr/$(get_libdir)/${i%.?.?.?}
	done
	
	# Install bin
	dobin 	libs/captdrv \
		libs/captfilter \
		libs/captemon/captmoncnab6 \
		libs/captemon/captmoncnab7 \
		libs/captemon/captmoncnab8 \
		libs/captemon/captmoncnab9 \
		libs/captemon/captmoncnaba \
		libs/captemon/captmoncnac5 \
		libs/captemon/captmoncnac6 \
		libs/captemon/captmoncnac8 \
		libs/captemon/captmoncnac9 \
		libs/captemon/captmonlbp3300 \
		libs/captemon/captmonlbp5000 \
		libs/captemon/captmonlbp3300 \
		libs/captmon/captmon \
		libs/captmon2/captmon2

	# Install sbin
	if use amd64; then
	    dosbin libs64/ccpd libs64/ccpdadmin
	else
	    dosbin libs/ccpd libs/ccpdadmin
	fi

	ABI=${OABI}

	# Install the data
	insinto /usr/share/ccpd
	doins libs/ccpddata/*

	insinto /usr/share/captmon
	doins libs/captmon/msgtable.xml

	insinto /usr/share/captmon2
	doins libs/captmon2/msgtable2.xml

	insinto /usr/share/captemon
	doins libs/captemon/*.xml

	insinto /usr/share/caepcm
	doins data/CnA* libs/CnA* data/CNL*

	# Install doc
	dodoc LICENSE* README* COPYING

	for i in statusui driver backend pstocapt{,2,3} ppd; do
		docinto ${i}
		dodoc ${i}/NEWS ${i}/README ${i}/AUTHORS ${i}/ChangeLog ${i}/LICENSE*
	done


	# Fix the fifos
	dodir /var/ccpd
	mkfifo -m 600 ${D}/var/ccpd/fifo0
	fowners lp:lp /var/ccpd/fifo0
	
	# fix captmon
	dodir /var/captmon
	fowners lp:lp /var/captmon
	keepdir /var/captmon

	# Install startupscripts
	newinitd ${FILESDIR}/${PN}-init.d ccpd
	
	insinto /etc
	doins samples/ccpd.conf
}
