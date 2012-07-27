#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib, sys, re, htmlentitydefs
from optparse import OptionParser

baseurl = 'http://bash.im/%s/'
categories = [ 'index' ]
quotesperpage = 50

opts = OptionParser()
opts.add_option( '-a', '--abyssbest', dest = 'abysstop', action = 'store_true', help = 'fetch abyss best quotes' )
( options, args ) = opts.parse_args()

if options.abysstop == True:
	categories.append( 'abyssbest' )

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
	entry = unescape( entry )
	entry = re.sub( '<[bB][rR] */?>', '\n', entry )
	entry = re.sub( '--', u'—', entry )
	return entry

quotes = open( 'bash.im', 'w' )

for cat in categories:
	num = 1
	lastnum = None
	totalquotes = 0
	url = baseurl % cat
	print 'Fetching pages from %s: ' % cat,
	while lastnum == None or num <= lastnum:
		if num % 10 == 0 or num == 1:
			sys.stdout.write( '%i' % num )
		else:
			sys.stdout.write( '.' )
		sys.stdout.flush()
		try:
			hurl = urllib.urlopen( url + str( num ) )
			page = hurl.read().decode( 'cp1251', 'ignore' )
			hurl.close()
		except ( IOError, AttributeError ):
			print '(retrying)',
			continue

		if lastnum == None:
			m = re.search( u'<input type="text" name="page".+?numeric="integer" min="1" max="(\d+)" value="\d+" />', page )
			if( m ):
				lastnum = int( m.group( 1 ) )
				print ' (total: %i)' % lastnum,
				sys.stdout.flush()
			else:
				print "Cannot get total count of quotes, quitting..."
				break

		quotesextracted = 0
		quotebuffer = ''

		for quote in re.findall( '<div class="text">(.+?)</div>', page ):
			if not ( re.search( 'http://lol.bash.im/?/adclick.php', quote ) \
			   or re.search( '<a href="', quote ) \
			   or re.search( '<script type="text/javascript" src="', quote ) ):
				quotebuffer += parseEntry( quote ).encode( 'utf-8' ) + '\n%\n'
				quotesextracted += 1

		if quotesextracted < quotesperpage:
			if num != 1:
				print ' (only %i quotes, retrying)' % quotesextracted,
				continue
		elif quotesextracted > quotesperpage:
			print ' (ad not filtered)',

		quotes.write( quotebuffer )

		num += 1

	print 'Done'

quotes.close()
