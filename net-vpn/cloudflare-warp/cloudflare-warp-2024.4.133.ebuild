EAPI=8

inherit systemd desktop

DESCRIPTION="Cloudflare WARP client"
HOMEPAGE="https://developers.cloudflare.com/warp-client/"
MY_PN="${PN/-/_}"
MY_PV="${PV//./_}"
HASH="dc941b82de"
SRC_URI="amd64? ( https://pkg.cloudflareclient.com/pool/jammy/main/c/${PN}/${PN}_${PV}-1_amd64.deb -> ${P}-amd64.deb )"

LICENSE="Proprietary"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-apps/dbus"

S="${WORKDIR}"

src_unpack() {
	default_src_unpack
	unpack ./data.tar.gz
}

src_install() {
	into "/opt/${PN}"
	dobin bin/*

	domenu usr/share/applications/com.cloudflare.WarpTaskbar.desktop
	doicon -s scalable usr/share/icons/hicolor/scalable/apps/*.svg

	systemd_dounit lib/systemd/system/warp-svc.service
	systemd_douserunit usr/lib/systemd/user/warp-taskbar.service

	gunzip "usr/share/doc/${PN}/changelog.gz"
	dodoc "usr/share/doc/${PN}/changelog"

	dosym "/opt/${PN}/bin/warp-cli" /bin/warp-cli
	dosym "/opt/${PN}/bin/warp-diag" /bin/warp-diag
	dosym "/opt/${PN}/bin/warp-svc" /bin/warp-svc
	dosym "/opt/${PN}/bin/warp-taskbar" /bin/warp-taskbar
}
