#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib, sys, re, htmlentitydefs

baseurl = 'http://bash.org/?%s&p='
categories = ( 'browse', )
quotesperpage = 50

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
	entry = re.sub( '<[bB][rR] */?>', '', entry )
	entry = re.sub( '--', u'—', entry )
	return entry

quotes = open( 'bash.org', 'w' )

for cat in categories:
	num = 1
	lastnum = None
	totalquotes = 0
	url = baseurl % cat
	print 'Fetching pages from %s:' % cat,
	while lastnum == None or num <= lastnum:
		print '%i..' % num,
		sys.stdout.flush()
		try:
			hurl = urllib.urlopen( url + str( num ) )
			page = hurl.read().decode( 'latin1' )
			hurl.close()
		except ( IOError, AttributeError ):
			print '(retrying)',
			continue

		if lastnum == None:
			m = re.search( '<a href="\?%s&p=(\d+)" class="qa">End</a>' % cat, page )
			if( m ):
				lastnum = int( m.group( 1 ) )
				print '(total: %i)' % lastnum,
				sys.stdout.flush()
			else:
				print "Cannot get total count of quotes, quitting..."
				break

		quotesextracted = 0
		quotebuffer = ''

		for quote in map( parseEntry, re.findall( '<p class="qt">(.+?)</p>', page, re.DOTALL ) ):
			quotebuffer += quote.encode( 'utf-8' ) + '\n%\n'
			quotesextracted += 1

		if quotesextracted < quotesperpage:
			if num < lastnum:
				print '(only %i quotes, retrying)' % quotesextracted,
				continue

		quotes.write( quotebuffer )

		num += 1

	print 'Done'

quotes.close()
