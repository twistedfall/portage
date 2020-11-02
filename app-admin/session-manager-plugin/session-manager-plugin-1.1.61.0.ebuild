EAPI=7

inherit systemd

DESCRIPTION="Amazon Session Manager Plugin for managing Session Manager APIs"
HOMEPAGE="https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
SRC_URI="amd64? ( https://s3.amazonaws.com/session-manager-downloads/plugin/${PV}/ubuntu_64bit/${PN}.deb -> ${P}-amd64.deb )
	x86? ( https://s3.amazonaws.com/session-manager-downloads/plugin/${PV}/ubuntu_32bit/${PN}.deb -> ${P}-x86.deb )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

RDEPEND=">=dev-python/awscli-1.16.12"

S="${WORKDIR}"

src_unpack() {
	default_src_unpack
	unpack ./data.tar.gz
}

src_install() {
	if use systemd; then
		sed -i -e 's!/usr/local/sessionmanagerplugin/!/opt/sessionmanagerplugin/!' lib/systemd/system/session-manager-plugin.service || die
		systemd_dounit lib/systemd/system/session-manager-plugin.service
	fi
	insinto /opt/
	doins -r usr/local/sessionmanagerplugin
	fperms 0775 /opt/sessionmanagerplugin/bin/session-manager-plugin

	tar -xaf usr/share/doc/sessionmanagerplugin/*.gz -C usr/share/doc/sessionmanagerplugin/
	rm -f usr/share/doc/sessionmanagerplugin/*.gz

	dodoc usr/share/doc/sessionmanagerplugin/*

	dosym /opt/sessionmanagerplugin/bin/session-manager-plugin /usr/bin/session-manager-plugin
}
