#!/usr/bin/perl --
require 5;

=item overview

AXS Script Set, Logging Module
Copyright 1997-2004 by Fluid Dynamics

Please adhere to the copyright notice and conditions of use as described at the URL below.  For latest version and help files, visit:
	http://www.xav.com/scripts/axs/

<h1>If you can see this text from a web browser, then there is a problem. <a
href="http://www.xav.com/scripts/axs/help/1089.html">Get help here.</a></h1><xmp>

The AXS proprietary log is pipe-delimited and newline separated.  Each record contains null leading and trailing fields.  The fields are:

0	NULL
1	resolved-ip-address
2	ip-address
3	from-url
4	to-url
5	browser-string
6	time-seconds 0..59
7	time-minutes 0..59
8	time-hour 0..23
9	day-of-month 1..31
10	month-of-year 0..11
11	year-1900 (i.e., 100=>2000, 103=>2003)
12	day-of-week 0..6, sunday=0, saturday=6
13	day-of-year 0..364 0==jan1, 364/65=dec31
14	export||'' bit field; contains literal word "export" if and only if this was a redirect
15	NULL/newline



=cut

my $VERSION = '2.3.0.0041';

# Enter the location of your log file relative to this script.  This is path
# and file name, not a web address.  Leave as-is for a default install.

my $LogFile = 'log.txt';

# Logging can be disabled after the log exceeds a certain size.  To use this
# feature, enter a non-zero number for the maximum byte size for your log
# file.  Leave it at zero to always log, without size restriction.

my $MaxLogSize = 0;

# This script will not log visits from users with hostnames or IP addresses
# listed below.  Use all lowercase names.  Empty the array to log everyone:

my @IgnoreHosts = ();

# Example:
#
# @IgnoreHosts = ('.foobar.org', 'host.example.co.uk', '250.245.240.');

# This maps hostnames to a consistent format; for example, if your site can
# be addressed as http://xav.com/ and http://www.xav.com/ then this set of
# mappings can convert all URL's to a consistent format.
#
# Format is:
#	Original-String, Final-String,
#
# The To and From web addresses will have a find-and-replace operation done
# on them with each name-value pair in the %Maps hash.  The operation will be
# done as a case insensitive substring match.

my %Maps = (
	'http://xav.com/'     => 'http://www.xav.com/',
	'http://ftp.xav.com/' => 'http://www.xav.com/',
	);

# Once the script is working to your satisfaction, set the $AllowDebug
# variable to zero:

my $AllowDebug = 1;


# When this is set to 1, ax.pl will perform DNS lookups on unresolved
# visitors (i.e., "140.140.58.1" becomes "anaconda.brooks.af.mil").  DNS
# resolution is a sometimes slow and time-consuming process, and you can
# improve speed by setting this to 0.

my $resolve_dns_names = 1;


my $use_ssi_detect = 1;

# __________________________________________________________________
#
# The following shouldn't need to be changed:

my $domain = 'http://' . &query_env('SERVER_NAME','localhost');

# If your webserver doesn't support SERVER_NAME, then set this variable
# as the top-level URL to your server without a trailing slash, e.g.:
#
#	my $domain = 'http://www.xav.com';
#

my $header = "Content-type: text/html\015\012\015\012";

# This should be deleted if the content-type header is being echoed out
# to your SSI output, otherwise leave as is.


# This variable allows you to correct for a different time zone if
# your ISP is somewhere else.  This is an integer of +/- a certain number
# of hours.  i.e., ISP is in Pennsylvania and owner is in Seattle:
#	$TimeOffsetInHours = -3;
# ISP in Australia, owner in London:
#	$TimeOffsetInHours = +12;

my $TimeOffsetInHours = 0;


# If every visitor is being logged twice, try setting the following variable
# to 1:

my $NoLogHead = 0;

# ___________________________________________________________________________


%::private = ();
$::private{'PRINT_HTTP_STATUS_HEADER'} = 0;

my %FORM = ();
&WebFormL(\%FORM);

my $Export = 0;

if (($0 =~ m!^(.+)(\\|/)!) and ($0 !~ m!safeperl\d*!i)) {
	chdir($1);
	}



# $mode is one of:
#
#	ssi => server-side include call; no output
#	redir => redirect visitor to the URL given in nexturl
#	img => return a 1x1 pixel transparent gif
#	debug => returns debug print

	my $mode = $FORM{'mode'} || '';


	# $ref is the full URL of the referring file.  If not given, will query HTTP_REFERER

	my $ref = $FORM{'ref'} || $ENV{'HTTP_REFERER'} || '';


	# $to is the full URL of the file being visited.  If not given, will be pulled from various environment variables

	my $to = $FORM{'to'} || '';
	if ($mode eq 'img') {
		$to = &query_env('HTTP_REFERER');
		}


	my $nexturl = $FORM{'nexturl'} || '';

	my $qs = &query_env('QUERY_STRING');

	DetectMode: {

		# is the mode explicitly set?
		last if (($mode eq 'img') or ($mode eq 'redir'));

		# SSI call:

		if ($use_ssi_detect) {

			if ($ENV{'DOCUMENT_URI'}) {
				$mode = 'ssi' unless ($mode);
				unless ($to) {
					$to = $domain . $ENV{'DOCUMENT_URI'};
					if ($ENV{'REDIRECT_QUERY_STRING'}) {
						$to .= '?' . $ENV{'REDIRECT_QUERY_STRING'};
						}
					}
				last;
				}

			# Alternate SSI call (via REQUEST_URI not DOCUMENT_URI)

			if ($ENV{'REQUEST_URI'} and ($qs eq '')) {
				$mode = 'ssi' unless ($mode);
				unless ($to) {
					$to = $domain . $ENV{'REQUEST_URI'};
					}
				last;
				}

			# Alt SSI call on Windows/IIS

			if ((&query_env('SERVER_SOFTWARE') =~ m!iis!i) and ($ENV{'PATH_INFO'} ne $ENV{'SCRIPT_NAME'})) {
				$mode = 'ssi' unless ($mode);
				unless ($to) {
					$to = $domain . $ENV{'SCRIPT_NAME'};
					}
				last;
				}

			}


		# trans image logging:

		if ($qs =~ m!^(\w+)\.gif(\&ref=)?(.*)$!i) {
			$mode = 'img' unless ($mode);
			$ref = $3 if ($3);
			$to = &query_env('HTTP_REFERER');
			last;
			}

		# redirect

		if (($qs) and ($qs ne 'debugme')) {
			$mode = 'redir' unless ($mode);
			$nexturl = $qs unless ($nexturl);
			$Export = 1;
			last;
			}

		if (lc($qs) eq 'debugme') {
			$mode = 'debug';
			last;
			}

		}

	if ($mode eq 'redir') {
		$to = $nexturl;
		}


	# provide output the user first, independent of logging action:

	if ($mode eq 'ssi') {
		print "$header\n \n";
		}
	elsif ($mode eq 'img') {
		&Print_Image;
		}
	elsif ($mode eq 'redir') {
		# 0040 strip vertical whitespace for security
		$nexturl =~ s!\r|\n|\015|\012!!sg;
		print "HTTP/1.0 301 Moved\015\012" if ($::private{'PRINT_HTTP_STATUS_HEADER'});
		print "Location: $nexturl\015\012\015\012";
		}
	elsif ($mode eq 'debug') {
		&SpawnDebugger;
		}
	else {
		# we should never get here, this is just a valid HTTP response
		# in case of mis-configuration or whatever:
		print "HTTP/1.0 200 OK\015\012" if ($::private{'PRINT_HTTP_STATUS_HEADER'});
		print $header;
		print "<p>$0 - working okay - no logging command received - use ?debugme query string for more info.</p>";
		}







	# decide whether or not to log this visit:

	my $err = '';
	Err: {

		last Err if ($mode eq 'debug');

		last Err if (&query_env('HTTP_COOKIE') =~ m!axs_no_log=1!);

		last Err if (($NoLogHead) and (&query_env('REQUEST_METHOD') eq 'HEAD'));

		my ($vhost, $vaddr) = &resolve_host($resolve_dns_names);
		my $ighost = '';
		foreach $ighost (@IgnoreHosts) {
			$ighost = quotemeta($ighost);
			next unless ($ighost);
			last Err if ($vhost =~ m!$ighost!);
			last Err if ($vaddr =~ m!$ighost!);
			}

		# Note: you can filter on other things as well.  If you want to ignore people
		# arriving from a certain site, like Yahoo, you can write the following (note
		# that HTTP_REFERER is used instead of REMOTE_HOST):
		#
		#	@ignore = ('yahoo.com', 'av.yahoo.com');
		#	foreach (@ignore) {
		#		exit if ($ENV{'HTTP_REFERER'} =~ m!$_!);
		#		}



		# don't fill up the file system:

		my $LogSize = -s $LogFile || 0;
		last Err if (($MaxLogSize) and ($MaxLogSize < $LogSize));



		# cleanse the data:

		my ($clean_url, $host, $port, $path, $is_valid) = &parse_url($ref);
		if ($is_valid) {
			$ref = $clean_url;
			}

		($clean_url, $host, $port, $path, $is_valid) = &parse_url($to);
		if ($is_valid) {
			$to = $clean_url;
			}

		# Apply the mappings:
		foreach (keys %Maps) {
			$to =~ s!$_!$Maps{$_}!ig;
			$ref =~ s!$_!$Maps{$_}!ig;
			}

		&log_visit($vhost,$vaddr,$ref,$to);

		last Err;
		}


sub Print_Image {
	print "HTTP/1.0 200 OK\015\012" if ($::private{'PRINT_HTTP_STATUS_HEADER'});
	print "Pragma: no-cache\015\012";
	print "Expires: Saturday, February 15, 1997 10:10:10 GMT\015\012";
	print "Content-Type: image/gif\015\012\015\012";
	binmode(STDOUT);
	foreach (71,73,70,56,57,97,1,0,1,0,128,255,0,192,192,192,0,0,0,33,249,4,1,0,0,0,0,44,0,0,0,0,1,0,1,0,0,1,1,50,0,59) {
		print pack('C',$_);
		}
	}

# ___________________________________________________________________________

# This runs a filesystem test against $LogFile and dumps a ton of (hopefully)
# useful information to the screen:

sub SpawnDebugger {
	print "HTTP/1.0 200 OK\015\012" if ($::private{'PRINT_HTTP_STATUS_HEADER'});
	print "Content-Type: text/html\015\012\015\012";

	unless ($AllowDebug) {
		print '<p><b>Error:</b> no output available because $AllowDebug = 0 in this script.</p>';
		return 0;
		}





my $filesys_test = '';
my $filesys_ok = 0;
TEST: {

	if (-e $LogFile) {
		my ($LogSize,$LastModT) = (stat($LogFile))[7,9];
		$LastModT = scalar localtime($LastModT);
		$filesys_test .= "<p>The log file, <tt>$LogFile</tt>, exists with size $LogSize bytes. It was last modified on $LastModT. ";
		if (open(FILE,">>$LogFile")) {
			binmode(FILE);
			close(FILE);
			$filesys_test .= "The log file is writable.</p><p><font color=\"#008811\"><b>The filesystem test passed!</b></font></p>";
			$filesys_ok = 1;
			}
		else {
$filesys_test .= <<"EOM";

However, the log file is not writable. The filesystem returned <tt>"$!"</tt> when this script tried to write to it. You need to change the file permissions to make it script-writable.</p>

<p><font color="#ff0000"><b>The filesystem test failed.</b></font></p>

EOM
			last TEST;
			}
		}
	elsif (open(FILE,">>$LogFile")) {
		binmode(FILE);
		close(FILE);
$filesys_test .= <<"EOM";

<p>The log file, <tt>$LogFile</tt>, did not exist when this script started. However, this script attempted to create it for you, and the server responded that this was successful. So everything <i>should</i> be fine now. Reload this web page, and hopefully you will see a message that the file system test has passed. If it does not pass, and instead you get an error or you get this message again, then you will have to manually create the log file and set it's permissions.</p>

<p><font color="#ff0000"><b>The filesystem test needs to be run again.</b></font> (reload this page)</p>

EOM
		last TEST;
		}
	else {
$filesys_test .= <<"EOM";

<p>The log file, <tt>$LogFile</tt>, doesn't exist. You need to create one and give it writable permissions. Alternately, the log file may exist but the <tt>\$LogFile</tt> variable might not point to the correct location, in which case you will need to change your variable.</p>

<p><font color="#ff0000"><b>The filesystem test failed.</b></font></p>
EOM
		last TEST;
		}
	}


	my $homelink = '';
	my @ext = ('pl', 'cgi');
	if ($0 =~ m!\.cgi$!) {
		@ext = ('cgi','pl');
		}
	foreach (@ext) {
		my $file = 'ax-admin.' . $_;
		if (-e $file) {
			$homelink = qq!<p>Click here to return to <a href="$file">$file</a>.</p>\n!;
			last;
			}
		}

	my $cookie = &he($ENV{'HTTP_COOKIE'} || '');
	my $cookie_info = '';
	if ($cookie =~ m!axs_no_log=1!) {
		$cookie_info = "<p>Your visits <em>will NOT be logged</em> because the 'axs_no_log=1' cookie <em>was detected</em>.</p>\n";
		}
	else {
		$cookie_info = "<p>Your visits <em>will be logged</em>, because the 'axs_no_log=1' cookie <em>was NOT detected</em>.</p>\n";
		}

	my $ignore_host_info = '';
	IgnoreHostInfo: {
		if (not @IgnoreHosts) {
			$ignore_host_info .= "<p>The <code>\@IgnoreHosts</code> array is empty. No logging overrides will occur due to IP address or hostname.</p>\n";
			last;
			}

		my ($vhost, $vaddr) = &resolve_host($resolve_dns_names);
		$ignore_host_info .= "<p>The <code>\@IgnoreHosts</code> array contains:<br />\n";
		my $b_ignored = 0;
		foreach (@IgnoreHosts) {
			$ignore_host_info .= "&nbsp;&nbsp;&nbsp;'$_'";
			if ($_) {
				my $qm = quotemeta($_);
				if ($vhost =~ m!$qm!) {
					$ignore_host_info .= " <b>logging disabled for you because $vhost matches</b>\n";
					$b_ignored = 1;
					}
				elsif ($vaddr =~ m!$qm!) {
					$ignore_host_info .= " <b>logging disabled for you because $vaddr matches</b>\n";
					$b_ignored = 1;
					}
				}
			$ignore_host_info .= "<br />\n";
			}
		$ignore_host_info .= "</p>";
		if ($b_ignored) {
			$ignore_host_info .= "<p>Your client address ($vhost/$vaddr) will cause your visits to not be logged.</p>\n";
			}
		else {
			$ignore_host_info .= "<p>Your client address ($vhost/$vaddr) does not match any of these entries. Logging will not be disabled based on <code>\@IgnoreHosts</code> values.</p>\n";
			}
		last;
		}

	my $env_info = '';
	foreach (sort keys %ENV) {
		my ($name, $value) = &he( $_, substr($ENV{$_},0,60) );
		$env_info .= qq!<tr><td class="label">$name:</td><td>$value<br /></td></tr>\n!;
		}

	my $axpath = 'http://' . ( $ENV{'HTTP_HOST'} || $ENV{'SERVER_NAME'} || '' ) . $ENV{'SCRIPT_NAME'};

print <<"EOM";
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>Debug Page and Usage Instructions</title>
	<meta name="robots" content="none" />
	<style type="text/css">
	<!--
	body,div,p,table,tr,td,span {
		font-family:verdana,sans-serif;
		font-size:small;
		}
	.highlight {
		padding:10px;
		border:2px solid #cc0000;
		}
	.product_header {
		font-size:medium;
		font-weight:bold;
		}
	.copyright_footer {
		font-size:smaller;
		text-align:center;
		}
	tt,pre,code {
		font-family:monospace;
		font-size:small;
		}
	.indent {
		margin-left:40px;
		margin-right:40px;
		}
	td.label {
		text-align:right;
		font-weight:bold;
		}
	//-->
	</style>
</head>
<body>

$homelink

<p>Review the <a href="http://www.xav.com/scripts/axs/help/">AXS help file</a> if you need more help.</p>

<p><b>Filesystem Test:</b></p>

<div class="indent">

	$filesys_test

</div>

<p><b>Usage Instructions:</b></p>

<div class="indent">

	<ol>

		<li>

			<p>Add this "AXS tracking code" to any HTML pages that you want to have tracked.  This text should be placed within the <code>&lt;body&gt;</code> section of the document, towards the bottom of the page.  You can place the text almost anywhere, so feel free to move it around if it causes problems with your layout:</p>

<form method="get" action=""><textarea rows="10" cols="85">&lt;script type="text/javascript"&gt;
&lt;!--
\tdocument.write('&lt;img src="$ENV{'SCRIPT_NAME'}?mode=img&amp;ref=');
\tdocument.write( escape( document.referrer ) );
\tdocument.write('" height="1" width="1" style="display:none" alt="" /&gt;');
// -->
&lt;/script&gt;&lt;noscript&gt;
\t&lt;img src="$ENV{'SCRIPT_NAME'}?mode=img" height="1" width="1" style="display:none" alt="" /&gt;
&lt;/noscript&gt;</textarea></form>

			<p>Note that this text only works on normal HTML pages, not in frameset documents.</p>

		</li>

		<li>

			<p>After entering that HTML code on your pages, transfer the pages up to the server.  Then clear your browser cache and visit the pages.  Use your browser's "view-source" command to look at the HTML source code.  Confirm that the above Javascript appears in your pages *exactly* as it appears above.  Make sure that the line breaks appear in the right places.</p>

			<p>This is important because some HTML editor programs will corrupt the text that you try to insert into your pages.  You are responsible for entering the Javascript logging code correctly and for verifying that it appears correctly.  If you do not do this, then the product will not work.</p>

		</li>

		<li>

			<p>Code your <em>off-site</em> links (links to pages/files that don't already contain the AXS tracking code) like this:</p>

			<pre>&lt;a href="$ENV{'SCRIPT_NAME'}?http://yahoo.com/"&gt;http://yahoo.com/&lt;/a&gt;</pre>

			<p>Here is an <a href="$ENV{'SCRIPT_NAME'}?http://www.yahoo.com/" target="_blank">example link</a>.</p>

		</li>

	</ol>

	<p>If any of your HTML pages reside on a different website than AXS, then you should use:</p>

		<pre class="indent">$axpath</pre>

	<p>instead of:</p>

		<pre class="indent">$ENV{'SCRIPT_NAME'}</pre>

	<p>in the examples above.</p>

</div>

<p><b>Standard Debugging Information:</b></p>

<div class="indent">

	<p>This is AXS Logging Module version $VERSION in debug mode.<br />
	The file name of this script is <tt>$0</tt>.<br />
	This script is executing under Perl version $].<br />
	The critical file system variable is <tt>\$LogFile = "$LogFile";</tt>.<br />
	<tt>\$MaxLogSize = $MaxLogSize;</tt> (bytes)</p>

</div>

<p><b>Webmaster Logging Override</b></p>

<div class="indent">

	<p>You can disable the logging of your own visits by having the "axs_no_log=1" cookie, or by having your IP address or hostname present in the <code>\@IgnoreHosts</code> array.</p>


	<p>See <a href="http://www.xav.com/scripts/axs/help/1506.html" target="_blank">this help file</a> for more information about not tracking your own visits.</p>

	<p><b>Cookie Override</b></p>

	<p>Your browser sent the following cookie header:</p><pre>HTTP_COOKIE: $cookie</pre>

	$cookie_info

	<p><b>IP or Hostname Override</b></p>

	$ignore_host_info

</div>

<p><b>Environment Variables:</b></p>

<table border="1" cellpadding="4" cellspacing="0" class="indent">
$env_info
</table>

<p><br /></p>

<div class="copyright_footer">
	The <a href="http://www.xav.com/scripts/axs/">AXS Visitor Tracking System</a> v$VERSION is &copy; 1997-2004 Fluid Dynamics Software
</div>

</body>
</html>

EOM

	}



# Trim - thanks to William Boudreau for & fix

sub Trim {
	local $_ = $_[0] ? $_[0] : '';
	s!^[\r\n\s]+!!o;
	s![\r\n\s]+$!!o;
	return $_;
	}



#changed 0033 -- no longer mapping // => / within the query string portion of the URL
# fixed Google image search backtracking
sub clean_path {
	my $path = &Trim($_[0]);

	# strip pound signs and all that follows (links internal to a page)
	$path =~ s!\#.*$!!;

	my ($base, $question, $query) = ($path, '', '');

	if ($path =~ m!^(.*?)(\?)(.*)$!s) {
		($base, $question, $query) = ($1, $2, $3);
		}

	local $_ = $base;

	# map /%7E to /~ (common source of duplicate URL's)
	s!\/\%7E!\/\~!ig;

	# map "/./" to "/"
	s!/+\./+!/!g;

	# map trailing "/." to "/"
	s!/+\.$!/!g;


	# nuke all leading "/../" entries (meaningless for us)
	# map /../foo => /foo
	while (s!^/+\.\./+!/!) {}


	# map "folder/../" => "/"
	# map "bar/folder/../" => "bar//"
	while (s!([^/]+)/+\.\./+!/!) {}


	# map "/folder/.." => "/"
	s!/+([^/]+)/+\.\.$!/!;



	# collapse back-to-back slashes in the path
	s!/+!/!g;

	return $_ . $question . $query;
	}








sub parse_url {
	local $_ = $_[0] || '';
	my ($clean_url, $host, $port, $path, $is_valid) = ('', '', 80, '/', 0);

	# add trailing slash if none present
	$_ .= '/' if (m!^http://([^/]+)$!i);

	if (m!^http://([\w|\.|\-]+)\:?(\d*)/(.*)$!i) {
		($host, $port, $path, $is_valid) = (lc($1), $2, &clean_path("/$3"), 1);
		$port = 80 unless $port;
		if ($port == 80) {
			$clean_url = "http://$host$path";
			}
		else {
			$clean_url = "http://$host:$port$path";
			}
		}
	return ($clean_url, $host, $port, $path, $is_valid);
	}




=item WebFormL

Usage:
	&WebFormL( \%FORM );

Returns a by-reference hash of all name-value pairs submitted to the CGI script.

updated: 8/21/2001

Dependencies:
	&url_decode
	&query_env

=cut

sub WebFormL {
	my ($p_hash) = @_;
	my @Pairs = ();
	if (&query_env('QUERY_STRING')) {
		@Pairs = split(m!\&!, &query_env('QUERY_STRING'));
		}
	else {
		@Pairs = @ARGV;
		}
	local $_;
	foreach (@Pairs) {
		next unless (m!^(.*?)=(.*)$!s);
		my ($name, $value) = (&url_decode($1), &url_decode($2));
		if ($$p_hash{$name}) {
			$$p_hash{$name} .= ",$value";
			}
		else {
			$$p_hash{$name} = $value;
			}
		}
	}


sub url_decode {
	local $_ = defined($_[0]) ? $_[0] : '';
	tr!+! !;
	s!\%([a-fA-F0-9][a-fA-F0-9])!pack('C', hex($1))!eg;
	return $_;
	}

=item query_env

Usage:
	my $remote_host = &query_env('REMOTE_HOST');

Abstraction layer for the %ENV hash.  Why abstract?  Here's why:
 1. adds safety for -T taint checks
 2. always returns '' if undef; prevent -w warnings

=cut

sub query_env {
	my ($name,$default) = @_;
	if (($ENV{$name}) and ($ENV{$name} =~ m!^(.*)$!s)) {
		return $1;
		}
	elsif (defined($default)) {
		return $default;
		}
	else {
		return '';
		}
	}



=item resolve_host

Usage:
	my ($host,$addr) = &resolve_host($resolve_dns_names);

Returns either the FQDN and IP address of the visitor, based on the variables $ENV{'REMOTE_HOST'}, $ENV{'REMOTE_ADDR'}, and $resolve_dns_names.

=cut

sub resolve_host {
	my ($resolve_dns_names) = @_;

	# This code converts un-resolved hostnames to their text versions, then makes
	# the names lowercase, and then aborts logging if this hostname is forbidden:

	my ($host, $addr) = (&query_env('REMOTE_HOST'), &query_env('REMOTE_ADDR'));
	if (($host eq '') or ($host =~ m!^\d+\.\d+\.\d+\.\d+$!)) {
		if (($resolve_dns_names) and ($addr =~ m!^(\d+)\.(\d+)\.(\d+)\.(\d+)$!)) {
			$host = (gethostbyaddr(pack('C4',$1,$2,$3,$4),2))[0];
			}
		}
	$host = lc($host) || $addr;
	return ($host,$addr);
	}




sub log_visit {
	my ($host,$addr,$ref,$to) = @_;
	my $logline = '|';
	foreach ($host,$addr,$ref,$to,&query_env('HTTP_USER_AGENT')) {
		# strip delimiters:
		s!\||\015|\012!!sg;
		$logline .= $_.'|';
		}
	foreach ((localtime(time + (3600*$TimeOffsetInHours)))[0..7]) {
		$logline .= $_.'|';
		}
	$logline .= 'export|' if ($Export);
	$logline .= "\n";
	# Make sure the record is strictly valid before writing to the log:
	exit unless ($logline =~ m!^\|([^\|]+)\|([^\|]+)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|(export\|)?$!);
	if (open(LOG,">>$LogFile")) {
		binmode(LOG);
		print LOG $logline;
		close(LOG);
		}
	}

sub he {
	my @out = @_;
	local $_;
	foreach (@out) {
		$_ = '' if (not defined($_));
		s!\&!\&amp;!g;
		s!\>!\&gt;!g;
		s!\<!\&lt;!g;
		s!\"!\&quot;!g;
		}
	if ((wantarray) or ($#out > 0)) {
		return @out;
		}
	else {
		return $out[0];
		}
	}

1;

