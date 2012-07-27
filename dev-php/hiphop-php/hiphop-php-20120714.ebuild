EAPI=2

inherit eutils git-2

EGIT_REPO_URI="https://github.com/facebook/hiphop-php.git"
EGIT_BRANCH="master"
EGIT_COMMIT="96532ec5ec26a694c838355d425450a908d38f1f"

IUSE="jemalloc"

CURL_P="curl-7.21.7"
LIBEVENT_P="libevent-1.4.14b-stable"
JEMALLOC_P="jemalloc-3.0.0"

SRC_URI="http://curl.haxx.se/download/${CURL_P}.tar.bz2
         https://github.com/downloads/libevent/libevent/${LIBEVENT_P}.tar.gz
         jemalloc? ( http://www.canonware.com/download/jemalloc/${JEMALLOC_P}.tar.bz2 )"

DESCRIPTION="HipHop for PHP transforms PHP source code into highly optimized C++"
HOMEPAGE="https://github.com/facebook/hiphop-php"

RDEPEND="
	>=dev-libs/boost-1.37
	sys-devel/flex
	sys-devel/bison
	dev-util/re2c
	dev-db/mysql
	dev-libs/libxml2
	dev-libs/libmcrypt
	dev-libs/icu
	dev-libs/openssl
	sys-libs/libcap
	media-libs/gd
	sys-libs/zlib
	dev-cpp/tbb
	dev-libs/oniguruma
	dev-libs/libpcre
	dev-libs/expat
	dev-libs/libmemcached
	net-nds/openldap
"

DEPEND="
	${RDEPEND}
	dev-util/cmake
	"

SLOT="0"
LICENSE="PHP-3"
KEYWORDS="~amd64"

src_prepare()
{
	git submodule init
	git submodule update
	epatch "${FILESDIR}/support-curl-7.21.7.patch" # https://github.com/facebook/hiphop-php/pull/446
	epatch "${FILESDIR}/use_pcre_fullinfo.patch" # https://github.com/facebook/hiphop-php/pull/522
	export CMAKE_PREFIX_PATH="${D}/usr/lib/hiphop-php"
	einfo "Building custom libevent"
	export EPATCH_SOURCE="${S}/src/third_party"
	EPATCH_OPTS="-d ""${WORKDIR}/${LIBEVENT_P}" epatch libevent-1.4.14.fb-changes.diff
	pushd "${WORKDIR}/${LIBEVENT_P}" > /dev/null
	./configure --prefix="${CMAKE_PREFIX_PATH}"
	emake
	emake -j1 install
	popd > /dev/null
	einfo "Building custom curl"
	EPATCH_OPTS="-d ""${WORKDIR}/${CURL_P}" epatch libcurl.fb-changes.diff
	pushd "${WORKDIR}/${CURL_P}" > /dev/null
	./buildconf
	./configure --prefix="${CMAKE_PREFIX_PATH}"
	emake
	emake -j1 install
	popd > /dev/null
	if use jemalloc;
	then
		einfo "Building jemalloc"
		pushd "${WORKDIR}/${JEMALLOC_P}" > /dev/null
		./configure --prefix="${CMAKE_PREFIX_PATH}"
		emake
		emake -j1 install
		popd > /dev/null
	fi
}

src_configure()
{
	export HPHP_HOME="${S}"
	export HPHP_LIB="${S}/bin"
	econf
}

src_install()
{
	pushd "${WORKDIR}/${LIBEVENT_P}" > /dev/null
	emake -j1 install
	popd > /dev/null
	pushd "${WORKDIR}/${CURL_P}" > /dev/null
	emake -j1 install
	popd > /dev/null
	pushd "${WORKDIR}/${JEMALLOC_P}" > /dev/null
	emake -j1 install
	popd > /dev/null
	rm -rf "${D}/usr/lib/hiphop-php/"{bin,include,share}
	rm -rf "${D}/usr/lib/hiphop-php/lib/pkgconfig"
	rm -f "${D}/usr/lib/hiphop-php/lib/"*.{a,la}
	dobin "${FILESDIR}/hphp"
	dobin "${FILESDIR}/hphpi"
	exeinto "/usr/lib/hiphop-php/bin"
	doexe src/hphp/hphp
	doexe src/hphpi/hphpi
	dodir "/usr/share/hiphop-php"
	insinto "/usr/share/hiphop-php"
	cp -a "${S}/"{bin,CMake} "${D}/usr/share/hiphop-php/"
	doins "LICENSE.PHP"
	doins "LICENSE.ZEND"
	dodir "/usr/share/hiphop-php/src"
	insinto "/usr/share/hiphop-php/src"
	cp -a "${S}/src/"{runtime,system,util,third_party} "${D}/usr/share/hiphop-php/src"
}
