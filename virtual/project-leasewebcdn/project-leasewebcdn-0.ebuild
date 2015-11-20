EAPI=5

DESCRIPTION="Leaseweb CDN"
HOMEPAGE="https://www.leaseweb.com/cdn"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
# dashboard deps
RDEPEND="
	dev-php/composer
	dev-php/pecl-memcached
	dev-php/phpunit
"
# api deps
RDEPEND="
	${RDEPEND}
	dev-python/numpy
	dev-python/pip
	dev-python/virtualenv
	net-im/ejabberd[mod_muc,mod_pubsub]
	sci-libs/scipy
	virtual/libffi
"
