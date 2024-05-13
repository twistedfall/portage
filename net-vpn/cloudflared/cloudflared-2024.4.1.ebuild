EAPI=8

inherit systemd desktop

DESCRIPTION="Cloudflare Tunnel client"
HOMEPAGE="https://github.com/cloudflare/cloudflared"
SRC_URI="amd64? ( https://github.com/cloudflare/${PN}/releases/download/${PV}/${PN}-linux-amd64 -> ${P}-linux-amd64 )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

src_unpack() {
	cp -v "${DISTDIR}/${A}" "${WORKDIR}"
}

src_install() {
	into "/opt/${PN}"
	newbin "${P}-linux-amd64" "${PN}"
	dosym "/opt/${PN}/bin/${PN}" "/bin/${PN}"
}
