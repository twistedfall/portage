# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit bash-completion-r1 python-r1 git-r3

DESCRIPTION="Incremental merge for git"
HOMEPAGE="https://github.com/mhagger/git-imerge"
EGIT_REPO_URI="https://github.com/mhagger/git-imerge"
EGIT_BRANCH="master"
EGIT_COMMIT="5d1c5347722e384ec223d21ecca3c4f05cbc95a3"


LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-vcs/git"
DEPEND="dev-python/docutils"

src_compile() {
	rst2html.py README.rst > README.html || die
	rst2s5.py \
		--theme=small-white \
		--current-slide \
		doc/presentations/GitMerge-2013/talk.rst doc/presentations/GitMerge-2013/talk.html || die
}

src_install() {
	dobin ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
	newbashcomp git-imerge.bashcomplete git-imerge
	dodoc README.rst
	dohtml README.html doc/presentations/GitMerge-2013/talk.html
}
