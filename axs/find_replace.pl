#!/usr/bin/perl -w
require 5;
use strict;
my $VERSION = '2.3.0.0041';

my $SECURITY_ENABLE = 0; # set to 1 to enable

my $axs_path = '/axs/ax.pl';

print "Content-Type: text/html\n\n";
print <<"EOM";
<meta name="robots" content="none" />

<table border="1" cellpadding="8" cellspacing="0"><tr><td><pre>

This script is an **experimental** multi-file find-and-replace tool.  It
can be used to quickly add AXS tags to hundreds or thousands of files.

To use it, place this CGI script in the webroot of a server with the HTML
files you want.  This script will look at any file with a ".htm" or
".html" file extension.  It will try to add the AXS javascript code to the
bottom of any file that doesn't already have it, and it will add the AXS
redirector to any offsite link.

When run in the default mode, it will just query all files to show you
what it plans to change.  That is the "Review" mode.  When you click the
"Update Files" link, it will go ahead and change the files.

There is always the chance that this script will destroy your entire web
site.  <strong>You should always make backup copies before running this script.</strong>

On some web servers, this script will not work because CGI processes don't
have permission to update files.  For those, you should run this script
from the command line, using an account that does have update privileges.

This script assumes that AXS is installed to: <font color="#cc0000"><b>$axs_path</b></font>
Customize the \$axs_path variable if it is installed elsewhere

&copy; 2004 by Zoltan Milosevic

</pre></td></tr></table>

<p><br /></p>

EOM

unless ($SECURITY_ENABLE) {
	print "<p>You must edit the script and set:</p><p><code>my \$SECURITY_ENABLE = 1;</code></p><p>before using this utility.  Because this script attempts to write to all of your files, you should only enable it temporarily.</p>";
	exit;
	}


my $all_code = <<'END_OF_CODE';

my %const = (
	'SCRIPT_NAME' => &query_env('SCRIPT_NAME'),
	);
my $err = '';
Err: {


print "<P>This script detects which HTML files need the AXS tag.</P>\n";
print "<P><A HREF=\"$const{'SCRIPT_NAME'}?review\">Review</A> - <A HREF=\"$const{'SCRIPT_NAME'}?write\" ONCLICK=\"return confirm('Yes I promise Ive made backups first');\">Update Files (yes I have made backups first)</A></P>\n";

my $thishost = $ENV{'HTTP_HOST'} || '';

if ($thishost) {
	print "<P>This host is '$thishost'. Any links to web sites different from this host will get the AXS redirect logging code.</P>\n";
	}
else {
	print "<P>Error: unable to detect hostname.</P>\n";
	exit;
	}


my $t1 = '</body>';
my $t2 = qq~

<script type="text/javascript">
<!--
	document.write('<img src="$axs_path?trans.gif&ref=');
	document.write(document.referrer);
	document.write('" height="1" width="1" alt="" />');
// -->
</script><noscript>
	<img src="$axs_path?trans.gif" height="1" width="1" alt="" />
</noscript>
</body>

~;

	if ($0 =~ m!^(.+)(\\|/)!) {
		if (chdir($1)) {
			print "<P><B>Success:</B> chdir to '$1'.</P>\n";
			}
		else {
			$err = "unable to chdir to '$1' - $!";
			next Err;
			}
		}

#Uncomment next line to force root folder if needed:
#   $ENV{'DOCUMENT_ROOT'} = '/path/to/root/';

	if ($ENV{'DOCUMENT_ROOT'}) {
		if (chdir($ENV{'DOCUMENT_ROOT'})) {
			print "<P><B>Success:</B> chdir to '$ENV{'DOCUMENT_ROOT'}'.</P>\n";
			}
		else {
			$err = "unable to chdir to '$ENV{'DOCUMENT_ROOT'}' - $!";
			next Err;
			}
		}

	print "<P>Searching for files...</P>\n";
	my @files = &GetFiles('.', '\.htm');
	print "<P>Found about $#files files.</P>\n";
	print "<p>(Is that the wrong number of files?  Make sure this script is in your web root folder.)</p>\n";
	print "<PRE>";

	my $file = ();
	File: foreach $file (@files) {
		next if ($file =~ m!/html/!);
		next if ($file =~ m!/sehtml/!);
		next if ($file =~ m!/axs/!);

		print "Analyzing file '$file'... ";

		my $text = '';
		($err, $text) = &ReadFile($file);
		next Err if ($err);

		if ($text =~ m!\s+<SCRIPT LANGUAGE=\"JavaScript\">.{1,512}$axs_path.{1,512}</body>!s) {
			print "<FONT COLOR=#008800>Already has AXS tag.</FONT>\n";
			}
		else {
			print "<FONT COLOR=#880000>needs AXS tag.</FONT>\n";

			$text =~ s!\s+<SCRIPT LANGUAGE=\"JavaScript\">.{1,512}$axs_path.{1,512}</body>!</body>!s;

			my $nreplace = ($text =~ s!$t1!$t2!sig);
			if ($nreplace) {
				if (&query_env('QUERY_STRING') eq 'write') {
					$err = &WriteFile($file,$text);
					next Err if ($err);
					print "<B>Success: replaced tag</B>\n";
					}
				else {
					print "<B>Need to Update File</B>\n";
					}
				}
			}


		($err, $text) = &ReadFile($file);
		next Err if ($err);

		my $orig = $text;

		my $new = '';
		my $n = 0;
		while ($text =~ m!^(.*?)a href=\"http://([^\"\>\/]+)(.*?)$!si) {
			my ($start, $host, $end) = ($1, $2, $3);
			$new .= $start;
			$new .= "a href=\"";
			if ($host =~ m!$thishost!i) {
				$new .= "http://$host";
				}
			else {
				$new .= "$axs_path?http://$host";
				print "'$file' - HREF $host\n";
				$n++;
				}
			$text = $end;
			}
		$new .= $text;

		if ($new ne $orig) {
			print "<B><FONT COLOR=#880000>Need to replace A HREF links</FONT></B> to route through AXS ($n count)...\n";


			if (&query_env('QUERY_STRING') eq 'write') {
				$err = &WriteFile($file,$new);
				next Err if ($err);
				print "<B>Success: replaced links</B>\n";
				}


			}
		else {
			print "All offsite A HREF links already route through AXS, or no offsite links found.\n";
			}

		print "\n";
		}

	last Err;
	}
continue {
	print "<P><B>Error:</P> $err.</P>\n";
	}





sub GetFiles {
	my ($FolderCount, @Folders, @Files, $Pattern) = (0);
	($Folders[0], $Pattern) = @_;
	# Format with all forward slashes; add a trailing slash to $Directory if
	# it's not present:
	$Folders[0] = &NixPath($Folders[0]);
	$Folders[0] .= '/' unless ($Folders[0] =~ m!/$!);

	while ($FolderCount < (scalar @Folders)) {
		my $Directory = $Folders[$FolderCount];
		$FolderCount++;

		unless (opendir(DIR, $Directory)) {
			print "Warning: could not read from directory $Directory - $!\n";
			next;
			}
		foreach (readdir(DIR)) {
			next if m!^\.\.?$!; # skip current and higher directories.

			my $Path = "$Directory$_";
			if (-d $Path) {
				push(@Folders, "$Path/");
				next;
				}
			push(@Files, $Path) if ((not $Pattern) or (m!$Pattern!i));
			}
		closedir(DIR);
		}
	return @Files;
	}

sub NixPath {
	local $_ = defined($_[0]) ? $_[0] : '';
	s!\\!/!mg;
	return $_;
	}

sub ReadFile {
	my ($file) = @_;
	my $text = '';
	my $err_msg = '';
	Err: {
		local $_;
		unless (open(FILE, "<$file")) {
			$err_msg = "unable to read file '$file' - $!";
			next Err;
			}
		unless (binmode(FILE)) {
			$err_msg = "unable to set binmode on file '$file' - $!";
			next Err;
			}
		while (defined($_ = <FILE>)) {
			$text .= $_;
			}
		close(FILE);
		}
	return ($err_msg, $text);
	}

sub WriteFile {
	my ($file, $text) = @_;
	my $err_msg = '';
	Err: {
		unless (defined($file)) {
			$err_msg = "invalid argument - 'file' parameter not defined";
			next Err;
			}
		unless (defined($text)) {
			$err_msg = "invalid argument - 'text' parameter not defined";
			next Err;
			}
		unless (open(FILE, ">$file")) {
			$err_msg = "unable to write to file '$file' - $!";
			next Err;
			}
		unless (binmode(FILE)) {
			$err_msg = "unable to set binmode on file '$file' - $!";
			next Err;
			}
		print FILE $text;
		close(FILE);
		}
	return $err_msg;
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


END_OF_CODE
eval $all_code;
if ($@) {
	print "<P><B>Perl Execution Error:</B> $@</P>\n";
	}
