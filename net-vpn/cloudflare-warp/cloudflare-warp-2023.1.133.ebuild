EAPI=8

inherit systemd desktop

DESCRIPTION="Cloudflare WARP client"
HOMEPAGE="https://developers.cloudflare.com/warp-client/"
MY_PN="${PN/-/_}"
MY_PV="${PV//./_}"
HASH="dc941b82de"
SRC_URI="amd64? ( https://pkg.cloudflareclient.com/uploads/${MY_PN}_${MY_PV}_1_amd64_${HASH}.deb -> ${P}-amd64.deb )"

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

	sed -i -e 's!/bin/warp-svc!/opt/cloudflare-warp/bin/warp-svc!' lib/systemd/system/warp-svc.service || die
	systemd_dounit lib/systemd/system/warp-svc.service
	sed -i -e 's!/bin/warp-taskbar!/opt/cloudflare-warp/bin/warp-taskbar!' usr/lib/systemd/user/warp-taskbar.service || die
	systemd_douserunit usr/lib/systemd/user/warp-taskbar.service

	gunzip "usr/share/doc/${PN}/changelog.gz"
	dodoc "usr/share/doc/${PN}/changelog"

	dosym "/opt/${PN}/bin/warp-cli" /usr/bin/warp-cli
	dosym "/opt/${PN}/bin/warp-diag" /usr/bin/warp-diag
}
