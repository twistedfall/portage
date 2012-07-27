#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib, sys, re, htmlentitydefs

baseurl = 'http://zadolba.li/page/'

# ripped from mailing lists

def unescape_charref(ref):
	name = ref[2:-1]
	base = 10
	if name.startswith("x"):
		name = name[1:]
		base = 16
	return unichr(int(name, base))

def replace_entities(match):
	ent = match.group()
	if ent[1] == "#":
		return unescape_charref(ent)

	repl = htmlentitydefs.name2codepoint.get(ent[1:-1])
	if repl is not None:
		repl = unichr(repl)
	else:
		repl = ent
	return repl

def unescape(data):
	return re.sub(r"&#?[A-Za-z0-9]+?;", replace_entities, data)

# rip end

def parseEntry( entry ):
	title = re.sub( '<.+?>', '', entry[ 0 ] )
	title = re.sub( '\s{2,}', ' ', title )
	text = entry[ 1 ]
	text = text.replace( '<br>', '\n' )
	text = re.sub( '</?[bi]>', '', text )
	text = re.sub( '<a href="(.+?)">(.+?)</a>', '\\2 [\\1]', text )
	text = unescape( text )
	return "%s\n%s\n%s" % ( title, ''.ljust( len( title ), '-' ), text )

quotes = open( 'zadolba.li', 'w' )

num = 1
lastnum = None
totalquotes = 0
print 'Fetching pages:',
while lastnum == None or num <= lastnum:
	print '%i..' % num,
	sys.stdout.flush()
	try:
		hurl = urllib.urlopen( baseurl + str( num ) )
		page = hurl.read().decode( 'cp1251' )
		hurl.close()
	except ( IOError, AttributeError ):
		print '(retrying)',
		continue

	if lastnum == None:
		m = re.search( u'<p class="selector">\s*<a href="/page/(\d+)">', page )
		if( m ):
			lastnum = int( m.group( 1 ) )
			print '(total: %i)' % lastnum,
			sys.stdout.flush()
		else:
			print "Cannot get total count of quotes, quitting..."
			break

	quotebuffer = ''

	for quote in map( parseEntry, re.findall( '<div class="story">\s*<h2>(.+?)</h2>.*?<p>(.+?)</p>', page, re.DOTALL ) ):
		quotebuffer += quote.encode( 'utf-8' ) + '\n%\n'

	quotes.write( quotebuffer )

	num += 1

print 'Done'

quotes.close()
