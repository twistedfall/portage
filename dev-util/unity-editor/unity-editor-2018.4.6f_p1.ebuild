# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs desktop eutils unpacker xdg

DESCRIPTION="Editor to create games on the Unity engine"
HOMEPAGE="https://unity3d.com/"
# https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

MY_PV="${PV/_p/}"
HASH="cde1bbcc9f0d"
SRC_URI_BASE="https://beta.unity3d.com/download/${HASH}"
SRC_URI="
	${SRC_URI_BASE}/LinuxEditorInstaller/Unity.tar.xz
		-> ${P}.tar.xz
	doc? ( ${SRC_URI_BASE}/MacDocumentationInstaller/Documentation.pkg
		-> ${P}-doc.pkg )
	android? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-android.pkg )
	ios? ( ${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-${MY_PV}.tar.xz
		-> ${P}-ios.tar.xz )
	mac? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Mac-Mono-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-mac.pkg )
	webgl? ( ${SRC_URI_BASE}/LinuxEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-${MY_PV}.tar.xz
		-> ${P}-webgl.tar.xz )
	windows? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-windows.pkg )
	facebook? ( ${SRC_URI_BASE}/MacEditorTargetInstaller/UnitySetup-Facebook-Games-Support-for-Editor-${MY_PV}.pkg
		-> ${P}-facebook.pkg )
"

LICENSE="Unity-EULA"
SLOT="${PV}"
KEYWORDS="-* ~amd64"
IUSE="android darkskin doc facebook ios mac webgl windows"

REQUIRED_USE="facebook? ( webgl windows )"

DEPEND="
	app-arch/cpio
	app-arch/gzip
	app-arch/xar
	darkskin? ( dev-util/radare2 )
"
RDEPEND="
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc[multilib]
	sys-libs/libcap
	virtual/glu
	virtual/opengl
	x11-libs/gtk+:3[X]
	x11-libs/libXtst
	x11-misc/xdg-utils
	android? (
		dev-util/android-sdk-update-manager
		virtual/jdk
	)
	webgl? (
		app-arch/gzip
		net-libs/nodejs[npm]
		virtual/ffmpeg
		virtual/jre
	)
"

S="${WORKDIR}"

RESTRICT="bindist mirror strip"
QA_PREBUILT="*"

pre_build_checks() {
	# required components + largest component that can be cp'd during install
	CHECKREQS_DISK_BUILD="$((3200 + 3300))"
	use doc && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 1000))"
	use android && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 1400))"
	use ios && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 3300))"
	use mac && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 200))"
	use webgl && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 1000))"
	use windows && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 1400))"
	use facebook && CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD + 200))"
	CHECKREQS_DISK_BUILD="$(($CHECKREQS_DISK_BUILD / 1000 + 1))G"
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks
}

src_unpack() {
	unpkg() {
		mkdir "tmp" || die
		xar -C tmp -xf "${DISTDIR}/${1}" || die
		mv tmp/*.pkg.tmp/Payload Payload.cpio.gz || die
		unpacker Payload.cpio.gz
		rm -r tmp Payload.cpio.gz || die
	}

	local src_file dest_dir
	for src_file in $A; do
		dest_dir="$(basename "${src_file}")"
		dest_dir="${dest_dir%.tar.xz}"
		dest_dir="${dest_dir%.pkg}"
		mkdir "${dest_dir}" || die
		pushd "${dest_dir}" || die
		[[ "${src_file}" == *.pkg ]] && unpkg "${src_file}" || unpack "${src_file}"
		popd || die
	done
}

src_prepare() {
	if use darkskin; then
		cat <<-EOF > "${T}/darkskin.rapatch" || die
			:s method.EditorResources.GetSkinIdx__const
			:s/x 74
			:wao nop
		EOF
		r2 -w -q -P "${T}"/darkskin.rapatch "${P}"/Editor/Unity
	fi
	sed -e 's/\${MY_PV}/'"${MY_PV}/" -e 's/\${P}/'"${P}/" \
		"${FILESDIR}/${PN}".desktop > "${T}/${PN}".desktop
	default
}

src_install() {
	local unity_dir="${D}/opt/${P}"
	local data_dir="${unity_dir}/Editor/Data"
	local engines_dir="${data_dir}/PlaybackEngines"

	mkdir -p "${D}"/opt || die
	cp -a "${P}" "${unity_dir}" || die
	rm -r "${P}" || die
	if use doc; then
		cp -a "${P}"-doc/Documentation "${data_dir}"/Documentation || die
		cp -a "${P}"-doc/Documentation.html "${data_dir}"/Documentation.html || die
		rm -r "${P}"-doc || die
	fi
	if use android; then
		cp -a "${P}"-android "${engines_dir}"/AndroidPlayer || die
		rm -r "${P}"-android || die
	fi
	if use ios; then
		cp -a "${P}"-ios/* "${unity_dir}" || die
		rm -r "${P}"-ios || die
	fi
	if use mac; then
		cp -a "${P}"-mac "${engines_dir}"/MacStandaloneSupport || die
		rm -r "${P}"-mac || die
	fi
	if use webgl; then
		cp -a "${P}"-webgl/* "${unity_dir}" || die
		rm -r "${P}"-webgl || die
	fi
	if use windows; then
		cp -a "${P}"-windows "${engines_dir}"/WindowsStandaloneSupport || die
		rm -r "${P}"-windows || die
	fi
	if use facebook; then
		cp -a "${P}"-facebook "${engines_dir}"/Facebook || die
		rm -r "${P}"-facebook || die
	fi

	make_wrapper "${P}" /opt/"${P}"/Editor/Unity
	newicon -s 256 "${data_dir}"/Resources/LargeUnityIcon.png "${P}"-icon.png
	newmenu "${T}/${PN}".desktop "${P}".desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}
