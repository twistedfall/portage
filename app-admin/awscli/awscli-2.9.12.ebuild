# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Universal Command Line Environment for AWS"
HOMEPAGE="https://github.com/aws/aws-cli/"
SRC_URI="https://${PN}.amazonaws.com/${PN}-exe-linux-x86_64-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="splitdebug"

S=${WORKDIR}/aws

src_install() {
	./install -i "${D}/opt/awscli" -b "${D}/opt/bin"
}
