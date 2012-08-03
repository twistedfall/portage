
DESCRIPTION="The Human Cursor theme"
HOMEPAGE="https://launchpad.net/human-cursors-theme/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/human-cursors-theme_0.6.tar.gz"
LICENSE="CCPL-Attribution-ShareAlike-2.5"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/python"

S=${WORKDIR}/human-cursors-theme-${PV}

src_install()
{
	python setup.py install --prefix=${D}/usr
	# move cursor files to correct places
	dodir /usr/share/cursors/xorg-x11
	mv ${D}/usr/share/icons/Human ${D}/usr/share/cursors/xorg-x11
	rm -rf ${D}/usr/share/icons
	rm -rf ${D}/usr/share/themes
	cd ${S}
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
	# do cursor cleanup and alias setup
	cd ${D}/usr/share/cursors/xorg-x11/Human/cursors
	rm 08e8e1c95fe2fc01f976f1e063a24ccd # redundant file, will symlink it later
	# setup names according to specs
	ln -s fleur					allscroll
	ln -s based_arrow_down		based-down
	ln -s based_arrow_up		based-up
	ln -s sb_h_double_arrow		coll-resize
	ln -s left_ptr				default
	ln -s right_side			e-resize
	ln -s sb_h_double_arrow		ew-resize
	ln -s question_arrow		help
	ln -s hand1					left-hand
	ln -s left_ptr				move
	ln -s top_right_corner		ne-resize
	ln -s X_cursor				no-drop
	ln -s top_side				n-resize
	ln -s sb_v_double_arrow		ns-resize
	ln -s top_left_corner		nw-resie
	ln -s X_cursor				pirate
	ln -s hand2					pointer
	ln -s left_ptr_watch		progress
	ln -s sb_right_arrow		right
	ln -s sb_v_double_arrow		row-resize
	ln -s bottom_right_corner	se-resize
	ln -s bottom_side			s-resize
	ln -s bottom_left_corner	sw-resize
	ln -s xterm					text
	ln -s top_left_arrow		top-left-arrow
	ln -s right_ptr				top-right-arrow
	ln -s sb_up_arrow			up
	ln -s watch					wait
	ln -s left_side				w-resize
	ln -s X_cursor				x-cursor
	# setup hashes
	ln -s ns-resize		00008160000006810000408080010102
	ln -s ew-resize		028006030e0e7ebffc7f7070c0600140
	ln -s no-drop		03b6e0fcb3499374a867c041f52298f0
	ln -s wait			0426c94ea35c87780ff01dc239897213
	ln -s progress		08e8e1c95fe2fc01f976f1e063a24ccd
	ln -s coll-resize	14fef782d02440884392942c11205230
	ln -s row-resize	2870a09082c103050810ffdffffe0204
	ln -s progress		3ecb610c1bf2410f44200f48c40d3599
	ln -s move			4498f0e0c1937ffe01fd06f973665830
	ln -s move			9081237383d90e509aa00f00170e968f
	ln -s left-hand		9d800788f1b08800ae810202380a0822
	ln -s help			d9ce0ab605698f320427677b458ad60b
	ln -s pointer		e29285e634086352946a0e7090d73106
}
