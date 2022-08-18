# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit cmake eutils

DESCRIPTION="Logs OBDII and GPS data"
HOMEPAGE="http://icculus.org/obdgpslogger/"
SRC_URI="http://icculus.org/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="bluez configtest dbus gpsd gui"

DEPEND=""
RDEPEND="dev-embedded/libftdi
        gpsd? ( sci-geosciences/gpsd )
        gui? ( <x11-libs/fltk-2 )
        bluez? ( net-wireless/bluez )"

src_unpack() {
        unpack ${A}
        cd "${S}"
        epatch "${FILESDIR}"/fltk-1.3.patch
}

src_configure() {
        mycmakeargs+=( $(cmake-utils_use configtest OBD_ENABLE_CONFIGTEST)
                $(cmake-utils_use dbus OBD_ENABLE_DBUS)
                $(cmake-utils_use dbus OBD_SIMGEN_DBUS)
                $(cmake-utils_use gpsd OBD_ENABLE_GPSD)
                $(cmake-utils_use gui OBD_SIMGEN_GUI_FLTK) )
        if ! use bluez ; then
                mycmakeargs+=( "-DOBD_SIM_DISABLE_BLUEZ=ON" )
        fi
        if ! use gpsd ; then
                mycmakeargs+=( "-DOBD_DISABLE_GPSD=ON" )
        fi
        if ! use gui ; then
                mycmakeargs+=( "-DOBD_DISABLE_GUI=ON" )
        fi
        cmake-utils_src_configure
}

src_install() {
        dodoc ChangeLog COPYING README TODO
        cmake_src_install
}
