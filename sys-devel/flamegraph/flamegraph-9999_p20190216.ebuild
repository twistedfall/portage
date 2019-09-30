# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

HASH="1b1c6deede9c33c5134c920bdb7a44cc5528e9a7"

DESCRIPTION="stack trace visualizer"
HOMEPAGE="http://www.brendangregg.com/flamegraphs.html"
SRC_URI="https://github.com/brendangregg/FlameGraph/archive/${HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	virtual/awk
"

S="${WORKDIR}/FlameGraph-${HASH}"

src_install() {
	dobin *.pl *.awk
	dodoc README.md
}
