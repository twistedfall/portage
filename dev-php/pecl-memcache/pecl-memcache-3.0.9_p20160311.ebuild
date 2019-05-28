# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PHP_EXT_NAME="memcache"
DOCS=( README )
PATCHES=( "${FILESDIR}/static_inline.patch" )

EGIT_REPO_URI="https://github.com/websupport-sk/pecl-memcache"
EGIT_COMMIT="4991c2fff22d00dc81014cc92d2da7077ef4bc86"

USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-source-r3 git-r3

KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"

DESCRIPTION="PHP extension for using memcached"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

# The test suite requires memcached to be running.
RESTRICT='test'

src_unpack() {
	git-r3_src_unpack
	php-ext-source-r3_src_unpack
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=( --enable-memcache --with-zlib-dir=/usr $(use_enable session memcache-session) )
	php-ext-source-r3_src_configure
}

src_install() {
	php-ext-source-r3_src_install

	php-ext-source-r3_addtoinifiles "memcache.allow_failover" "true"
	php-ext-source-r3_addtoinifiles "memcache.max_failover_attempts" "20"
	php-ext-source-r3_addtoinifiles "memcache.chunk_size" "32768"
	php-ext-source-r3_addtoinifiles "memcache.default_port" "11211"
	php-ext-source-r3_addtoinifiles "memcache.hash_strategy" "consistent"
	php-ext-source-r3_addtoinifiles "memcache.hash_function" "crc32"
	php-ext-source-r3_addtoinifiles "memcache.redundancy" "1"
	php-ext-source-r3_addtoinifiles "memcache.session_redundancy" "2"
	php-ext-source-r3_addtoinifiles "memcache.protocol" "ascii"
}
