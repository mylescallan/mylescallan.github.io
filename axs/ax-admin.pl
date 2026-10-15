#!/usr/bin/perl --
require 5;

=item overview

AXS Script Set, Administration Module
Copyright 1997-2004 by Fluid Dynamics

Please adhere to the copyright notice and conditions of use as described at the URL below.  For latest version and help files, visit:
	http://www.xav.com/scripts/axs/

<h1>If you can see this text from a web browser, then there is a problem. <a
href="http://www.xav.com/scripts/axs/help/1089.html">Get help here.</a></h1><xmp>

=cut

my %FORM = ();
my $VERSION = '2.3.0.0041';
my $PRODUCT = 'AXS Visitor Tracking System';
%::private = ();
$::private{'PRINT_HTTP_STATUS_HEADER'} = 0;
my $all_code = ("\n" x 22) . <<'END_OF_CODE';

# You should place the log.txt and axs.dat files in the same directory as
# this script.  If you do, you won't have to change the variables below.
# If you want to put the files somewhere else, enter the full path to these
# files:

my $LogFile = 'log.txt';
my $prefs = 'axs.dat';

#	Other examples:
#	$LogFile = '/usr/www/users/xav/log.txt';
#	$LogFile = 'c:/axs/log.txt';



# Enter your anchor page. This will form a link at the top of each AXS
# output document:

my $link_url = '/';
my $link_title = 'My Home Page';

# Once the script is working to your satisfaction, set the $AllowDebug
# variable to zero:

my $AllowDebug = 1;

# ________________________________________________________________________

# Protect AXS with a username and password.  Both are case sensitive.  You
# can leave them blank to disable password locking.  This is the default:

my $Username = '';
my $Password = '';

#	Other examples:
#	$Username = 'root';
#	$Password = 'IronMAN';

# NOTE: once you set these values, you MUST use the "Log Out" link on the
# ax-admin page. You will then be prompted for user/pass when you visit
# again. You must use the "Log Out" link at the end of each session.

# ________________________________________________________________________

# You can allow anyone access to your graphs, while continuing to protect
# your "Customize" page with a username and password.  If you do this,
# web visitors will be free to view your statistics, but they won't be
# able to delete the log file or change your settings.  To allow web
# visitors to see your graphs without entering a username or password, set
# this to 1:

my $AllowAnonymousForGraphs = 0; # set to 1 to allow

# ________________________________________________________________________

# Most of you shouldn't have to change anything below this line.  If you
# try the script out and it doesn't work, the help files will suggest
# changes to the following lines.

# The request method can be either GET or POST.  Setting the method to GET
# will cause the username and password data to be exposed to the web server
# logs.  Using GET is inadvisable if others have access to your web server
# logs.
my $Request_Method = 'get';

# The URL to this script:
my $This_Script_Address = &query_env('SCRIPT_NAME');

# Your favorite network lookup services:
my $nslookup = 'http://www.xav.com/cgi-bin/nslookup.cgi';
my $whois = 'http://www.xav.com/scripts/axs/whois.pl?a=';

# Alternate (previous) whois script was:
# $whois = 'http://www.networksolutions.com/cgi-bin/whois/whois?';

# AXS can collapse web addresses which include the default document.
# This prevents you from having two database entries for a single file,
# like http://www.ms.com/ and http://www.ms.com/index.html:

my $DefaultDoc = 'index.html';

# If you'd like, local files can show up as their HTML title instead of
# their URL.  For example, visits to http://www.xav.com/ would show up in
# your graphs as "Home Page".  To use this option, enter the URL-title
# pairs below, and set the top variable to "1":

my $UseLocalAddressTitlePairs = 0; # Set to "1" to enable.
my %LocalAddressTitlePairs = (
	'http://www.xav.com/' , 'Home Page',
	'http://www.xav.com/scripts/' , 'Scripts Page',
	'http://www.xav.com/scripts/axs/' , 'AXS Script Page',
	);

# No further editing is necessary, but feel free to play around.  The
# first 1,000 lines of this script are straight HTML and JavaScript, so
# you can safely customize the look and feel of the output even if you
# don't know Perl.
#
# ________________________________________________________________________

my %const = (
	'graph_made' => 0,
	'total_hits' => 0,
	'total_corrupt_rows' => 0,
	'filter_str' => '',
	'start_str' => '',
	'end_str' => '',
	'start_number' => 0,
	'use_numeric_sort' => 1,
	);
my (%PREF, @LINES) = ();
my %GraphOptions = (
	's01' => 'Web Browser (Netscape 3.01 Gold)',
	's02' => 'Abbreviated Browser (Netscape 3.X)',

	's02a' => 'Browser Wars (Netscape)',

	's03' => 'Operating System (Windows 98)',
	's04' => 'Visitor Top-level Domain (.com)',
	's05' => 'Visitor Second-level Domain (.xav.com)',
	's06' => 'Visitor Full (dialup-123.xav.com)',
	's07' => 'Visitor IP Address (206.134.243.3)',
	's08' => 'Hits from Other Sites (Full URL)',
	's09' => 'Hits from Other Sites (Domain Only)',
	's10' => 'Hyperlinks Followed From This Site',
	's11' => 'Hits to Local Documents',
	's12' => 'Average Number of Hits Per Visitor',
	's13' => 'Hits by Day of Year',
	's14' => 'Hits by Day of the Week',
	's15' => 'Hits by Hour of the Day',
	's16' => 'Hits by Month',
	);

my @DatabaseOptions = ('Sort All by Time','Sort All by Visitor','Visitor Flow Only');

my @LongWeekDays = ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
my @ShortWeekDays = ('SUN','MON','TUE','WED','THU','FRI','SAT');
my @LongMonths = ('January','February','March','April','May','June','July','August','September','October','November','December');
my @ShortMonths = ('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');
my @ShortDayNames = ('YEST','TOD','TOM');
my @MyT = localtime;

my $copyright = <<"EOM";

	<div class="copyright_footer">
		The <a href="http://www.xav.com/scripts/axs/">$PRODUCT</a> v$VERSION is &copy; 1997-2004 Fluid Dynamics Software
	</div>

EOM


my %tldx = ();
my %sldx = ();
my %statesx = ();

# forces leading zero's, two digit.  Used for date, times
sub Pad {
	local $_ = $_[0];
	if (length($_) == 1) {
		$_ = '0' . $_;
		}
	return $_;
	}


sub Header {
return <<"END_OF_HTML";
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<title>$PRODUCT - Administrator's Page</title>
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
	.mgerr {
		color:#000000;
		background-color:#eeeeee;
		padding:10px;
		border:2px solid #cc0000;
		}
	//-->
	</style>
</head>
<body>

END_OF_HTML

	}


# only show the "log out" link if username/password enabled

sub get_logout_opt {
	if (($Username) or ($Password)) {
		return qq! - <a href="$This_Script_Address?Target=LogOut">Log Out</a>!;
		}
	return '';
	}



sub HTML_Header {
	my $frag = &get_logout_opt();
	return <<"EOM";

<p style="text-align:center">

	<span class="product_header">$PRODUCT<br /></span>

	[ - <a href="$This_Script_Address">Main Menu</a>
	  - <a href="$This_Script_Address?Target=Preferences">Customize</a>
	$frag
	  - Back to <a href="$link_url">$link_title</a> - ]

</p>

EOM

	}


sub Footer {
	my ($b_is_login) = @_;
	my $frag = &get_logout_opt();

	if ($b_is_login) {

print <<"EOM";

<div style="text-align:center"><p>

	<a href="$This_Script_Address">Main Menu</a>
	- <a href="$This_Script_Address?Target=Preferences">Customize</a>
	$frag
EOM

		if ((($Username) or ($Password)) and ($PREF{'AuthIP'})) {
			print qq!<br /><small>IP address $PREF{'AuthIP'} is logged in</small>!;
			}
		print '</p></div>';
		}
	print <<"EOM";

$copyright

</body>
</html>

EOM
	}



sub PrintMainPage {
	local $_;
	my $cur_hits = 0;
	my $first_date = '';
	if (open(LOG, "<$LogFile")) {
		binmode(LOG);
		if (defined($_ = <LOG>)) {
			$cur_hits++;
			my @fields = split(m!\|!);
			$first_date = (1900 + $fields[11]) . '-' . &Pad($fields[10] + 1) . '-' . &Pad($fields[9]);
			}
		while (defined($_ = <LOG>)) {
			$cur_hits++;
			}
		close(LOG);
		}

	my $warn_env = '';

	if ((exists $ENV{'DOCUMENT_URI'}) and ($PREF{'show_uri_warning'})) {

$warn_env = <<"EOM";

		<div class="highlight">

		<p><b>Warning:</b> this web server is setting the DOCUMENT_URI environment variable for normal CGI requests.  This will cause problems for the logging script.  You can avoid this problem by editing the "ax.pl" file and setting:</p>

		<div class="indent">
			<pre>my \$use_ssi_detect = 0;</pre>
		</div>

		<p>For more information, read <a href="http://www.xav.com/scripts/axs/help/1019.html" target="_blank">this help file</a>.</p>

		<p>Once the source code has been updated, this warning will <em>not</em> automatically disappear.  You must go to the <b>Warnings Display</b> section of the Customize page to disable it.</p>

		</div>

		<p><br /></p>

EOM

		}

	my $first_time_instruct = '';
	my $always_instruct = '';

	foreach ('pl','cgi') {
		next unless (-e "ax.$_");
		$first_time_instruct = qq!

		<div class="highlight">

		<p>Before this script can log visits to this site, you will need to add tracking codes to your HTML pages.</p>

		<p>See <a href="ax.$_?debugme">Instructions for Tagging HTML Pages</a> for the exact HTML codes to add.</p>

		<p>This table will disappear once logging begins. A copy of the Instructions link will remain at the bottom of this page.</p>

		</div>

		<p><br /></p>

		!;

		$first_time_instruct = '' if ($cur_hits > 0);

		$always_instruct = qq!

		<p>See <a href="ax.$_?debugme">Instructions for Tagging HTML Pages</a> for information on tagging your HTML pages.</p>

		!;

		last;
		}

	my $SetAll = '';
	my $SetDef = '';
	my $graph_options = '';
	my $OptionCode;
	foreach $OptionCode (sort keys %GraphOptions) {

$SetAll .= qq!document.graphs.$OptionCode.checked = value;\n!;
my $val = ($PREF{$OptionCode}) ? 'true' : 'false';
$SetDef .= qq!document.graphs.$OptionCode.checked = $val;\n!;


$graph_options .= <<"EOM";

	<input type="checkbox" name="$OptionCode" id="x$OptionCode" value="CHECKED" /><label for="x$OptionCode">$GraphOptions{$OptionCode}</label><br />

EOM

		}

	my $mg_err = qq!!;
	my $mg_highlight = qq!!;

	if ($FORM{'MakeGraphs'}) {
		# the user clicked the "make graphs" button but didn't select a graph
		$mg_err = qq!<p class="mgerr"><b>Error:</b> no graphs selected.  You must check the graphs you would like to display.</p>!;
		$mg_highlight = qq! class="mgerr"!;
		}



print &SetDefaults(<<"EOM",\%PREF);

<form method="$Request_Method" action="$This_Script_Address" name="graphs" onsubmit="return CheckGraphs()">

<div class="indent">

	$first_time_instruct

	$warn_env

	<p>This system records visits to your site.  This admin script allows you to display these records in meaningful graph and database formats.  There are currently <b>$cur_hits</b> hits recorded (log started $first_date).</p>

	<div class="indent">
		<input name="maximum" size="4" />
		<select name="format">
			<option value="Sort All by Time">Sort All by Time</option>
			<option value="Sort All by Visitor">Sort All by Visitor</option>
			<option value="Visitor Flow Only">Visitor Flow Only</option>
		</select>
		<input type="submit" name="show_data" value="View in Database Format" />
	</div>

	<p>Enter the number of recent hits you'd like to view, or leave blank for all. Enter "L" to view hits since your last visit on $PREF{'last_string'}.</p>

	<p><b>Create Graphs Based On:</b></p>

	$mg_err

	<table border="0" cellspacing="0" cellpadding="0" class="indent">
	<tr>
		<td valign="top"$mg_highlight>
			$graph_options
			<script type="text/javascript">
			<!--
			function SetDef() {
				if ((document) && (document.graphs)) {
$SetDef
					}
				}
			function SetAll(value) {
				if ((document) && (document.graphs)) {
$SetAll
					}
				}
			document.write( ' [ <a href="javascript:SetAll(true);">check all</a> ' );
			document.write( ' | <a href="javascript:SetDef();">defaults</a> ' );
			document.write( ' | <a href="javascript:SetAll(false);">clear all</a> ] ' );
			//-->
			</script>
		</td>
		<td width="40"><br /></td>
		<td align="center" valign="middle">
			<input type="checkbox" name="csv_out" value="1" id="csv_out" /><label for="csv_out"> Output in CSV Format</label><br />
			<input type="submit" value="View in Graphical Format" name="MakeGraphs" onclick="JavaMakeGraphs()" /><br />
			<img src="$PREF{'images_folder'}tracker.jpg" alt="logo" height="205" width="198" />
		</td>
	</tr>
	</table>

	<p><b>Filters:</b></p>

	<div class="indent">

		<p>By default, all hits in the database will be graphed.  Use these filters to restrict graphs to recent hits, critical files, or both.</p>

		<p>
		&nbsp; &nbsp;

		<input type="checkbox" value="CHECKED" name="since_last" id="since_last" onclick="FormatTimesSinceLast('$PREF{'last_string'}');" />
		<label for="since_last">Graph only hits since my last visit on $PREF{'last_string'}</label>
		<br />

			&nbsp; &nbsp;

		<input type="checkbox" value="CHECKED" name="recent" id="recent" onclick="FormatTimesRecent();" />
		<label for="recent">Graph only hits from yesterday and today</label>, or specify:

		</p>

		<table border="0">
		<tr>
			<td class="label">Start Date:</td>
			<td><input name="start_date" size="10" onblur="FormatStartTime(document.graphs.start_date.value)" /></td>
			<td><i>(<span id="StartTime">mm-dd-year</span>)</i></td>
		</tr>
		<tr>
			<td class="label">End Date:</td>
			<td><input name="end_date" size="10" onblur="FormatEndTime(document.graphs.end_date.value)" /></td>
			<td><i>(<span id="EndTime">mm-dd-year</span>)</i></td>
		</tr>
		<tr>
			<td class="label">Filter String:</td>
			<td colspan="2"><input name="Filter" size="24" /></td>
		</tr>
		</table>

		<p>The filter string may contain a file name, server name, or browser type.  If this field is used, only log entries which pattern match to this string will be analyzed.</p>

	</div>

$always_instruct

</div>
</form>

EOM

	}
# ________________________________________________________________________


sub PrintCustomizePage {

	# show preferences:
	my $LogSizeKiloBytes = int((-s $LogFile) / 1000);
	my $Advice = '';

	if ($LogSizeKiloBytes < 500) {
		$Advice = 'that is not too bad';
		}
	elsif ($LogSizeKiloBytes < 1000) {
		$Advice = 'it is starting to get up there';
		}
	else {
		$Advice = 'you may want to delete it';
		}
	$LogSizeKiloBytes = &AddCommas($LogSizeKiloBytes);

	my $graph_options = '';

	my $OptionCode;
	foreach $OptionCode (sort keys %GraphOptions) {
		$graph_options .= <<"EOM";

	<input type="checkbox" name="$OptionCode" value="CHECKED" id="x$OptionCode" /><label for="x$OptionCode">$GraphOptions{$OptionCode}</label><br />

EOM
		}

	my $webmaster_logging = '';

	if (($ENV{'HTTP_COOKIE'}) and ($ENV{'HTTP_COOKIE'} =~ m!axs_no_log=1!i)) {

$webmaster_logging = <<"EOM";

	<p>Currently, your visits <b>ARE NOT</b> being logged.  This is the recommended state.</p>


EOM

		}
	else {

$webmaster_logging = <<"EOM";

	<p>Currently, you do not have an "axs_no_log" cookie. Your visits probably <b>are</b> being logged.</p>

EOM
		}


print &SetDefaults(<<"EOM", \%PREF);

<blockquote>

<form method="$Request_Method" action="$This_Script_Address" name="graphs">
<input type="hidden" name="Target" value="Preferences" />

<p>Enter your most common settings below.  The main page will display those settings automatically.</p>

<p><b>Database Format Settings</b></p>

<blockquote>

	<input name="maximum" size="4" />
	<select name="format">
		<option value="Sort All by Time">Sort All by Time</option>
		<option value="Sort All by Visitor">Sort All by Visitor</option>
		<option value="Visitor Flow Only">Visitor Flow Only</option>
	</select>

</blockquote>

<p>The text box holds the number of recent hits you're interested in. You can enter a letter to view recent hits through the day of your last visit.</p>

<p><b>Listings per Page:</b> <input name="ListingsPerPage" size="5" maxlength="5" /></p>

<p>The maximum number of listings to show on a single page in the database output. Use "0" for no limit.</p>


<p><b>Most Common Graphs:</b></p>

<blockquote>$graph_options</blockquote>

<p><b>Filters:</b></p>

<div class="indent">

	<p>By default, all hits in the database will be graphed.  Use these filters to restrict graphs to recent hits, critical files, or both.</p>

	<p>
	&nbsp; &nbsp;

<input type="checkbox" name="since_last" value="CHECKED" id="since_last" onclick="FormatTimesSinceLast('$PREF{'last_string'}');" />
<label for="since_last">Graph only hits since my last visit on $PREF{'last_string'}</label>
<br />

	&nbsp; &nbsp;

<input type="checkbox" name="recent" value="CHECKED" id="recent" onclick="FormatTimesRecent();" />
<label for="recent">Graph only hits from yesterday and today</label>, or specify:

	</p>

	<p>
	<input name="start_date" size="10" onblur="FormatStartTime(document.graphs.start_date.value)" />
		Start Date <i>(<span id="StartTime">mm-dd-year</span>)</i><br />

	<input name="end_date" size="10" onblur="FormatEndTime(document.graphs.end_date.value)" />
		End Date <i>(<span id="EndTime">mm-dd-year</span>)</i><br />

	<input name="Filter" size="24" />
		Filter String</p>

	<p>The filter string may contain a file name, server name, or browser type.  If this field is used, only log entries which pattern match to this string will be analyzed.</p>

</div>

<p><b>Graphics Output:</b></p>

<table border="0" cellspacing="0" cellpadding="2" class="indent">

<tr>
	<td align="center"><input type="checkbox" name="NumSort" value="CHECKED" id="NumSort" /></td>
	<td colspan="2"><label for="NumSort">Sort data numerically, with most hits on top</label></td>
</tr>
<tr>
	<td><br /></td>
	<td><br /></td>
	<td><i>By default, graphs are alphabetically sorted by key</i></td>
</tr>

<tr>
	<td align="center"><input type="checkbox" name="NewWindow" value="CHECKED" id="NewWindow" /></td>
	<td colspan="2"><label for="NewWindow">Follow links by opening a separate window</label></td>
</tr>

<tr>
	<td align="center"><input type="checkbox" name="Highlight" value="CHECKED" id="Highlight" /></td>
	<td colspan="2"><label for="Highlight">Highlight the percentage column in graphs</label></td>
</tr>

<tr>
	<td align="center"><input type="checkbox" name="HideQueryStrings" value="CHECKED" id="HideQueryStrings" /></td>
	<td colspan="2"><label for="HideQueryStrings">Compress web addresses that include query strings</label></td>
</tr>
<tr>
	<td><br /></td>
	<td><br /></td>
	<td>http://www.xav.com/links.cgi?foo=bar <i>becomes</i><br />http://www.xav.com/links.cgi</td>
</tr>


<tr>
	<td align="center"><input type="checkbox" name="HideDefaultDoc" value="CHECKED" id="HideDefaultDoc" /></td>
	<td colspan="2"><label for="HideDefaultDoc">Compress web addresses that include the default document, <tt>$DefaultDoc</tt></label></td>
</tr>
<tr>
	<td><br /></td>
	<td><br /></td>
	<td>http://www.xav.com/$DefaultDoc <i>becomes</i><br />http://www.xav.com/</td>
</tr>

<tr>
	<td align="center"><input type="checkbox" name="UseMilTime" value="CHECKED" id="UseMilTime" /></td>
	<td colspan="2"><label for="UseMilTime">Use military time</label></td>
</tr>
<tr>
	<td><br /></td>
	<td><br /></td>
	<td>3:45 PM <i>becomes</i> 15:45</td>
</tr>
</table>

<p>Set the maximum width of graphs to <input name="MaxWidth" size="3" style="text-align:right" /> pixels.</p>

<p>Set the maximum displayed characters in data strings to <input name="MaxChars" size="3" style="text-align:right" />.</p>

<p>The URL to the folder containing the "red.gif" and "tracker.jpg" images: <input name="images_folder" size="40" /><br />
You can use http://www.xav.com/images/ if you want. There is no guarantee that the images will always be hosted there, so it is best if you can host the images on your own server.</p>

<p>Local web pages will be any web pages which contain this substring in their URL: <input name="My_Web_Address" /></p>

<p><b>Warnings Display:</b></p>

<p>The "uri_warning" will be activated whenever the DOCUMENT_URI environment variable is populated for CGI requests.  For more information, see <a href="http://www.xav.com/scripts/axs/help/1019.html" target="_blank">this help file</a>.</p>

<table border="0" cellspacing="0" cellpadding="2" class="indent">
<tr>
	<td align="center"><input type="radio" name="show_uri_warning" value="1" id="show_uri_warning_1" /></td>
	<td><label for="show_uri_warning_1">Show warning at the top of the main page.</label></td>
</tr>
<tr>
	<td align="center"><input type="radio" name="show_uri_warning" value="0" id="show_uri_warning_0" /></td>
	<td><label for="show_uri_warning_0">Do not show warning.</label></td>
</tr>
</table>


<div class="indent">
	<input type="hidden" name="incoming" value="true" />
	<p><input type="submit" value="Commit Changes" /></p>
</div>

</form>

<p><br /></p>

<p><b>Webmaster Logging</b></p>

<blockquote>

	$webmaster_logging

	<blockquote>

		<p>To log your own visits, click on <b><a href="$This_Script_Address?Action=nh_setcookie&amp;CookieValue=0">Log My Visits</a></b></p>

		<p>To not log your own visits, click <b><a href="$This_Script_Address?Action=nh_setcookie&amp;CookieValue=1">Do Not Log My Visits</a></b></p>

	</blockquote>

	<p>This feature requires that you have cookies enabled.  Selecting <b>Do Not Log My Visits</b> will set a cookie to your browser that tells the ax.pl script to not log your visits.  You will need to do this for each browser you use, and you will need to repeat this process every time you delete cookies.</p>

	<p>See <a href="http://www.xav.com/scripts/axs/help/1506.html" target="_blank">this help file</a> for more information about not tracking your own visits, including alternative techniques.</p>

</blockquote>

<p><br /></p>

<form method="post" action="$This_Script_Address" name="Deletion" onsubmit="return ConfirmDelete()">
<input type="hidden" name="terminate" value="On" />

<p><b>Log Management:</b></p>

<blockquote>
	<p><input type="submit" value="Delete Access Log" /></p>
</blockquote>

<p>By default, all entries will be deleted. You may choose to delete <i>only</i> hits <i>older</i> than a certain date:&nbsp; <input name="start_date" size="10" onblur="FormatDeleteTime(document.Deletion.start_date.value)" /> <i>(<span id="DeleteTime">mm-dd-year</font>)</i></p>

<p>The access log will grow by about a kilobyte for every six hits, eventually becoming too large for processing (it's currently at $LogSizeKiloBytes kb - $Advice). We recommend deleting the log every so often. Before doing so, you'll want to generate your favorite graphs and save them to your system as HTML files, as a record of how your site traffic evolves over time.</p>

</form>

<p><br /></p>

<p><b>Debugging</b></p>

<p>Click here to <a href="$This_Script_Address?debugme">view debugging information</a>.  The debug output includes system information, a file system permissions test, and a list of environment variables.</p>

<p><br /></p>

</blockquote>
<br /><br />

EOM
	}





sub Authenticate {
	my $Target = ($FORM{'Target'} eq 'Preferences') ? 'Preferences' : '';

return <<"END_OF_HTML";

<div style="text-align:center">
<table border="0" style="width:600px"><tr><td align="left">

<p><br /></p>

<p>Please enter your username and password to sign in.</p>

<form action="$This_Script_Address" method="post" name="f1">
<input type="hidden" name="Target" value="$Target" />

<table border="0">
<tr>
	<td class="label">Username:</td>
	<td><input name="username" /></td>
</tr>
<tr>
	<td class="label">Password:</td>
	<td><input type="password" name="password" /></td>
</tr>
<tr>
	<td><br /></td>
	<td><input type="submit" value="Sign In" /></td>
</tr>
</table>

<script type="text/javascript">
<!--
if ((document) && (document.f1) && (document.f1.username)) {
	document.f1.username.focus();
	}
// -->
</script>

<p>Refer to <a href="http://www.xav.com/scripts/axs/help/1000.html">this file</a> for help with usernames and passwords.</p>

<p><br /></p>

</td></tr></table>
</div>

END_OF_HTML
	}


sub DatabaseFlowDescription {
return <<"END_OF_HTML";

<blockquote>
	<p>Below is a flow chart of your visitors.  Visits are shown with newer hits at the top, and older hits towards the bottom, with timestamps taken from the time of first visit.  Successive visits by the same user are grouped together, so that you can view the path taken through your site.</p>

	<p>The time interval between hits is given in Hour:Minute:Second format, followed by the number of days, if any.</p>

	<p>Note that in most cases, the same individual will have different IP addresses with each network logon.  Alternately, the same IP address may represent different visitors over time.  Sampling a smaller number of hits over a shorter time period reduces the probability of these errors occuring.</p>

</blockquote>

END_OF_HTML
}
# ________________________________________________________________________


sub DatabaseTimeDescription {
return <<"END_OF_HTML";

<blockquote>
	<p>Each hit below is listed in the order it was counted, with the most recent hits listed first.</p>
</blockquote>

END_OF_HTML
}
# ________________________________________________________________________




=item GraphSummary

Usage:
	print &GraphSummary( $relevant_hits, $NumGraphLines );

Dependencies:
	$const{'truncated_keys'}

=cut

sub GraphSummary {

	my $display_rel_hits = &AddCommas( $_[0] );

	my $display_num_lines = &AddCommas( $_[1] );

	my $SummaryText = "<p><b>Summary:</b></p><blockquote><p>There were $const{'total_hits'} total hits analyzed";

	if ($const{'total_corrupt_rows'}) {
		$SummaryText .= " ($const{'total_corrupt_rows'} data points were corrupt)";
		}

	$SummaryText .= ".  Of these, $display_rel_hits were ";

	if ($display_num_lines) {
		$SummaryText .= "relevant, and they resulted in $display_num_lines lines in the table. "
		}
	else {
		$SummaryText .= 'relevant. ';
		}

	if (!$const{'filter_str'}) {
		$SummaryText .= "No string matching was done against the access log.  ";
		}
	elsif ($const{'filter_str'} =~ m!^host:(.*)$!i) {
		$SummaryText .= "Searched only hits whose hostname matched \"" . html_encode($1) . "\".  ";
		}
	elsif ($const{'filter_str'} =~ m!^ip:(.*)$!i) {
		$SummaryText .= "Searched only hits whose IP address matched \"" . html_encode($1) . "\".  ";
		}
	elsif ($const{'filter_str'} =~ m!^from:(.*)$!i) {
		$SummaryText .= "Searched only hits whose referers matched \"" . html_encode($1) . "\".  ";
		}
	elsif ($const{'filter_str'} =~ m!^to:(.*)$!i) {
		$SummaryText .= "Searched only hits in which the document hit matched \"" . html_encode($1) . "\".  ";
		}
	elsif ($const{'filter_str'} =~ m!^browser:(.*)$!i) {
		$SummaryText .= "Searched only hits in which the browser name matched \"" . html_encode($1) . "\".  ";
		}
	else {
		$SummaryText .= "Searched only records whose text matched \"" . html_encode($const{'filter_str'}) . "\".  ";
		}

	if (($const{'start_str'}) and ($const{'end_str'})) {
		$SummaryText .= "Restricted to hits occurring between $const{'start_str'}, and $const{'end_str'}.</p>";
		}
	elsif ($const{'start_str'}) {
		$SummaryText .= "Restricted to hits occurring on or after $const{'start_str'}.</p>";
		}
	elsif ($const{'end_str'}) {
		$SummaryText .= "Restricted to hits occurring on or before $const{'end_str'}.</p>";
		}
	else {
		$SummaryText .= "The log was not filtered by date.</p>";
		}


	if ($const{'truncated_keys'}) {
		$SummaryText .= "<p>$const{'truncated_keys'} of the text keys were longer than $PREF{'MaxChars'} characters, and were truncated in the display. This behavior can be controlled with the \"maximum displayed characters\" setting on the Customize page.</p>\n";
		}

$SummaryText .= <<"END_OF_HTML";

	<p>Local web pages are those whose URL contains the substring "$PREF{'My_Web_Address'}".  All other documents are considered remote web pages.</p>

</blockquote>

END_OF_HTML

	return $SummaryText;
	}


sub JavaLib {
return <<'END_OF_HTML';
<script type="text/javascript">
<!--//
window.onerror = null;
var version = parseInt(navigator.appVersion);
var isIE = navigator.appVersion.indexOf("MSIE")>0;
var isNav = navigator.appVersion.indexOf("Nav")>0;
var isIE4 = isIE && version>=4;
var isNav4 = isNav && version>=4;
function StripWhiteSpace (DS) {
	while (DS.length && (DS.charAt(0) == ' ')) {
		DS = DS.substring(1,DS.length);
		}
	return DS;
	}
function AddLeadingZero (Number) {
	Number *= 1;
	if (Number < 10) {
		Number = " 0" + Number;
		Number = Number.substr(1,3);
		}
	return Number;
	}

function DateFromString(DS) {
	MonthNames = new Array("January","February","March","April",'May','June','July','August','September','October','November','December');
	CompMonthNames = new Array('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');
	WeekDays = new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
	CompWeekDays = new Array('SUN','MON','TUE','WED','THU','FRI','SAT');
	DateSuffix = new Array('th','st','nd','rd','th','th','th','th','th','th','th','th','th','th','th','th','th','th','th','th');
	var AllInt = '0123456789';
	AllCaps = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	AllLows = 'abcdefghijklmnopqrstuvwxyz';

DS = StripWhiteSpace(DS);

/* test for numeric status of first non-whitespace: */
var N1 = -1;
var MonthFirst = 1;
var TempAlphaString = '';

if ((DS.length) && (AllInt.indexOf(DS.charAt(0)) < 0)) {

	/* non-numeric: */
	/* capture all non-numerics up til first numeric, non-inclusive: */
	var TempAlphaString = '';
	while (DS.length && ((AllInt.indexOf(DS.charAt(0)) < 0) || (DS.charAt(0) == ' '))) {
		OffSet = AllLows.indexOf(DS.charAt(0));
		if (OffSet > -1) {
			TempAlphaString += AllCaps.substring(OffSet,OffSet+1);
			}
		else {
			TempAlphaString += DS.charAt(0);
			}
		DS = DS.substring(1,DS.length);
		}
	for (var i=0;i<12;i++) {
		if (TempAlphaString.indexOf(CompMonthNames[i]) >= 0) {
			N1 = i + 1;
			i = 12;
			}
		}
	}

if ((DS.length) && (N1 == -1)) {
	/* numeric first character.  Capture first 1 or 2 numerics */
	/* 1 if 2nd is non-numeric */
	N1 = parseInt(DS.charAt(0),10);
	DS = DS.substring(1,DS.length);
	if (DS.length && !(AllInt.indexOf(DS.charAt(0)) < 0) && (DS.charAt(0) != ' ')) {
		N1 *= 10;
		N1 += parseInt(DS.charAt(0));
		DS = DS.substring(1,DS.length);
		}
	}

DS = StripWhiteSpace(DS);

/* test for numeric status of first non-whitespace: */
var N2 = -1;
if ((DS.length) && (AllInt.indexOf(DS.charAt(0)) < 0)) {

	/* non-numeric: */
	/* capture all non-numerics up til first numeric, non-inclusive: */
	var TempAlphaString = '';
	while (DS.length && ((AllInt.indexOf(DS.charAt(0)) < 0) || (DS.charAt(0) == ' '))) {
		OffSet = AllLows.indexOf(DS.charAt(0));
		if (OffSet > -1) {
			TempAlphaString += AllCaps.substring(OffSet,OffSet+1);
			}
		else {
			TempAlphaString += DS.charAt(0);
			}
		DS = DS.substring(1,DS.length);
		}
	for (var i=0;i<12;i++) {
		if (TempAlphaString.indexOf(CompMonthNames[i]) >= 0) {
			N2 = i + 1;
			i = 12;
			MonthFirst = 0;
			}
		}
	}

/* continue with num search if text search was aborted or didn't turn */
/* anything up... */
if ((DS.length) && (N2 == -1)) {
	/* numeric first character.  Capture first 1 or 2 numerics */
	/* 1 if 2nd is non-numeric */
	N2 = parseInt(DS.charAt(0),10);
	DS = DS.substring(1,DS.length);
	if (DS.length && (!(AllInt.indexOf(DS.charAt(0)) < 0) && (DS.charAt(0) != ' '))) {
		N2 *= 10;
		N2 += parseInt(DS.charAt(0));
		DS = DS.substring(1,DS.length);
		}
	}

DS = StripWhiteSpace(DS);

/* test for numeric status of first non-whitespace: */
if (DS.length && (AllInt.indexOf(DS.charAt(0)) < 0)) {

	/* non-numeric: */
	/* strip all non-numerics up til first numeric, non-inclusive: */
	var TempAlphaString = '';
	while (DS.length && ((AllInt.indexOf(DS.charAt(0)) < 0) || (DS.charAt(0) == ' '))) {
		TempAlphaString += DS.charAt(0);
		DS = DS.substring(1,DS.length);
		}
	}


var b_use_year = false;

var YearNumber = 0;
while (DS.length && !(AllInt.indexOf(DS.charAt(0)) < 0) && (DS.charAt(0) != ' ')) {
	YearNumber = (YearNumber * 10) + parseInt(DS.charAt(0),10);
	b_use_year = true;
	DS = DS.substring(1,DS.length);
	}
YearNumber *= 1;
ThisDay = new Date();
ThisDayNumber = ThisDay.getDay();
NumDays1970 = (ThisDay.getTime()/(24*3600000));


/* if both N1,N2 fail, see if the guy typed in a weekday: */
if ((N1 == -1) && (N2 == -1)) {
	for (i=0; i<7; i++) {
		if (TempAlphaString.length && (TempAlphaString.indexOf(CompWeekDays[i]) >= 0)) {
			NumDaysPast = ((ThisDayNumber - i + 7) % 7);
			NewNumDays1970 = NumDays1970 - NumDaysPast;
			ThisDay.setTime(24*3600000*NewNumDays1970);
			N1 = ThisDay.getMonth() + 1;
			N2 = ThisDay.getDate();
			Year = ThisDay.getYear() + 1900;
			i = 7;
			}
		}
	}
if ((N1 == -1) && (N2 == -1)) {
	if ((TempAlphaString.length) && (TempAlphaString.indexOf("YEST") >= 0)) {
		NewNumDays1970 = NumDays1970 - 1;
		ThisDay.setTime(24*3600000*NewNumDays1970);
		N1 = ThisDay.getMonth() + 1;
		N2 = ThisDay.getDate();
		Year = ThisDay.getYear() + 1900;
		}
	else if ((TempAlphaString.length) && (TempAlphaString.indexOf("TOD") >= 0)) {
		N1 = ThisDay.getMonth() + 1;
		N2 = ThisDay.getDate();
		Year = ThisDay.getYear() + 1900;
		}
	else if (TempAlphaString.length && (TempAlphaString.indexOf("TOM") >= 0)) {
		NewNumDays1970 = NumDays1970 + 1;
		ThisDay.setTime(24*3600000*NewNumDays1970);
		N1 = ThisDay.getMonth() + 1;
		N2 = ThisDay.getDate();
		Year = ThisDay.getYear() + 1900;
		}
	}

if (!b_use_year) {
	YearNumber = ThisDay.getYear();
	}
if (YearNumber < 1000) {
	if (YearNumber < 50) {
		YearNumber += 2000;
		}
	else {
		YearNumber += 1900;
		}
	}
/* Date Pattern match not found: */
if ((N1 == -1) || (N2 == -1)) {
	return '';
	}
if (MonthFirst) {
	ThisMonthNum = (N1 - 1);
	ThisDay = N2;
	}
else {
	ThisMonthNum = (N2 - 1);
	ThisDay = N1;
	}
/* return 0 for bad configs: */
if (ThisDay < 1) {
	return 0;
	}
if ((ThisMonthNum < 0) || (ThisMonthNum > 11)) {
	return 0;
	}
DaysInMonth = new Array (31,28,31,30,31,30,31,31,30,31,30,31);
DaysInThisMonth = DaysInMonth[ThisMonthNum];
if (ThisDay > DaysInThisMonth) {
	if (!((ThisMonthNum == 1) && ((YearNumber % 4) == 0) && (ThisDay == 29))) {
		return 0;
		}
	}
/* Date is now set in stone (else we've already aborted).  Now format */
/* as needed for this application. */
MyDate = new Date();
MyDate.setYear(YearNumber);
MyDate.setMonth(ThisMonthNum);
MyDate.setDate(ThisDay);
ThisWeekDay = WeekDays[MyDate.getDay()];
ThisMonthName = MonthNames[ThisMonthNum];
return ThisWeekDay + ", the " + ThisDay + DateSuffix[ThisDay%20] + " of "  + ThisMonthName + ", " + YearNumber;
}
function FormatStartTime(DateString) {
DateString = DateFromString(DateString);
if (DateString != "") {
	window.status = DateString;
	if (isIE4) {
		document.all.StartTime.innerHTML = DateString;
		}
	}
return true;
}
function FormatEndTime(DateString) {
DateString = DateFromString(DateString);
if (DateString != "") {
	window.status = DateString;
	if (isIE4) {
		document.all.EndTime.innerHTML = DateString;
		}
	}
return true;
}
function FormatTimesSinceLast(DateString) {
//	document.graphs.since_last.checked = !document.graphs.since_last.checked;
	FormatStartTime(DateString);
	FormatEndTime("Today");
	return true;
	}
function FormatTimesRecent() {
//	document.graphs.recent.checked = !document.graphs.recent.checked;
	FormatStartTime("Yesterday");
	FormatEndTime("Today");
	return true;
	}
var DeleteTime = '';
function FormatDeleteTime(DateString) {
	DateString = DateFromString(DateString);
	if (DateString != "") {
		window.status = DateString;
		if (isIE4) {
			document.all.DeleteTime.innerHTML = DateString;
			}
		DeleteTime = DateString;
		}
	else {
		DeleteTime = '';
		}
	return true;
	}
function ConfirmDelete() {
	var Confirmation;
	if (DeleteTime != '') {
		Confirmation = "Are you sure you want to delete all log entries before " + DeleteTime + "?\nThere is no undo feature, you know.";
		}
	else {
		Confirmation = "Are you sure you want to delete the entire access log?\nThere is no undo feature, you know.";
		}
	if (confirm(Confirmation)) {
		return true;
		}
	else {
		return false;
		}
	}
var GetGraphs = 0;
function JavaMakeGraphs() {
	GetGraphs = 1;
	return true;
	}
function CheckGraphs() {
	if (GetGraphs == 0) {
		return true;
		}
	else if (document.graphs.s01.checked ||
				document.graphs.s02.checked ||
				document.graphs.s02a.checked ||
				document.graphs.s03.checked ||
				document.graphs.s04.checked ||
				document.graphs.s05.checked ||
				document.graphs.s06.checked ||
				document.graphs.s07.checked ||
				document.graphs.s08.checked ||
				document.graphs.s09.checked ||
				document.graphs.s10.checked ||
				document.graphs.s11.checked ||
				document.graphs.s12.checked ||
				document.graphs.s13.checked ||
				document.graphs.s14.checked ||
				document.graphs.s15.checked ||
				document.graphs.s16.checked) {
		return true;
		}
	else {
		Confirmation  = "You must choose something to graph.\n\nYour options are listed on the ";
		Confirmation += "left (from type of \"Web Browser\" through \"Hits by Hour of Day\").";
		Confirmation += "  You can select them by clicking your mouse on the checkbox next to each ";
		Confirmation += "item.\n\nWould you like me to choose a graph for you?";

		if (confirm(Confirmation)) {
			document.graphs.s02.checked = true;
			}
		return false;
		}
	}
//-->
</script>

END_OF_HTML
} #-----------------------------------------------------------------------


=item axs_init

Usage:
	$err = &axs_init();
	next Err if ($err);

Performs some pre-flight checks on system variables.  Returns error message if there are any fatals.

Affects:
	$const{'is_demo'}
	$This_Script_Address
	$const{'filter_str'}

=cut

sub axs_init {
	my $err = '';
	Err: {
		$const{'is_demo'} = (-e 'is_demo') ? 1 : 0;

		# The following guesses the script address when $ENV is undefined, which
		# happens during command-line mode:
		unless ($This_Script_Address) {
			$This_Script_Address = '';
			$This_Script_Address = $1 if ($0 =~ m!([^\\|\/]+)$!);
			}
		$const{'filter_str'} = $FORM{'Filter'} || '';
		my $reg_err = &check_regex($const{'filter_str'});
		if ($reg_err) {
			$const{'filter_str'} = '';
			print "<p><b>Error:</b> $reg_err.</p>\n";
			}


		$reg_err = &check_regex($PREF{'My_Web_Address'} || '');
		if ($reg_err) {
			$PREF{'My_Web_Address'} = '';
			print "<p><b>Error:</b> $reg_err.</p>\n";
			}

		if (($0 =~ m!^(.+)(\\|/)!) and ($0 !~ m!safeperl\d*$!i)) {
			unless (chdir($1)) {
				$err = "unable to chdir to local script folder '$1' - $!";
				next Err;
				}
			print "<!-- Success: chdir to '$1' -->\015\012";
			}
		last Err;
		}
	return $err;
	}





my %named_subs = ();

$named_subs{'nh_setcookie'} = sub {

	my ($err, $b_is_done) = ('', 0);

	my $hostname = $ENV{'HTTP_HOST'} || $ENV{'SERVER_NAME'};

	my $legacy = $hostname;
	$legacy = $2 if ($legacy =~ m!^([^\.]+)(.*)$!);

	$hostname =~ s!^www\.!.!;

	my $cookie_header = '';

	if ($legacy ne $hostname) {
		# delete the cookie by setting it with a past expiration time
		$cookie_header .= "Set-Cookie: axs_no_log=; expires=Sat, 17-Apr-1999 20:58:18 GMT; domain=$legacy; path=/\015\012";
		}

	$cookie_header .= "Set-Cookie: axs_no_log=$FORM{'CookieValue'}; expires=Thu, 24-Sep-2020 20:58:18 GMT; domain=$hostname; path=/";

	print "HTTP/1.0 200 OK\015\012" if $::private{'PRINT_HTTP_STATUS_HEADER'};
	print "$cookie_header\015\012";
	print "Content-Type: text/html\015\012\015\012";

	print &Header();

print <<"EOM";
<p><b>Status:</b> attempted to set the no-log cookie using this header:</p>

<pre>$cookie_header</pre>

<p>Click here to <a href="$This_Script_Address?Action=nh_checkcookie">view your browser's cookie values</a> as a test.</p>

<p>Click here to <a href="$This_Script_Address?Target=Preferences">return to the main script page</a>.</p>
EOM

	$b_is_done = 1;

	return ($err, $b_is_done);
	};

$named_subs{'nh_checkcookie'} = sub {
	my ($err, $b_is_done) = ('', 0);

		print "HTTP/1.0 200 OK\015\012" if $::private{'PRINT_HTTP_STATUS_HEADER'};
		print "Content-Type: text/html\015\012\015\012";

		my $cookie_header = &html_encode($ENV{'HTTP_COOKIE'} || '');

		print &Header();
print <<"EOM";
<p><b>Status:</b> your browser sent the following HTTP_COOKIE variable:</p>

<pre>$cookie_header</pre>

<p>If the "axs_no_log" cookie is not present, then perhaps your browser is not configured to accept cookies, or it does not recognize the Set-Cookie headers used by this script.</p>

<p>See <a href="http://www.xav.com/scripts/axs/help/1506.html" target="_blank">this help file</a> for more information about not tracking your own visits.</p>

<p>Click here to <a href="$This_Script_Address?Target=Preferences">return to the main script page</a>.</p>

EOM

	$b_is_done = 1;

	return ($err, $b_is_done);
	};





%FORM = ();
&WebFormL( \%FORM );

my $b_is_login = 0;
my $err = '';
Err: {

	my $b_is_done = 0;

	my $Action = $FORM{'Action'} || $FORM{'Target'} || '';


	if (exists($named_subs{$Action})) {
		($err, $b_is_done) = &{ $named_subs{$Action} }();
		next Err if ($err);
		last Err if ($b_is_done);

		}

	$| = 1;
	print "HTTP/1.0 200 OK\015\012" if $::private{'PRINT_HTTP_STATUS_HEADER'};
	print "Pragma: no-cache\015\012";
	print "Content-Type: text/html\015\012\015\012";
	$| = 0;

	print &Header();


	$err = &axs_init();
	next Err if ($err);



	if (&query_env('QUERY_STRING') =~ m!^debugme$!i) {
		($err, $b_is_done) = &PrintDebugInfo(1, $AllowDebug);
		next Err if ($err);
		last Err if ($b_is_done);
		}



	($err, $b_is_login, %PREF) = &AuthPref($prefs);
	next Err if ($err);
	last Err unless ($b_is_login);


	if ($Action eq 'LogOut') {
		print &Authenticate();
		$b_is_login = 0;
		last Err;
		}

	# Next, we open the log file and import all the records.  This is *only*
	# done if we're going to make graphs this time:

	if ($FORM{'show_data'} || $FORM{'MakeGraphs'} || $FORM{'terminate'}) {

		print "<!-- choosing to open the log file -->\r\n";

		# Allows the "L" flag to date-filter database results (for reverse
		# compatibility):
		if ($FORM{'show_data'} and ($FORM{'maximum'} !~ m!^\d*$!)) {
			$FORM{'since_last'} = 'on';
			}
		# If date filtering is enabled, the dates are converted into a format
		# that makes sense to AXS:

		my $EndNumber;
		($const{'start_number'},$const{'start_str'},$EndNumber,$const{'end_str'}) = &FormatDates($FORM{'start_date'}, $FORM{'end_date'}, $FORM{'recent'}, $FORM{'since_last'}, $PREF{'last_number'});
		# Open the log file and store all of the hits in the
		# @LINES array.  Run whichever filters are necessary, for date/time
		# or by-file filtering.  This preps @LINES and also $const{'total_hits'}.



		my $FILTER = '(\|[^\|]*){10,10}\|(\d*)\|\d*\|(\d*)';
		if ($const{'filter_str'} eq '') {
			$FILTER = '(\|[^\|]*){10,10}\|(\d*)\|\d*\|(\d*)';
			}
		elsif ($const{'filter_str'} =~ m!^host:(.*)$!i) {
			$FILTER = '\|[^\|]*'.$1.'[^\|]*(\|[^\|]*){9,9}\|(\d*)\|\d*\|(\d*)';
			}
		elsif ($const{'filter_str'} =~ m!^ip:(.*)$!i) {
			$FILTER = '\|[^\|]*\|[^\|]*'.$1.'[^\|]*(\|[^\|]*){8,8}\|(\d*)\|\d*\|(\d*)';
			}
		elsif ($const{'filter_str'} =~ m!^from:(.*)$!i) {
			$FILTER = '\|[^\|]*\|[^\|]*\|[^\|]*'.$1.'[^\|]*(\|[^\|]*){7,7}\|(\d*)\|\d*\|(\d*)';
			}
		elsif ($const{'filter_str'} =~ m!^to:(.*)$!i) {
			$FILTER = '\|[^\|]*\|[^\|]*\|[^\|]*\|[^\|]*'.$1.'[^\|]*(\|[^\|]*){6,6}\|(\d*)\|\d*\|(\d*)';
			}
		elsif ($const{'filter_str'} =~ m!^browser:(.*)$!i) {
			$FILTER = '\|[^\|]*\|[^\|]*\|[^\|]*\|[^\|]*\|[^\|]*'.$1.'[^\|]*(\|[^\|]*){5,5}\|(\d*)\|\d*\|(\d*)';
			}
		elsif ($const{'filter_str'}) {
			$FILTER = '.*'.$const{'filter_str'}.'(.*)\|(\d*)\|\d*\|(\d*)\|(export\|)?\r?$';
			}


		unless (open(LOGFILE,"<$LogFile")) {
			$err = "unable to open file '$LogFile' for reading - $!";
			next Err;
			}
		binmode(LOGFILE);

		if ($const{'start_number'} || $EndNumber || $const{'filter_str'}) {
			my $EndSearchNow = 0;
			while (defined($_ = <LOGFILE>)) {
				# make sure each row is strictly valid:
				unless (m!^\|([^\|]*)\|([^\|]+)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|(export\|)?\r?$!) {
					$const{'total_corrupt_rows'}++;
					next;
					}
				$const{'total_hits'}++;

				next unless (($EndSearchNow) || (m!^$FILTER!));
				my $ThisYDAY = $2 * 1000 + $3 + 1900000;
				next if (($const{'start_number'}) and ($const{'start_number'} > $ThisYDAY));
				if ($EndNumber and ($EndNumber < $ThisYDAY)) {
					$EndSearchNow = 1;
					next;
					}
				push(@LINES,$_);
				}
			}
		else {

			while (defined($_ = <LOGFILE>)) {
				# make sure each row is strictly valid:
				unless (m!^\|([^\|]*)\|([^\|]+)\|([^\|]*)\|([^\|]*)\|([^\|]*)\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|\d+\|(export\|)?\r?$!) {
					$const{'total_corrupt_rows'}++;
					next;
					}
				$const{'total_hits'}++;
				push(@LINES, $_);
				}
			}
		close(LOGFILE);
		$const{'total_hits'} = &AddCommas($const{'total_hits'});
		} # End importing data.

	# Now we print HTML banner which goes at the top of every page:
	print &HTML_Header;

	# Finished printing HTML header. Now determine which subprocedure(s) to
	# invoke based on the input:

	if ($FORM{'show_data'}) {
		if ($FORM{'format'} eq 'Sort All by Time') {
			&show_data;
			}
		else {
			&show_data_flow;
			}
		last Err;
		}
	&make_stats(5,'Web Browser Full Name',0) if ($FORM{'s01'});

	&make_stats(5,'Web Browser Type and Version','short') if ($FORM{'s02'});

	&make_stats(5,'Web Browser Type','med') if ($FORM{'s02a'});

	&make_stats(5,'Operating System','os') if ($FORM{'s03'});

	if ($FORM{'s04'}) {
		if (open(FILE,"<data/tld.txt")) {
			binmode(FILE);
			while (<FILE>) {
				next unless (m!^(.*?):(.*?)\015?\012?$!);
				$tldx{$1} = $2;
				}
			close(FILE);
			}
		if (open(FILE,"<data/sld.txt")) {
			binmode(FILE);
			while (<FILE>) {
				next unless (m!^(.*?):(.*?)\015?\012?$!);
				$sldx{$1} = $2;
				}
			close(FILE);
			}
		if (open(FILE,"<data/states.txt")) {
			binmode(FILE);
			while (<FILE>) {
				next unless (m!^(.*?):(.*?)\015?\012?$!);
				$statesx{$1} = $2;
				}
			close(FILE);
			}
		&make_stats(1,'Top-level Domain','tld');
		}
	&make_stats(1,'Domain','abbr') if ($FORM{'s05'});
	&make_stats(1,'Remote Server','full') if ($FORM{'s06'});
	&make_stats(2,'IP Address',0) if ($FORM{'s07'});
	&make_stats(3,'Referring URL','') if ($FORM{'s08'});
	&make_stats(3,'Referring URL','domain') if ($FORM{'s09'});
	&make_stats(4,'Links Followed','remote') if ($FORM{'s10'});
	&make_stats(4,'Document Hit','local') if ($FORM{'s11'});
	&avg_docs if ($FORM{'s12'});
	&make_stats_year(13,'Day of the Year',0) if ($FORM{'s13'});
	&make_stats_week(12,'Day of the Week',0) if ($FORM{'s14'});
	&make_stats_hour(8,'Hour of the Day',0) if ($FORM{'s15'});

	&make_stats_month() if ($FORM{'s16'});

	&kill_it if ($FORM{'terminate'});
	last Err if ($const{'graph_made'});

	# If no graphs were made, then show the intro page, or allow
	# the user to set his preferences.  Each of these pages will use the
	# massive Java library:
	print &JavaLib;

	if ($Action eq 'Preferences') {
		&PrintCustomizePage();
		}
	else {
		# show main page:
		&PrintMainPage;
		}

	last Err;
	}
continue {
	print "<p><b>Error:</b> $err.</p>\n";
	}
&Footer($b_is_login);





# This is the end - everything below is a sub-procedure called above.
# ________________________________________________________________________


# Prints a line of the graph:
#
#	Format is &print_line(Name,Value) where Name is something
#	like 'Netscape 3' and Value is the number of hits.
#	<tr><td> name </td><td> percent </td><td> number </td><td> picture </td></tr>

sub print_line {
	my ($name, $value, $multiplier, $RH100) = @_;

	if (length($name) < 12) {
		$name .= '&nbsp;' x (12 - length($name));
		}
	$value = 0 if not defined $value;

	my $percent = sprintf( '%.2f', $value * $RH100 );

	my $image_field = '<br />';

	if ($value) {
		my $image_width = int( $multiplier * $value ) || 1;
		my $image_alt = 'X' x int( $image_width * ( 30 / $PREF{'MaxWidth'} ) );
		$image_field = qq!<img
		src="$PREF{'images_folder'}red.gif"
		border="1" alt="$image_alt" height="10" width="$image_width" />!;
		}

print <<"EOM";
<tr>
	<td nowrap="nowrap"><tt>$name</tt></td>
	<td $const{'bgcolor'} align="right"><tt>$percent%</tt></td>
	<td align="right"><tt>$value</tt></td>
	<td align="left">$image_field</td>
</tr>
EOM

	}



sub print_line2 {
	my ($N,$N2, $value, $multiplier, $RH100 ) = @_;

	my $percent = sprintf( '%.2f', $value * $RH100 );
	my $image_width = int( $multiplier * $value ) || 1;
	my $image_alt = 'X' x int( $image_width * ( 30 / $PREF{'MaxWidth'} ) );

print <<"EOM";
<tr>
	<td nowrap="nowrap"><tt>$N</tt></td>
	<td><tt>$N2<br /></tt></td>
	<td $const{'bgcolor'} align="right"><tt>$percent%</tt></td>
	<td align="right"><tt>$value</tt></td>
	<td align="left"><img
		src="$PREF{'images_folder'}red.gif"
		border="1" alt="$image_alt" height="10" width="$image_width" /></td>
</tr>
EOM

	}



# Begin Main Graphing Procedure:
sub make_stats {
	my ($q, $graph_name, $detail) = @_;

	my $block_close = &create_graph_header( &html_encode($graph_name), ($detail eq 'tld') );

	my $relevant_hits = 0;
	my $max_var = 0;
	my %ASTA = ();

	my $qmbd2 = quotemeta($FORM{'bd2'} || '');

	my $RECORD;
	foreach $RECORD (@LINES) {
		my @xSQL = split(/\|/,$RECORD);
		$xSQL[1] = $xSQL[1] || $xSQL[2];

		# Special case of referring URLs - the script makes sure first
		# that there is a non-zero entry in field 3, and then discards
		# those which appear to be local to the web site.  If the query
		# is being made for domain name only, the script runs a pattern
		# match on (somthing)//(something)/(whatever) and saves the first
		# two fields.  Local file links are discarded for domain-only
		# queries.

		if ($q == 3) {
			next unless ($xSQL[3]);

			# To protect against those with blank $PREF{'My_Web_Address'} variables, this
			# code will show *all* referrers if $PREF{'My_Web_Address'} is blank.  I feel
			# that this is a better solution that showing *no* referers.
			#
			# code was:
			# next if ($xSQL[3] =~ /$PREF{'My_Web_Address'}/i);

			next if (($PREF{'My_Web_Address'}) and ($xSQL[3] =~ m!$PREF{'My_Web_Address'}!i));

			if (($detail eq 'domain') and ($xSQL[3] =~ m!^([^\/]+)\/\/([^\/]*)!)) {
				$xSQL[3] = $1.'//'.$2;
				next if ($1 =~ m!file!i);
				}
			if (($PREF{'HideQueryStrings'}) and ($xSQL[3] =~ m!^(.*)\?!)) {
				$xSQL[3] = $1;
				}
			}


		# $q = 1 indicates a query on the server name.  this code
		# abbreviates the server names to either TLD, host.TLD, or
		# ' IP Address Only' in the case of non-alpha hosts.

		elsif ($q == 1) {
			if ($xSQL[1] =~ m!([^\.]+)\.([^\.]+)\.([^\.|\d]+)$!) {
				my ($p1, $p2, $p3) = ($1, $2, $3);
				# check for foo.co.uk format
				if ((length($p3) == 2) and ($p2 =~ m!^(\w\w|com|net|edu|gov)$!i)) {
					if ($detail eq 'tld') {
						$xSQL[1] = "$p2.$p3";
						}
					elsif ($detail eq 'abbr') {
						$xSQL[1] = "$p1.$p2.$p3";
						next if (($FORM{'bd1'}) and ("$p2.$p3" ne $FORM{'bd1'}));
						}
					}
				else {
					if ($detail eq 'tld') {
						$xSQL[1] = $p3;
						}
					elsif ($detail eq 'abbr') {
						$xSQL[1] = $p2.'.'.$p3;
						next if (($FORM{'bd1'}) and ($p3 ne $FORM{'bd1'}));
						}
					}
				}
			elsif ($xSQL[1] =~ m!([^\.]+)\.([^\.|\d]+)$!) {
				if ($detail eq 'tld') {
					$xSQL[1] = $2;
					}
				elsif ($detail eq 'abbr') {
					$xSQL[1] = $1.'.'.$2;
					next if (($FORM{'bd1'}) and ($2 ne $FORM{'bd1'}));
					}
				}
			else {
				next if ($FORM{'bd1'});
				$xSQL[1] = ' IP addr';
				}
			if (($detail eq 'full') and ($FORM{'bd2'})) {
				next unless ($xSQL[1] =~ m!(^|\.)$qmbd2$!i);
				}
			}


		# Exit Points & Local Documents:

		elsif ($q == 4) {
			if ($detail eq 'remote') {
				next if ($xSQL[14] ne 'export');

				# Again, only limit to local web pages if the $PREF{'My_Web_Address'} variable
				# is populated:
				next if (($PREF{'My_Web_Address'}) and ($xSQL[4] =~ m!$PREF{'My_Web_Address'}!i));

				}
			elsif ($detail eq 'local') {

				# Again, only limit to local web pages if the $PREF{'My_Web_Address'} variable
				# is populated:

				next unless ($xSQL[4] =~ m!$PREF{'My_Web_Address'}!i);

				}

			if (($PREF{'HideQueryStrings'}) and ($xSQL[4] =~ m!^(.*?)\?!)) {
				$xSQL[4] = $1;
				}

			if ($xSQL[4] =~ m|([^\/]+)//([^\/]+):80\/(.*)|) {
				$xSQL[4] = "$1//$2/$3";
				}
			if (($PREF{'HideDefaultDoc'}) and ($xSQL[4] =~ m!(.*)/$DefaultDoc$!i)) {
				$xSQL[4] = "$1/";
				}

			}


		# Operating System and Short Web Browser Name:

		elsif ($q == 5) {

			if ($FORM{'bd1'}) { # browser detail 1
				my $browser_type = &get_browser_name($xSQL[5]);
				next unless ($browser_type eq $FORM{'bd1'});
				$xSQL[5] = &get_browser_ver($xSQL[5]);
				}
			elsif ($FORM{'bd2'}) { # browser detail 2
				my $browser_type = &get_browser_ver($xSQL[5]);
				next unless ($browser_type eq $FORM{'bd2'});
				}
			elsif ($FORM{'bd3'}) { # browser/os detal 3
				my $os_type = &get_os_type($xSQL[5]);
				next unless ($os_type eq $FORM{'bd3'});
				}
			else {
				$xSQL[5] = &get_os_type($xSQL[5]) if ($detail eq 'os');
				$xSQL[5] = &get_browser_name($xSQL[5]) if ($detail eq 'med');
				$xSQL[5] = &get_browser_ver($xSQL[5]) if ($detail eq 'short');
				}
			}


		$ASTA{$xSQL[$q]}++;
		$relevant_hits++;
		$max_var++ unless ($max_var >= $ASTA{$xSQL[$q]});
		}
	# Finish loop through each hit in log file.


	$const{'truncated_keys'} = 0;

	my $multiplier = ($PREF{'MaxWidth'} / $max_var) if ($max_var);

	my $RH100 = 100 / $relevant_hits if ($relevant_hits);
	if ($relevant_hits < 1) {
		my $error = 'No matches found for your search. Sorry.';
		if ($FORM{'csv_out'}) {
			print $error;
			}
		else {
			print qq!</table><p>$error</p><table>!;
			}
		}
	elsif (($q == 3) || ($q == 4)) {
		# q3/4 => hits to local, hits from remote, etc. URL's.
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {
			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				}
			else {
				&print_line(&url_format($_),$ASTA{$_}, $multiplier, $RH100 );
				}
			}
		}
	elsif (($q == 1) and ($detail eq 'abbr')) {
		# q1 => server names.

		my ($val, $display_val) = ('', '');

		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {
			$val = $display_val = $_;
			if (($PREF{'MaxChars'}) and (length($val) > $PREF{'MaxChars'})) {
				$const{'truncated_keys'}++;
				$display_val = substr($val, 0, $PREF{'MaxChars'});
				}

			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				next;
				}



			if (m! IP addr!) {
				&print_line('<i>IP addr</i>',$ASTA{$_}, $multiplier, $RH100 );
				}
			else {
				&print_line("[<a href=\"$whois" . &html_encode($val) . "\"$const{'a_target_attrib'}>who</a>] <a href=\"$This_Script_Address?s06=on&amp;MakeGraphs=1&amp;bd2=" . &url_encode($_) . "\">" . &html_encode($display_val) . "</a>",$ASTA{$_}, $multiplier, $RH100 );
				}
			}
		}
	elsif (($q == 1) and ($detail eq 'tld')) {
		# mil/com/ca etc
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {

			my $main = '';
			my $tld = $tldx{$_} || '';


			if ($_ eq ' IP addr') {
				$main = $_;
				$tld = '';
				}
			else {
				if (m!^(\w+)\.(\w+)$!) {
					if ($2 eq 'us') {
						$tld = "$statesx{$1} - $tldx{$2}";
						}
					else {
						$tld = "$sldx{$1} - $tldx{$2}";
						}
					}
				$main = "<a href=\"$This_Script_Address?s05=on&amp;MakeGraphs=1&amp;bd1=" . &url_encode($_) . "\">" . &html_encode($_) ."</a>";
				}

			if ($FORM{'csv_out'}) {
				s!\,!!g;
				$tld =~ s!\,!!g;
				print &html_encode("$_,$tld,$ASTA{$_},\n");
				next;
				}

			&print_line2( $main, $tld, $ASTA{$_}, $multiplier, $RH100 );
			}
		}



	elsif ($q == 2) {
		# q2 => IP addresses.
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {

			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				next;
				}

			my $htmlsafe = &html_encode($_);
			&print_line( qq!<a href="$nslookup?$htmlsafe"$const{'a_target_attrib'}>$htmlsafe</a>!, $ASTA{$_}, $multiplier, $RH100 );
			}
		}
	elsif (($q == 5) and ($detail eq 'med')) {
		my ($val, $display_val) = ('', '');

		# q* => other.  q5 = browser type, os type, etc.
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {
			$val = $display_val = $_;
			if (($PREF{'MaxChars'}) and (length($val) > $PREF{'MaxChars'})) {
				$const{'truncated_keys'}++;
				$display_val = substr($val, 0, $PREF{'MaxChars'});
				}


			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				next;
				}

			my $ue_display = &url_encode($display_val);
			my $he_display = &html_encode($display_val);

			&print_line( qq!<a href="$This_Script_Address?s02=on&amp;MakeGraphs=1&amp;bd1=$ue_display">$he_display</a>!, $ASTA{$_}, $multiplier, $RH100 );
			}
		}

	elsif (($q == 5) and ($detail eq 'short')) {
		my ($val, $display_val) = ('', '');

		# q* => other.  q5 = browser type, os type, etc.
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {
			$val = $display_val = $_;
			if (($PREF{'MaxChars'}) and (length($val) > $PREF{'MaxChars'})) {
				$const{'truncated_keys'}++;
				$display_val = substr($val, 0, $PREF{'MaxChars'});
				}

			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				next;
				}

			my $ue_display = &url_encode($display_val);
			my $he_display = &html_encode($display_val);

			&print_line( qq!<a href="$This_Script_Address?s01=on&amp;MakeGraphs=1&amp;bd2=$ue_display">$he_display</a>!, $ASTA{$_}, $multiplier, $RH100 );
			}
		}

	elsif (($q == 5) and ($detail eq 'os')) {
		my ($val, $display_val) = ('', '');

		# q* => other.  q5 = browser type, os type, etc.
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {
			$val = $display_val = $_;
			if (($PREF{'MaxChars'}) and (length($val) > $PREF{'MaxChars'})) {
				$const{'truncated_keys'}++;
				$display_val = substr($val, 0, $PREF{'MaxChars'});
				}

			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				next;
				}

			my $ue_display = &url_encode($display_val);
			my $he_display = &html_encode($display_val);

			&print_line( qq!<a href="$This_Script_Address?s01=on&amp;MakeGraphs=1&amp;bd3=$ue_display">$he_display</a>!, $ASTA{$_}, $multiplier, $RH100 );
			}
		}
	else {
		my ($val, $display_val) = ('', '');





		# q* => other.  q5 = browser type, os type, etc.
		foreach ($const{'use_numeric_sort'} ? (sort {$ASTA{$b} <=> $ASTA{$a} || $a cmp $b} keys %ASTA) : (sort keys %ASTA)) {
			$val = $display_val = $_;
			if (($PREF{'MaxChars'}) and (length($val) > $PREF{'MaxChars'})) {
				$const{'truncated_keys'}++;
				$display_val = substr($val, 0, $PREF{'MaxChars'});
				}

			if ($FORM{'csv_out'}) {
				s!\,!!g;
				print &html_encode("$_,$ASTA{$_},\n");
				next;
				}

			&print_line( &html_encode($display_val), $ASTA{$_}, $multiplier, $RH100 );
			}
		}

	my $NumGraphLines = scalar (keys %ASTA);

	print $block_close;

	if (($q == 4) and ($detail eq 'remote') and ($NumGraphLines == 0)) {

print <<"EOM";

<p>If you consistently receive no results on the graph "Links Followed", but you receive results for all other graphs, please review <a href="http://www.xav.com/scripts/axs/help/1009.html" target="_blank">this help file</a>.</p>

EOM

		}

	print &GraphSummary( $relevant_hits, $NumGraphLines );
	$const{'graph_made'}++;
	}


# Begin Main Graphing Procedure for Day of Year:

sub make_stats_year {

	# Do we have a leap year, or a non-leap year?
	# leap years are divisible by 4.  However, every 100 years
	# is an exception (non-leap), and every 400 years is an
	# exception to that (leap).

	my $this_year = (localtime(time))[5] + 1900;

	# Assume normal year:
	my @mon_array = (0,31,59,90,120,151,181,212,243,273,304,334);
	my $total_days_year = 365;

	if (($this_year % 4) == 0) {
		# year is divisible by 4, is leap, probably

		if ((($this_year % 100) == 0) and (($this_year % 400) != 0)) {
			# is divisible by 100, and not divisible by 400;
			# standard exception, leave this as a non-leap year
			}
		else {
			# ok world we have a leap year:

			@mon_array = (0,31,60,91,121,152,182,213,244,274,305,335);
			$total_days_year = 366;

			}
		}

	my $block_close = &create_graph_header( 'Day of Year' );

	my $relevant_hits = scalar @LINES;

	my $min_day = 366;
	my $max_day = -1;

	my @DayCount = ();
	foreach (@LINES) {
		my $ThisDay = (split(/\|/,$_))[13];
		$max_day = $ThisDay if ($ThisDay > $max_day);
		$min_day = $ThisDay if ($ThisDay < $min_day);
		$DayCount[$ThisDay]++;
		}

	# initialize all entries, and find the maximum:
	my $max_var = 0;
	foreach (0..($total_days_year - 1)) {
		$DayCount[$_] = 0 if not defined $DayCount[$_];
		next if ($max_var > $DayCount[$_]);
		$max_var = $DayCount[$_];
		}
	$max_var = 1 unless $max_var;
	my $multiplier = ($PREF{'MaxWidth'} / $max_var);
	my $RH100 = $relevant_hits ? ( 100 / $relevant_hits ) : 1;

	# error correct
	$min_day = 0 if ($min_day == 366);
	$max_day = $total_days_year if ($max_day == -1);

	my $NumGraphLines = 0;
	my $month_count = 0;
	foreach (0..($total_days_year - 1)) {

		$month_count++ if (($month_count < 11) and ($_ == $mon_array[$month_count + 1]));
		my $mday = (($_ - $mon_array[$month_count]) + 1);
		my $day = "$LongMonths[$month_count] $mday";
		next if ($_ < $min_day);
		last if ($_ > $max_day);
		$NumGraphLines++;


		if ($FORM{'csv_out'}) {
			s!\,!!g;
			my $human_month = $month_count + 1;
			print "$day,$human_month,$mday,$DayCount[$_],\n";
			}
		else {
			&print_line( $day, $DayCount[$_], $multiplier, $RH100 );
			}
		}

	print $block_close;

	print &GraphSummary( $relevant_hits, $NumGraphLines );
	$const{'graph_made'}++;
	} # End Graph for Day of Year.


# Begin Main Graphing Procedure for Day of Week
sub make_stats_week {

	my $block_close = &create_graph_header( 'Day of Week' );

	my @WeekdayCount = ();
	my $relevant_hits = scalar @LINES;
	foreach (@LINES) {
		my $ThisDay = (split(/\|/,$_))[12];
		$WeekdayCount[$ThisDay]++;
		}

	# what is the maximum value?
	my $max_var = 0;
	foreach (0..6) {
		$WeekdayCount[$_] = 0 if not defined $WeekdayCount[$_];
		next if ($max_var > $WeekdayCount[$_]);
		$max_var = $WeekdayCount[$_];
		}

	$max_var = 1 unless $max_var;
	my $multiplier = ($PREF{'MaxWidth'} / $max_var);
	my $RH100 = $relevant_hits ? ( 100 / $relevant_hits ) : 1;

	foreach (0..6) {
		if ($FORM{'csv_out'}) {
			s!\,!!g;
			print "$LongWeekDays[$_],$_,$WeekdayCount[$_],\n";
			}
		else {
			&print_line( $LongWeekDays[$_], $WeekdayCount[$_], $multiplier, $RH100 );
			}
		}

	print $block_close;
	print &GraphSummary( $relevant_hits, 7 );
	$const{'graph_made'}++;
	}


sub make_stats_month {

	my $block_close = &create_graph_header( 'Month' );

	my $relevant_hits = scalar @LINES;

	my @counts = ();
	foreach (@LINES) {
		my $mon_index = (split(/\|/,$_))[10];
		$counts[$mon_index]++;
		}

	my $max_var = 0;
	foreach (0..11) {
		$counts[$_] = 0 if not defined $counts[$_];
		next if ($max_var > $counts[$_]);
		$max_var = $counts[$_];
		}
	$max_var = 1 unless $max_var;
	my $multiplier = ($PREF{'MaxWidth'} / $max_var);
	my $RH100 = $relevant_hits ? ( 100 / $relevant_hits ) : 1;

	foreach (0..11) {
		if ($FORM{'csv_out'}) {
			print "$LongMonths[$_],$_,$counts[$_],\n";
			}
		else {
			&print_line( $LongMonths[$_], $counts[$_], $multiplier, $RH100 );
			}
		}

	print $block_close;
	print &GraphSummary( $relevant_hits, 12 );
	$const{'graph_made'}++;
	}



sub create_graph_header {
	my ($name, $b_two_col) = @_;
	my $block_close = '';

	print '<p><br /></p><hr /><p><br /></p>' if $const{'graph_made'};

	if ($FORM{'csv_out'}) {
		print "<hr /><pre>\n\n";
		$block_close = '</pre><hr />';
		}
	else {

		my $colspan = $b_two_col ? 2 : 1;

print <<"EOM";

<table border="0" cellpadding="6" cellspacing="0">
<tr>
	<th colspan="$colspan" align="left">$name:</th>
	<th colspan="2" align="center">Hits:</th>
	<th align="left">Graph:</th>
</tr>

EOM

		$block_close = '</table>';
		}


	return $block_close;
	}



# Begin Main Graphing Procedure for Hour of Day:
sub make_stats_hour {

	my $block_close = &create_graph_header( 'Hour of Day' );

	my @HourCount = ();
	my $relevant_hits = scalar @LINES;
	foreach (@LINES) {
		my $ThisHour = (split(/\|/,$_))[8];
		$HourCount[$ThisHour]++;
		}

	my $max_var = 0;
	foreach (0..23) {
		$HourCount[$_] = 0 if not defined $HourCount[$_];
		next if ($max_var > $HourCount[$_]);
		$max_var = $HourCount[$_];
		}
	$max_var = 1 unless $max_var;

	my $multiplier = $PREF{'MaxWidth'} / $max_var;
	my $RH100 = $relevant_hits ? ( 100 / $relevant_hits ) : 1;

	foreach (0..23) {

		if ($FORM{'csv_out'}) {
			s!\,!!g;
			print "$_,$HourCount[$_],\n";
			next;
			}

		my $name = '';

		if ($PREF{'UseMilTime'}) {
			$name = "$_:00";
			}
		elsif ($_ == 0) {
			$name = 'Midnight';
			}
		elsif ($_ < 12) {
			$name = $_.' AM';
			}
		elsif ($_ == 12) {
			$name = 'High noon';
			}
		else {
			$name = ($_ - 12) . ' PM';
			}

		&print_line( $name, $HourCount[$_], $multiplier, $RH100 );
		}

	print $block_close;
	print &GraphSummary( $relevant_hits, 24 );
	$const{'graph_made'}++;
	}


sub avg_docs {
	my $internal_hits = 0;
	my $unique_ip_count = 0;
	my %IP = ();
	foreach (@LINES) {
		my @terms = split(/\|/,$_);
		$unique_ip_count++ unless ($IP{$terms[2]});
		$IP{$terms[2]}++;
		$internal_hits++ if ($terms[4] =~ m!$PREF{'My_Web_Address'}!i);
		}
	my $avg_docs_per_visitor = 0;
	if ($unique_ip_count) {
		$avg_docs_per_visitor = $internal_hits / $unique_ip_count;
		}
	$avg_docs_per_visitor = sprintf( '%.3f', $avg_docs_per_visitor );

	my $relevant_hits = $internal_hits;

	my $ac_internal_hits = &AddCommas($internal_hits);
	$unique_ip_count = &AddCommas($unique_ip_count);

print '<br /><br /><hr /><br /><br /><br />' if $const{'graph_made'};
print <<"EOM";

<p><b>Average Number of Hits Per Visitor</b></p>
<blockquote>

	<p>The average number of documents viewed per visitor is <b>$avg_docs_per_visitor</b>.</p>

	<p>There have been a total of $ac_internal_hits on local documents from $unique_ip_count unique IP addresses.</p>

</blockquote>

EOM

	print &GraphSummary( $relevant_hits, 0 );
	$const{'graph_made'}++;
	}


sub PrettyTime {
	my ($Hour,$Minutes,$Seconds) = @_;
	$Minutes = &Pad($Minutes);
	$Seconds = &Pad($Seconds);
	if ($PREF{'UseMilTime'}) {
		$Hour = &Pad($Hour);
		return "$Hour:$Minutes:$Seconds";
		}
	elsif ($Hour < 12) {
		$Hour = $Hour % 12;
		$Hour = 12 if ($Hour == 0);
		$Hour = &Pad($Hour);
		return "$Hour:$Minutes:$Seconds AM";
		}
	else {
		$Hour = $Hour % 12;
		$Hour = 12 if ($Hour == 0);
		$Hour = &Pad($Hour);
		return "$Hour:$Minutes:$Seconds PM";
		}
	}


=item str_jumptext_ex

Usage:
	my ($jump_sum, $jump_links) = &str_jumptext( $current_pos, $units_per_page, $maximum, $url, $b_is_exact_count );

Creates the HTML text for a "<- Previous 1 2 3 4 5 Next ->" block.

Everything is 1-based.

=cut

sub str_jumptext_ex {
	my ( $start_pos, $units_per_page, $maximum, $url, $b_is_exact_count ) = @_;

	my $jump_sum = '';
	my $jump_links = '';

	$start_pos = 1 if ($start_pos < 1);

	my $end_pos = $start_pos + $units_per_page - 1;


	unless ($b_is_exact_count) {
		$b_is_exact_count = 1 if ($maximum < $end_pos);
		}

	$end_pos = $maximum if ($maximum < $end_pos);

	if ($b_is_exact_count) {
		$jump_sum = sprintf( 'Records %s-%s of %s displayed.', $start_pos, $end_pos, $maximum );
		}
	else {
		$jump_sum = sprintf( 'Records %s-%s of %s displayed.', $start_pos, $end_pos, "$end_pos+" );

		# Okay, we've printed what we know.  Now, for purposes of generating advance links, pretend that there's at least one page beyond this one (we know that if max < curr+units then we would have toggled to b_is_exact_count earlier.  and if max already exceeds this page's worth fo data, then there's no need to tweak it:

		if ($maximum == $end_pos) {
			$maximum++;
			}
		}

	if ($maximum > $units_per_page) {

		# Time for a scrolling thing - "<- Previous 1 2 3 4 5 Next ->"

		$jump_links .= 'Records:';
		$jump_links .= ' ';

		if ($start_pos > 1) {
			my $prev_pos = $start_pos - $units_per_page;
			if ($prev_pos < 0) {
				$prev_pos = 0;
				}
			$jump_links .= "[ <a href=\"$url$prev_pos\">&lt;&lt; Previous</a> ] ";
			}

		my $nlinks = 1 + int(($maximum - 1) / $units_per_page);
		my $thislink = 1 + int($start_pos / $units_per_page);

		my $start = 1;
		if ($thislink > 15) {
			$start = $thislink - 15;
			}

		my $x = 0;
		for ($x = $start; $x <= $nlinks; $x++) {
			if ($x == $thislink) {
				$jump_links .= " <b>$x</b>";
				}
			else {
				$jump_links .= " <a href=\"$url" . (1 + (($x - 1) * $units_per_page)) . "\">$x</a>\n";
				}
			last if ($x > ($start + 18));
			}

		if ($maximum > $end_pos) {
			$jump_links .= " [ <a href=\"$url" . ($start_pos + $units_per_page) . "\">Next &gt;&gt;</a> ]";
			}

		}
	return ($jump_sum, $jump_links);
	}




# Begin Show Database Procedure:
sub show_data {

	if ($FORM{'maximum'} =~ /\d+/) {
		my $array_size = scalar @LINES;
		if ($FORM{'maximum'} < $array_size) {
			splice(@LINES,0,$array_size - $FORM{'maximum'});
			}
		}

	print &DatabaseTimeDescription;


	#changed 0030 - jumplinks
	my $record_count = scalar @LINES;
	my $start_pos0 = 0;
	if (($FORM{'start'}) and ($FORM{'start'} =~ m!^\d+$!)) {
		$start_pos0 = $FORM{'start'} - 1;
		}
	my ($jump_sum, $jump_links) = ('','');
	my $limit = $PREF{'ListingsPerPage'};
	if (($PREF{'ListingsPerPage'}) and ($PREF{'ListingsPerPage'} < $record_count)) {
		my $url = "$This_Script_Address?";
		foreach ('maximum','Filter','start_date','end_date','recent','since_last','format','show_data') {
			next unless (defined($FORM{$_}));
			$url .= "$_=" . &url_encode($FORM{$_}) . "&amp;";
			}
		$url .= "start=";
		($jump_sum, $jump_links) = &str_jumptext_ex( $start_pos0 + 1, $PREF{'ListingsPerPage'}, $record_count, $url, 1 );
		print "<p>$jump_sum<br />$jump_links</p>";
		}
	#/


	print '<pre>';

	my ($relevant_hits,$NumGraphLines) = (0,0);
	foreach (reverse @LINES) {
		if ($start_pos0) {
			$start_pos0--;
			next;
			}
		$relevant_hits++;
		my ($VisitHost,$IPAddress,$T3,$T4,$Browser,$SS,$MM,$HH,$Day,$T10,$Year,$T12,$Redirect) = (split(/\|/,$_))[1..12,14];
		$VisitHost = $VisitHost || $IPAddress;

		my $Referer = $T3 ? &url_format($T3) : '';
		my $WebPage = &url_format($T4);
		my $HourMinSec = &PrettyTime($HH,$MM,$SS);
		my $WeekDay = $LongWeekDays[$T12];
		my $Month = $LongMonths[$T10];

		$Year += 1900;
		$Redirect = ($Redirect eq 'export') ? 1 : 0;

		#changed 0015 - security fix
		foreach ($VisitHost, $IPAddress, $Browser) {
			$_ = html_encode($_); #changed 0015 - security fix
			}


		if ($VisitHost eq $IPAddress) {
			$IPAddress = qq!<a href="$nslookup?$IPAddress" target="_blank">nslookup</a>!;
			}


		print "A visitor from <b>$VisitHost</b> ($IPAddress)\n";
		if (($Redirect) and ($Referer ne $WebPage)) {
			print "was redirected to $WebPage\n";
			print "from $Referer\n";
			}
		elsif ($Redirect) {
			print "visited $WebPage\n";
			}
		else {
			if (($Referer) and ($Referer ne $WebPage)) {
				print "arrived from $Referer,\n";
				}
			else {
				print "arrived without a referring URL,\n";
				}
			print "and visited $WebPage\n";
			}
		print "at $HourMinSec on $WeekDay, $Month $Day, $Year.\n";
		print "This visitor used $Browser.\n";
		print "\n";
		$limit--;
		last if (0 == $limit);
		}
	print '</pre>';
	print $jump_links;
	print &GraphSummary( $relevant_hits, $NumGraphLines );
	$const{'graph_made'}++;
	} # End Show Database Procedure.


# Begin Show Database-Sytle Visitor Flow:
sub show_data_flow {

	if ($FORM{'maximum'} =~ /\d+/) {
		my $array_size = scalar @LINES;
		if ($FORM{'maximum'} < $array_size) {
			splice(@LINES,0,$array_size - $FORM{'maximum'});
			}
		}

	my ($total_ips,$multiple_hit_ips) = (0,0);
	my $delimiter = 'Flow_Chart_Delimiter';
	my %IPFLOW = ();
	my @IPS = ();

	foreach (@LINES) {
		next unless (m!^\|([^\|]*)\|([^\|]+)!);
		if ($IPFLOW{$2}) {
			$IPFLOW{$2} .= $delimiter.$_;
			}
		else {
			push(@IPS,$2);
			$IPFLOW{$2} = $_;
			$total_ips++;
			}
		}

	print &DatabaseFlowDescription;





	#changed 0030 - jumplinks
	my ($jump_sum, $jump_links) = ('','');
	my $record_count = scalar @LINES;
	my $start_pos0 = 0;
	if (($FORM{'start'}) and ($FORM{'start'} =~ m!^\d+$!)) {
		$start_pos0 = $FORM{'start'} - 1;
		}

	my $limit = $PREF{'ListingsPerPage'};
	if (($PREF{'ListingsPerPage'}) and ($PREF{'ListingsPerPage'} < $record_count)) {
		my $url = "$This_Script_Address?";
		foreach ('maximum','Filter','start_date','end_date','recent','since_last','format','show_data') {
			next unless (defined($FORM{$_}));
			$url .= "$_=" . &url_encode($FORM{$_}) . "&amp;";
			}
		$url .= "start=";
		($jump_sum, $jump_links) = &str_jumptext_ex( $start_pos0 + 1, $PREF{'ListingsPerPage'}, $record_count, $url, 1 );
		print "<p>$jump_sum<br />$jump_links</p>\n";
		}
	#/

	print '<pre>';

	my $key;
	Visitor: foreach $key (reverse @IPS) {

		my @LINES = split(m!$delimiter!,$IPFLOW{$key});

		my $num_hits = scalar @LINES;

		if ($start_pos0 > 0) {
			$start_pos0 -= $num_hits;
			next Visitor;
			}


		if (($num_hits > 1) || ($FORM{'format'} eq 'Sort All by Visitor')) {

			# Multiple documents visited; generate flow chart:

			$multiple_hit_ips++ if ($num_hits > 1);

			my @terms = split(/\|/,$LINES[0]);
			$terms[1] = $terms[1] || $terms[2];

			my $HourMinSec = &PrettyTime($terms[8],$terms[7],$terms[6]);

			my $NumTimes;
			if ($num_hits > 2) {
				$NumTimes = "$num_hits times";
				}
			elsif ($num_hits == 1) {
				$NumTimes = 'once';
				}
			else {
				$NumTimes = 'twice';
				}

			#changed 0015 - security fix
			foreach ($terms[1], $terms[2], $terms[3], $terms[4], $terms[5]) {
				$_ = &html_encode($_); #changed 0015 - security fix
				}

			my $FullYear = 1900 + $terms[11];

			my $from_dns = $terms[1];
			my $from_ip = $terms[2];

			if ($from_dns eq $from_ip) {
				my $html = &html_encode($from_ip);
				$from_ip = qq!<a href="$nslookup?$html" target="_blank">nslookup</a>!;
				}

print <<"EOM";

<hr />

A visitor from <b>$from_dns</b> ($from_ip) was logged $NumTimes,
starting at $HourMinSec on $LongWeekDays[$terms[12]], $LongMonths[$terms[10]] $terms[9], $FullYear.
The initial browser was $terms[5].

EOM

print '  This visitor first ';

			my $PrevTime;
			my $first = 'true';
			foreach (@LINES) {
				my @terms = split(/\|/,$_);
				$terms[1] = $terms[1] || $terms[2];

					if ($first ne 'true') {

						my $ThisTime = ((((($terms[13] * 24) + $terms[8]) * 60) + $terms[7]) * 60) + $terms[6];

						# $INT is the time interval in seconds:

						my $INT = ($ThisTime - $PrevTime);

						#changed 0013 - fixed date rendering problem

						my $seconds = int($INT % 60);
						my $minutes = int(($INT % 3600) / 60);
						my $hours = int(($INT % 86400) / 3600);

						$minutes = reverse(substr(reverse("00$minutes"), 0, 2));
						$seconds = reverse(substr(reverse("00$seconds"), 0, 2));
						$hours = reverse(substr(reverse("00$hours"), 0, 2));

						#end changes

						print "  $hours:$minutes:$seconds";

						my $days;
						if ($days = int($INT/86400)) {
							print " and $days day";
							print 's' if ($days > 1);
							}
						print " later, ";
						}

					if (($terms[14] eq 'export') and ($terms[3] ne $terms[4])) {
						print "was redirected to " . &url_format($terms[4]) . "\n";
						print "      from " . &url_format($terms[3]) . "\n\n";
						}
					elsif ($terms[14] eq 'export') { # Image redirect
						print "dropped by " . &url_format($terms[3]) . "\n\n";
						}
					else {
						if (($terms[3]) and ($terms[3] ne $terms[4])) {
							print "arrived from " . &url_format($terms[3]) . "\n";
							}
						else {
							print "arrived without a referring URL,\n";
							}
						print "    and visited " . &url_format($terms[4]) . "\n";
						print "\n";
						}
					$first = 'false';

					$PrevTime = ((((($terms[13] * 24) + $terms[8]) * 60) + $terms[7]) * 60) + $terms[6];
					$limit--;
					} # End foreach hit per IP.
					} # End test of more than one hit per IP.
				last Visitor if (($PREF{'ListingsPerPage'}) and ($limit < 1));
				} # End foreach loop through all IP's.

print <<"EOM";

</pre>

<hr />

$jump_links

<p><b>Summary:</b></p>

<p>There were visits from $total_ips distinct IP addresses. However, only $multiple_hit_ips of these visited more than one document.</p>

EOM

	$const{'graph_made'}++;
	} # End Show Database-Style Visitor Flow.



# Begin Export/Delete Log Procedure:
sub kill_it {
	my $err = '';
	Err: {
		$const{'graph_made'}++;

		if ($const{'is_demo'}) {
			$err = "the deletion of the access log is not allowed in the online demo";
			next Err;
			}

		unless (open(NEWLOG,">$LogFile")) {
			$err = "unable to open log file '$LogFile' for writing - $!";
			next Err;
			}
		binmode(NEWLOG);
		my $NumLogEntries = 0;
		if ($const{'start_number'}) {
			$NumLogEntries = scalar @LINES;
			foreach (@LINES) {
				print NEWLOG;
				}
			}
		close(NEWLOG);

		my $NewLogSize = -s $LogFile;

print <<"EOM";

<p><b>Access Log Deleted:</b></p>
<blockquote>
	<p>The log file has been successfully deleted.</p>

EOM

print <<"EOM" if ($const{'start_number'});

<p>Hits since $const{'start_str'} were retained. There are now $NumLogEntries entries in the access log. The new log size is $NewLogSize bytes.</p>

EOM

print <<"EOM";

</blockquote>

EOM
		last Err;
		}
	continue {
		print "<p><b>Error:</b> $err.</p>\n";
		}
	}





# This is the routine to support the new "Browser Wars" report.
# The routine for the "Abbreviated Browser" report has been renamed get_browser_ver

sub get_browser_name {
	local $_ = defined($_[0]) ? lc($_[0]) : '';
	return 'Unknown/Other' unless ($_);

# I reformatted the code below to make it appear more tabular and easier to read.
# You may have to clean up the tabs on some lines.
# I found that my email and text editors don't match.

if (m!opera.(\d)!o)					{ return 'Opera'; }
elsif (m!mozilla/(\d)!o) {
	if (m!compatible!o) {
		if    (m!webtv!o)				{ return 'WebTV'; }
		elsif (m!aol!o)				{ return 'AOL\'s Browser'; }
		elsif (m!msie!o)				{ return 'Internet Explorer'; }
		elsif (m!icab!o)				{ return 'iCab'; }
		elsif (m!mozilla/3.01.\(compatible;?\)!o) { return 'Cache/Proxy server'; }
		elsif (m!powermarks!o)			{ return 'Powermarks bookmark thing'; }
		elsif (m!fdse.robot!o)			{ return 'Spider/Crawler'; }
		elsif (m!netmind-minder!o)		{ return 'Spider/Crawler'; }
		elsif (m!bordermanager!o)		{ return 'Cache/Proxy server'; }
		else						{ return 'Unknown/Other'; }
		}
	else							{ return 'Netscape'; }
	}
elsif (m!(microsoft internet explorer)|(msie)!o)	{ return 'Internet Explorer'; }
elsif (m!msproxy!o)					{ return 'Cache/Proxy server'; }
elsif (m!(crawler)|(spider)|(scooter)|(bot)!o)	{ return 'Spider/Crawler'; }
elsif (m!(iweng)|(aolbrowser)!o)			{ return 'AOL\'s Browser'; }
elsif (m!lynx!o)						{ return 'Lynx'; }
elsif (m!webexplorer!o)					{ return 'IBM WebExplorer'; }
elsif (m!quarterdeck!o)					{ return 'QuarterDeck Mosaic'; }
elsif (m!spry!o)						{ return 'Compuserve\'s SPRY Mosaic'; }
elsif (m!enhanced_mosaic!o)				{ return 'NCSA Mosaic (Enhanced)'; }
elsif (m!mosaic!o)					{ return 'NCSA Mosaic'; }
elsif (m!prodigy!o)					{ return 'Prodigy\'s Browser'; }
else								{ return 'Unknown/Other'; }
} # end sub get_browser_name


# This is the routine to support the old "Abbreviated Browser" report.
# It has been renamed from get_browser_name
sub get_browser_ver {
	local $_ = defined($_[0]) ? lc($_[0]) : '';
	return 'Unknown/Other' unless ($_);

if (m!opera.(\d+)\.(\d+)!o) {
	return "Opera v$1.$2";
	}
elsif (m!opera.(\d+)!o) {
	return "Opera v$1.x";
	}
elsif (m!mozilla/(\d)!o) {
	if (m!compatible!o) {
		if    (m!webtv!o)				{ return 'WebTV'; }
		elsif (m!aol (\d).(\d)!o)		{ return "AOL's Browser v$1.$2"; }
		elsif (m!aol-iweng (\d)!o)		{ return "AOL's Browser v$1.x"; }
		elsif (m!msie.?(\d).(\d)!o)		{ return "Internet Explorer v$1.$2"; }
		elsif (m!icab (\d).(\d)!o)		{ return "iCab v$1.$2"; }
		elsif (m!konqueror!o)			{ return 'Konqueror'; }
		elsif (m!powermarks!o)			{ return 'Powermarks bookmark thing'; }

		elsif (m!mozilla/3.01.\(compatible;?\)!o) { return 'Cache/Proxy server (Unknown/Other)'; }
		elsif (m!bordermanager!o)		{ return 'Cache/Proxy server (Border Manager)'; }
		elsif (m!fdse.robot!o)			{ return 'Spider/Crawler (FDSE)'; }
		elsif (m!netmind-minder!o)		{ return 'Spider/Crawler (NetMind)'; }
		elsif (m!openfind!o)			{ return 'Spider/Crawler (Openfind)'; }
		elsif (m!webwasher!o)			{ return 'Spider/Crawler (WebWasher)'; }
		elsif (m!wisenutbot!o)			{ return 'Spider/Crawler (WISEnut)'; }
		elsif (m!webwasher!o)			{ return 'Spider/Crawler (WebWasher)'; }
		else						{ return 'Unknown/Other'; }
		}
	elsif (m!mozilla/(\d).(\d)!o) {
		my ($major, $minor) = ($1, $2);
		if (m!netscape6/6\.(\d+)\.!) {
			return "Netscape v6.$1";
			}
		if ($major >= 5) { $major++; }	  return "Netscape v$major.$minor"; }
	else							{ return "Netscape v$1.x"; }
	}
elsif (m!microsoft internet explorer/(\d)!o)	{ return "Internet Explorer v$1.x"; }
elsif (m!msie/(\d)!o)					{ return "Internet Explorer v$1.x"; }
elsif (m!msproxy!o)					{ return 'Cache/Proxy server (MSProxy)'; }
elsif (m!fast-webcrawler!o)				{ return 'Spider/Crawler (AllTheWeb)'; }
elsif (m!scooter!o)					{ return 'Spider/Crawler (Altavista)'; }
elsif (m!ask jeeves!o)					{ return 'Spider/Crawler (Ask Jeeves)'; }
elsif (m!googlebot!o)					{ return 'Spider/Crawler (Google)'; }
elsif (m!(crawler)|(spider)|(bot)!o)		{ return 'Spider/Crawler (Unknown/Other)'; }
elsif (m!teleport pro!o)				{ return 'Teleport Pro Offline Browser'; }
elsif (m!iweng/(\d)!o)					{ return "AOL's Browser v$1.x"; }
elsif (m!aolbrowser/(\d)!o)				{ return "AOL's Browser v$1.x"; }
elsif (m!lynx!o)						{ return 'Lynx'; }
elsif (m!webexplorer!o)					{ return 'IBM WebExplorer'; }
elsif (m!quarterdeck!o)					{ return 'QuarterDeck Mosaic'; }
elsif (m!spry!o)						{ return 'Compuserve\'s SPRY Mosaic'; }
elsif (m!enhanced_mosaic!o)				{ return 'NCSA Mosaic (Enhanced)'; }
elsif (m!mosaic!o)					{ return 'NCSA Mosaic'; }
elsif (m!prodigy!o)					{ return 'Prodigy\'s Browser'; }
else								{ return 'Unknown/Other'; }
} # end sub get_browser_ver


sub get_os_type {
	local $_ = defined($_[0]) ? lc($_[0]) : '';
	return 'Unknown Platform' unless $_;

	if (m!(win95)|(windows 95)!o) {
		return 'Windows 95';
		}
	elsif (m!(win 9x 4.9|windows millennium|windows me)!o) {
		return 'Windows ME';
		}
	elsif (m!(win98)|(windows 98)!o) {
		return 'Windows 98';
		}
	elsif (m!windows (nt 5\.1|xp)!o) {
		return 'Windows XP';
		}
	elsif (m!windows (nt 5|2000)!o) {
		return 'Windows 2000';
		}
	elsif (m!(windows nt)|(winnt)!o) {
		return 'Windows NT';
		}
	elsif (m!win16!o) {
		return 'Windows 16-bit';
		}
	elsif (m!win32!o) {
		return 'Windows 32-bit';
		}
	elsif (m!windows 3.1!o) {
		return 'Windows 3.1';
		}
	elsif (m!windows!o) {
		if (m!32bit!o) {
			return 'Windows 32-bit';
			}
		else {
			return 'Windows 16-bit';
			}
		}
	elsif (m!window!o) {
		return 'X Windows';
		}
	elsif (m!mac!o) {
		if (m!(ppc)|(powerpc)!o) {
			return 'Macintosh (PowerPC)';
			}
		else {
			return 'Macintosh (68K)';
			}
		}
	elsif (m!freebsd!o) {
		return 'UNIX (FreeBSD)';
		}
	elsif (m!hp-ux!o) {
		return 'UNIX (HP-UX)';
		}
	elsif (m!linux!o) {
		return 'UNIX (Linux)';
		}
	elsif (m!sunos!o) {
		return 'UNIX (SunOS)';
		}
	elsif (m!(x11)|(lynx)!o) {
		return 'UNIX (Unknown/Other)';
		}
	elsif (m!amiga!o) {
		return 'Amiga';
		}
	elsif (m!os/2!o) {
		return 'OS/2';
		}
	elsif (m!iweng!o) {
		return 'Windows 16-bit';
		}
	elsif (m!webtv!o) {
		return 'WebTV';
		}
	else {
		return 'Unknown Platform';
		}
	}



sub quickparse {
	my ($str) = @_;
	my %hash = ();
	my $pair = '';
	foreach $pair (split(m!\&!s, $str)) {
		next unless ($pair =~ m!^(.*?)=(.*)$!s);
		$hash{$1} = &url_decode($2);
		}
	return %hash;
	}




=item url_format

Usage:
	$str = &url_format($str);

Takes a URL and turns it into a hyperlink with an abbreviated (no "http://") viewable output.  Links from Altavista and other search engines are formatted logically.

Has dependencies on global variables:

	%LocalAddressTitlePairs
	$UseLocalAddressTitlePairs
	$const{'truncated_keys'}
	$PREF{'MaxChars'}
	$PREF{'My_Web_Address'}

Calls:

	&url_decode();
	&quickparse();

=cut

sub url_format {

	my ($host, $tld, $data, $start, $end, $terms, $Host, $Domain, $Terms, $Rank, $Increment);

	local $_ = $_[0] || '';
	if ((m!$PREF{'My_Web_Address'}!i) and (m!^http://(.*)!i) and (not m!^http://images.google.com/!)) {
		# Use %LocalAddressTitlePairs if it exists:
		#fixed 0026
		if ($UseLocalAddressTitlePairs == 1) {
			if (defined($LocalAddressTitlePairs{$_})) {
				return qq!<a href="$_"$const{'a_target_attrib'}>$LocalAddressTitlePairs{$_}</a>!;
				}
			}
		my $stub = $1;
		if (($PREF{'MaxChars'}) and (length($stub) > $PREF{'MaxChars'})) {
			$stub = substr($stub, 0, $PREF{'MaxChars'});
			$const{'truncated_keys'}++;
			}
		return $stub;
		}

	my %hash = ();

	my ($linktext, $trailtext) = ($_, '');

	if (($_ !~ m!\?!) and (m!^http://(.*)$!i)) {
		$linktext = $1;
		}
	elsif ($_ !~ m!\?!) {
		#def
		}

	#changed 0033 -- support google image search
	elsif (m!://images\.google\.([^/]+)/\w+\?(.*)$!i) {
		($host, $tld, $data) = ('images', $1, $2);
		%hash = &quickparse( $data );
		$hash{'prev'} =~ s!^.*\?!!;
		%hash = &quickparse( $hash{'prev'} );
		$terms = $hash{'q'};
		$start = $hash{'start'} || 0;
		$end = $start + 20;
		$start++;
		($linktext, $trailtext) = ( "$host.google.$tld", "$terms $start-$end" );
		}
	elsif (m!://([^/]+)\.google\.([^/]+)/\w+\?(.*)$!i) {
		($host, $tld, $data) = ($1, $2, $3);
		%hash = &quickparse( $data );
		$start = $hash{'start'} || 0;

		if ((defined($hash{'as_q'})) and (defined($hash{'as_epq'})) and (defined($hash{'as_oq'}))) {
			$terms = qq!$hash{'as_q'} $hash{'as_epq'} $hash{'as_oq'}!;
			}
		else {
			$terms = $hash{'q'} || 'unknown';
			}
		if ($hash{'num'}) {
			$end = $start + $hash{'num'};
			}
		else {
			$end = $start + 10;
			}
		$start++;
		($linktext, $trailtext) = ( "$host.google.$tld", "$terms $start-$end" );
		}
	elsif (/\:\/\/([^\/]*)altavista\.([^\/|\?]*)(.*)\?.*q\=([^\&]+).*stq\=(\d+)/i) {
		($Host,$Domain,$Terms,$Rank) = ($1,$2,&url_decode($4),$5);
		($linktext, $trailtext) = ( $Host . "altavista.$Domain", "$Terms ".($Rank+1).'-'.($Rank+10) );
		}
	elsif (/\:\/\/([^\/]*)altavista\.([^\/|\?]*)(.*)\?.*q=([^\&]+).*navig(\d+)?/i) {
		($Host,$Domain,$Terms,$Rank) = ($1,$2,&url_decode($4),($5?$5:0));
		($linktext, $trailtext) = ( $Host . "altavista.$Domain", "$Terms ".($Rank+1).'-'.($Rank+10) );
		}
	elsif (/\:\/\/([^\/]*)altavista\.([^\/|\?]*)(.*)\?.*q\=([^\&]+)/i) {
		($Host,$Domain,$Terms) = ($1,$2,&url_decode($4));
		($linktext, $trailtext) = ( $Host . "altavista.$Domain", "$Terms 1-10" );
		}
	elsif (/\:\/\/([^\/]*)webcrawler\.([^\/]+)(.*)\?(s|search|searchText)\=([^\&]+).*\&start\=(\d+).*perPage\=(\d+)/i) {
		($Host,$Domain,$Terms,$Rank,$Increment) = ($1,$2,&url_decode($5),$6,$7);
		($linktext, $trailtext) = ( $Host . "webcrawler.$Domain" , "$Terms ".($Rank+1)."-".($Rank+$Increment) );
		}
	elsif (/\:\/\/([^\/]*)webcrawler\.([^\/]+).*(s|search|searchText)\=([^\&]+)/i) {
		($Host,$Domain,$Terms) = ($1,$2,&url_decode($4));
		($linktext, $trailtext) = ( $Host . "webcrawler.$Domain", "$Terms 1-25" );
		}
	elsif (/\:\/\/([^\/]*)metacrawler\.([^\/]+).*general\=([^\&]+).*start\=(\d+).*rpp\=(\d+)/i) {
		($Host,$Domain,$Terms,$Rank,$Increment) = ($1,$2,&url_decode($3),$4,$5);
		($linktext, $trailtext) = ( $Host . "metacrawler.$Domain", "$Terms ".($Rank+1)."-".($Rank+$Increment) );
		}
	elsif (/\:\/\/([^\/]*)metacrawler\.([^\/]+).*general\=([^\&]+)/i) {
		($Host,$Domain,$Terms) = ($1,$2,&url_decode($3));
		($linktext, $trailtext) = ( $Host . "metacrawler.$Domain", "$Terms 1-25" );
		}
	elsif (/\:\/\/([^\/]*)netfind.aol\.([^\/]+).*start=(\d+).*&search=([^\&]+).*start=(\d+).*perPage=(\d+)/i) {
		($Host,$Domain,$Terms,$Rank,$Increment) = ($1,$2,&url_decode($5),$4,$6);
		($linktext, $trailtext) = ( $Host . "netfind.aol.$Domain", "$Terms ".($Rank+1)."-".($Rank+$Increment) );
		}
	elsif (/\:\/\/([^\/]*)netfind\.aol\.([^\/]+).*search=([^\&]+)/i) {
		($Host,$Domain,$Terms) = ($1,$2,&url_decode($3));
		($linktext, $trailtext) = ( $Host . "netfind.aol.$Domain", "$Terms 1-25" );
		}
	elsif (/\:\/\/([^\.]*)\.infoseek\.com(.*)\?.*qt=([^\&]+).*st=(\d+)?/i) {
		($Host,$Rank,$Terms) = ($1,$5,&url_decode($3));
		($linktext, $trailtext) = ( "$Host.infoseek.com", "$Terms ".($Rank+1).'-'.($Rank+10) );
		}
	elsif (/\:\/\/([^\.]*)\.infoseek\.com(.*)\?.*qt=([^\&]+)/i) {
		($Host,$Terms) = ($1,&url_decode($3));
		($linktext, $trailtext) = ( "$Host.infoseek.com", "$Terms 1-10" );
		}
	elsif (/\:\/\/([^\.]*)\.infoseek\.com(.*)\?.*oq=([^\&]+).*(st=)?(\d+)?/i) {
		($Host,$Rank,$Terms) = ($1,$5,&url_decode($3));
		($linktext, $trailtext) = ( "$Host.infoseek.com", "$Terms ".($Rank+1).'-'.($Rank+10) );
		}
	elsif (/\:\/\/([^\.]*)\.infoseek\.com(.*)\?.*oq=([^\&]+).*(st=)?(\d+)?/i) {
		($Host,$Terms) = ($1,&url_decode($3));
		($linktext, $trailtext) = ( "$Host.infoseek.com", "$Terms 1-10" );
		}
	elsif (/\:\/\/([^\.]*)\.excite\.com(.*)\?(.*)/i) {
		($Host,$Rank,$Increment) = ($1,0,10);
		my @parts = split(/\&/,$3);
		my $part;
		foreach $part (@parts) {
			if ($part =~ /^search=(.*)/) {
				$terms = $1;
				$terms =~ tr/+/ /;
				$terms =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C',hex($1))/eg;
				}
			if ($part =~ /^perPage=(.*)/) {
				$Increment = $1;
				}
			if ($part =~ /^start=(.*)/) {
				$Rank = ($1 + $Increment);
				}
			}
		($linktext, $trailtext) = ( "$Host.excite.com", "$terms " . ($Rank + 1) . "-" . ($Rank + $Increment) );
		}
	elsif (m!^http://([^/]+)\.yahoo\.com([^/]*)/.*?\?(.+)$!i) {

		#Yahoo parse changed 0038

		$linktext = lc("$1.yahoo.com$2");
		%hash = &quickparse($3);

		my $pos_start = 1;

		if ((exists $hash{'b'}) and ($hash{'b'} =~ m!^\d+$!) and ($hash{'b'} > 0)) {
			$pos_start = 1 * $hash{'b'};
			}

		my $pos_end;
		if ((exists $hash{'n'}) and ($hash{'n'} =~ m!^\d+$!) and ($hash{'n'} > 0)) {
			$pos_end = $pos_start + $hash{'n'} - 1;
			}
		else {
			$pos_end = $pos_start + 19;
			}

		if (exists $hash{'p'}) {
			$terms = $hash{'p'};
			}
		elsif (
			(exists $hash{'va'})
			or
			(exists $hash{'vo'})
			or
			(exists $hash{'vp'})
			or
			(exists $hash{'ve'})
			) {
			$terms = join( ' ', $hash{'va'} || '', $hash{'vo'} || '', $hash{'ve'} || '' );
			$terms =~ s!\s+! !sg; # strip/compress whitespace
			$terms =~ s!(^ | $)!!g;
			if ((exists $hash{'vp'}) and (length($hash{'vp'}))) { # append phrase-search component as double-quoted string
				$terms .= qq! "$hash{'vp'}"!;
				}
			}
		else {
			$pos_start = $pos_end = 0; # failed match; reset
			}


		$trailtext = $terms;
		if (($pos_start) and ($pos_end)) {
			$trailtext .= " $pos_start-$pos_end";
			}

		}

	#changed 0026
	elsif (m!^http://([^/]+\.)?hotbot\.([^/]+)/.*?\?(MT|query)=([^\&]+)(\&|$)!) {
		my $host = $1 . 'hotbot.' . $2;
		my $query = &url_decode($4);
		my $range = '1-10';
		if (m!base=(\d+)!) {
			$range = ($1 + 11) . '-' . ($1 + 20);
			}
		($linktext, $trailtext) = ( $host, "$query $range" );
		}
	elsif (m!^http://([^/]+\.)?hotbot\.([^/]+)/.*?\?.*?\&(MT|query)=([^\&]+)(\&|$)!) {
		my $host = $1 . 'hotbot.' . $2;
		my $query = &url_decode($4);
		my $range = '1-10';
		if (m!base=(\d+)!) {
			$range = ($1 + 11) . '-' . ($1 + 20);
			}
		($linktext, $trailtext) = ( $host, "$query $range" );
		}


	#changed 0026
	elsif (m!^http://([^/]+)/(.*?)\?(.+)$!) {
		my ($host, $path, $query) = ($1, $2, $3);
		if (($host =~ m!search!) or ($path =~ m!search!)) {
			if ($query =~ m!(^|&)q=([^\&]+)!) {
				($linktext, $trailtext) = ( $host, &url_decode($2) );
				}
			elsif ($query =~ m!(^|&)query=([^\&]+)!) {
				($linktext, $trailtext) = ( $host, &url_decode($2) );
				}
			}
		}

	$linktext =~ s!^http://!!i; # changed 0026

	if (($PREF{'MaxChars'}) and (length($linktext) > $PREF{'MaxChars'})) {
		$linktext = substr( $linktext, 0, $PREF{'MaxChars'} );
		$const{'truncated_keys'}++;
		}

	if ($trailtext) {

		if (($PREF{'MaxChars'}) and (length($trailtext) > $PREF{'MaxChars'})) {
			$trailtext = substr( $trailtext, 0, $PREF{'MaxChars'} );
			$const{'truncated_keys'}++;
			}


		return '<a href="' . $_ . '"' . $const{'a_target_attrib'} . '>' . &html_encode($linktext) . '</a> <i>' . &html_encode($trailtext) . '</i>';
		}
	else {
		return '<a href="' . $_ . '"' . $const{'a_target_attrib'} . '>' . &html_encode($linktext) . '</a>';
		}
	};



=item AuthPref

Usage:
	($err, $b_is_login, %PREF) = &AuthPref( $prefs_file );

=cut

sub AuthPref {
	my ($PrefsFile) = @_;
	my $b_is_login = 0;
	my $err = '';
	Err: {
		local $_;

		# Try to open the prefs file:
		unless (open(PREF, "<$PrefsFile")) {
			$err = "unable to open file '$PrefsFile' for reading - $!";
			next Err;
			}
		binmode(PREF);

		# Initialize $PREF{'format'} and {'maximum'}
		%PREF = (
			'format', '',
			'maximum', '',
			'end_date', '',
			'start_date', '',
			'since_last', '',
			'last_number', '',
			'last_number_temp', '',
			'AuthIP', '',
			'last_string', '',
			'MaxWidth', 400,
			'MaxChars', 128,
			'show_uri_warning' => 1,

			'My_Web_Address' => &query_env('HTTP_HOST'),

			'images_folder' => 'http://xav.com/i/',
			'Filter', '',
			'recent', '',
			'NumSort', 'CHECKED',
			'NewWindow', 'CHECKED',
			'Highlight', 'CHECKED',
			'HideDefaultDoc', 'CHECKED',
			'ListingsPerPage', 500,
			'HideQueryStrings','',
			'UseMilTime', '',

			's02a' => 'CHECKED',
			's04'  => 'CHECKED',
			's08'  => 'CHECKED',
			's11'  => 'CHECKED',
			's14'  => 'CHECKED',

			);


		while (defined($_ = <PREF>)) {
			next unless (m!^([^\|]+)\|([^\|]*)!);
			$PREF{&url_decode($1)} = &url_decode($2);
			}
		close(PREF);

		# Now authenticate this user:
		AUTH: {
			if (($AllowAnonymousForGraphs == 1) and ($FORM{'Target'} ne 'Preferences') and (!$FORM{'terminate'})) {
				$b_is_login = 1;
				last AUTH;
				}
			if (&query_env('REMOTE_ADDR') eq $PREF{'AuthIP'}) {
				$b_is_login = 1;
				last AUTH;
				}
			if (($Password eq ($FORM{'password'} || '')) and ($Username eq ($FORM{'username'} || ''))) {
				$PREF{'AuthIP'} = &query_env('REMOTE_ADDR');
				$b_is_login = 1;
				last AUTH;
				}
			if (($FORM{'password'}) || ($FORM{'username'})) {
				print "<p>Invalid username or password.</p>\n";
				print "<a href=\"$This_Script_Address\">feel free to try again...</a>\n";
				}
			else {
				print &Authenticate;
				}
			last Err;
			}

		# User authenticated, continue parsing the preferences.  Save them if
		# necessary:
		my $ThisDayNum = ($MyT[5] * 1000) + $MyT[7] + 1900000;
		if (($PREF{'last_number_temp'}) and (($PREF{'last_number_temp'} < $ThisDayNum) or (not $PREF{'last_number'}))) {
			$PREF{'last_number'} = $PREF{'last_number_temp'};
			$PREF{'last_string'} = $PREF{'last_string_temp'};
			}
		$PREF{'last_number_temp'} = $ThisDayNum;
		$PREF{'last_string_temp'} = (&DateByNum((@MyT)[4,3],$MyT[5]+1900))[0];
		if ($FORM{'incoming'}) {
			if ($const{'is_demo'}) {
				$err = "the saving of preferences has been disabled in the on-line demo";
				next Err;
				}

			#changed 0031
			if (defined($FORM{'ListingsPerPage'})) {
				if ($FORM{'ListingsPerPage'} !~ m!^\d+$!) {
					$err = "the ListingsPerPage setting must be an integer";
					next Err;
					}
				}

			$FORM{'images_folder'} = &Trim($FORM{'images_folder'});
			$FORM{'images_folder'} .= '/' unless ($FORM{'images_folder'} =~ m!/$!); #changed 0025
			for ('maximum','MaxWidth','MaxChars','My_Web_Address','start_date','end_date','Filter','format', 'images_folder','ListingsPerPage', 'show_uri_warning') {
				$PREF{$_} = $FORM{$_};
				delete $FORM{$_};
				}
			for (keys %GraphOptions,'since_last','recent','NumSort','NewWindow','Highlight','HideDefaultDoc','HideQueryStrings', 'UseMilTime') {
				$PREF{$_} = $FORM{$_} ? 'CHECKED' : '';
				delete $FORM{$_};
				}
			}
		$PREF{'MaxWidth'} = 400 unless ($PREF{'MaxWidth'});

		#changed 0031
		if ((defined($PREF{'ListingsPerPage'})) and ($PREF{'ListingsPerPage'} !~ m!^\d+$!)) {
			$PREF{'ListingsPerPage'} = 0;
			}

		# abbreviated flag for numerical sorting:
		$const{'use_numeric_sort'} = $PREF{'NumSort'} eq 'CHECKED' ? 1 : 0;
		# abbreviate bgcolor attribute:
		if ($PREF{'Highlight'} eq 'CHECKED') {
			$const{'bgcolor'} = 'bgcolor="#dddddd"';
			}
		else {
			$const{'bgcolor'} = '';
			}
		if ($PREF{'NewWindow'}) {
			$const{'a_target_attrib'} = ' target="_blank"';
			}
		else {
			$const{'a_target_attrib'} = '';
			}
		if (($ENV{'REMOTE_ADDR'}) and ($ENV{'REMOTE_ADDR'} eq $PREF{'AuthIP'})) {
			# only write out preferences for authenticated users:
			my $text = '';

			my $key;
			foreach $key (sort keys %PREF) {
				next if (($key eq 'AuthIP') and ($FORM{'Target'}) and ($FORM{'Target'} eq 'LogOut'));
				my $value = defined($PREF{$key}) ? $PREF{$key} : '';
				$text .= &url_encode($key) . '|' . &url_encode($value) . "|\n";
				}
			$err = &WriteFile( $prefs, $text );
			next Err if ($err);
			}
		last Err;
		}
	return ($err, $b_is_login, %PREF);
	}


sub DateIsValid {
	my ($MM,$DD,$YYYY) = @_;
	for ($MM,$DD,$YYYY) {
		return 0 unless m!^\d*$!;
		}
	return 0 if (($MM < 1) || ($MM > 12) || ($DD < 1));
	if ($YYYY % 4) {
		return 0 if ($DD > (31,29,31,30,31,30,31,31,30,31,30,31)[$MM-1]);
		}
	else {
		return 0 if ($DD > (31,28,31,30,31,30,31,31,30,31,30,31)[$MM-1]);
		}
	return 1;
	}

sub GetYDAY {
	my ($MM,$DD,$YYYY) = @_;
	if (($YYYY % 4) == 0) {
		return ((0,31,60,91,121,152,182,213,244,274,305,335)[$MM] + $DD - 1);
		}
	else {
		return ((0,31,59,90,120,151,181,212,243,273,304,334)[$MM] + $DD - 1);
		}
	}

sub DateByNum {
# this is failing for YDAY sometimes.

	# accepts computer date, returns text string, yday.
	my ($MM, $DD, $YYYY) = @_;

	# test:
	# print "<!-- DateByNum $MM $DD $YYYY -->\n";

	$DD--;$DD++;
	if ($YYYY < 1000) {
		if ($YYYY < 50) {
			$YYYY += 2000;
			}
		else {
			$YYYY += 1900;
			}
		}
	my $YDAY = &GetYDAY($MM,$DD,$YYYY);
	my $DaysSince1970 = int(($YYYY-1970)*365.25) + $YDAY + 1;
	my $WeekDay = $LongWeekDays[(localtime($DaysSince1970 * 86400))[6]];

	# test:
	# print "<!-- resolves to $WeekDay with YDAY as $YDAY -->\n";

	return ("$LongMonths[$MM] $DD, $YYYY", $YDAY);
	}

sub FormatDates {
	my ($StartInput, $EndInput, $Recent, $SinceLast, $LastNumber) = @_;
	my ($v_start_number, $v_start_string, $v_end_number, $v_end_string) = (0,'',0,'');

	#changed 0034
	if (($StartInput) or ($EndInput)) {
		$Recent = '';
		$SinceLast = '';
		}

	my ($MM,$DD,$YYYY) = (0,0,0);
	MMDDYY: for ($StartInput) {
		if ($_) {
			if (m!^\s*(\d{2,2})\D*(\d{2,2})\D*(\d{2,4})?!) {
				($MM,$DD,$YYYY) = ($1,$2,($3 ? $3 : $MyT[5]));
				last MMDDYY if &DateIsValid($MM,$DD,$YYYY);
				}
			if (m!^\s*(\d{1,2})\D+(\d{1,2})\D*(\d{2,4})?!) {
				($MM,$DD,$YYYY) = ($1,$2,($3?$3:$MyT[5]));
				last MMDDYY if &DateIsValid($MM,$DD,$YYYY);
				}
			LITERAL_MONTH: {
				my $MonthString = '';
				if (m!^\s*(\D+)(\d{1,2})\D*(\d{2,4})?!) {
					($MonthString,$DD,$YYYY) = ($1,$2,($3?$3:$MyT[5]));
					}
				elsif (m!^\s*(\d{1,2})(\D*)(\d{2,4})?!) {
					($MonthString,$DD,$YYYY) = ($2,$1,($3?$3:$MyT[5]));
					}
				else {
					last LITERAL_MONTH;
					}
				for ($MM=1;$MM<=12;$MM++) {
					if ($MonthString =~ m!$ShortMonths[$MM-1]!i) {
						last MMDDYY if &DateIsValid($MM,$DD,$YYYY);
						last LITERAL_MONTH;
						}
					}
				}
			my $X;
			for $X (0..6) {
				if (m!$ShortWeekDays[$X]!i) {
					($MM,$DD,$YYYY) = (localtime(time-((7+$MyT[6]-$X)%7)*86400))[4,3,5];
					$MM++;
					last MMDDYY;
					}
				}
			for $X (0..2) {
				if (m!$ShortDayNames[$X]!i) {
					($MM,$DD,$YYYY) = (localtime(time+($X-1)*86400))[4,3,5];
					$MM++;
					last MMDDYY;
					}
				}
			}
		if ($Recent) {
			($MM,$DD,$YYYY) = (localtime((time-86400)))[4,3,5];
			$MM++;
			last MMDDYY;
			}
		} # End MMDDYY.

	if ($MM and $DD and defined($YYYY)) {
		# kick INT mode, and correct for human->computer month indexing:
		$MM--;

		if ($YYYY < 1000) {
			# User is entering an abbreviated date.  Is it 01 for 2001, or 99 for 1999?
			if ($YYYY < 50) {
				$YYYY += 2000;
				}
			else {
				$YYYY += 1900;
				}
			}

		my $YDAY;
		($v_start_string,$YDAY) = &DateByNum($MM,$DD,$YYYY);
		$v_start_number = ($YYYY * 1000) + $YDAY;
		}
	elsif ($SinceLast) {
	# or "if $StartInput existed maybe but didn't successfully match anything, and $Recent was not defined,
	# but $SinceLast is...
		$v_start_number = $LastNumber;
		$YYYY = int($LastNumber/1000);
		my $YDAY = $LastNumber % 1000;
		my $DaysSince1970 = int(($YYYY-1970)*365.25) + $YDAY + 1;
		my $WeekDay;
		($DD,$MM,$YYYY,$WeekDay) = (localtime($DaysSince1970 * 86400))[3..6];
		$YYYY += 1900;
		$v_start_string = "$LongWeekDays[$WeekDay], $LongMonths[$MM] $DD, $YYYY";
		}

	# Zero out:
	($MM,$DD,$YYYY) = (0,0,0);
	MMDDYY: for ($EndInput) {
		if ($_) {
			if (m!^\s*(\d{2,2})\D*(\d{2,2})\D*(\d{2,4})?!) {
				($MM,$DD,$YYYY) = ($1,$2,($3?$3:$MyT[5]));
				last MMDDYY if &DateIsValid($MM,$DD,$YYYY);
				}
			if (m!^\s*(\d{1,2})\D+(\d{1,2})\D*(\d{2,4})?!) {
				($MM,$DD,$YYYY) = ($1,$2,($3?$3:$MyT[5]));
				last MMDDYY if &DateIsValid($MM,$DD,$YYYY);
				}
			LITERAL_MONTH: {
				my $MonthString;
				if (m!^\s*(\D+)(\d{1,2})\D*(\d{2,4})?!) {
					($MonthString,$DD,$YYYY) = ($1,$2,($3?$3:$MyT[5]));
					}
				elsif (m!^\s*(\d{1,2})(\D*)(\d{2,4})?!) {
					($MonthString,$DD,$YYYY) = ($2,$1,($3?$3:$MyT[5]));
					}
				else {
					last LITERAL_MONTH;
					}
				for ($MM=1;$MM<=12;$MM++) {
					if ($MonthString =~ m!$ShortMonths[$MM-1]!i) {
						last MMDDYY if &DateIsValid($MM,$DD,$YYYY);
						last LITERAL_MONTH;
						}
					}
				}
			my $X;
			for $X (0..6) {
				if (m!$ShortWeekDays[$X]!i) {
					($MM,$DD,$YYYY) = (localtime(time-((7+$MyT[6]-$X)%7)*86400))[4,3,5];
					$MM++;
					last MMDDYY;
					}
				}
			for $X (0..2) {
				if (m!$ShortDayNames[$X]!i) {
					($MM,$DD,$YYYY) = (localtime(time+($X-1)*86400))[4,3,5];
					$MM++;
					last MMDDYY;
					}
				}
			}

		if ($Recent || $SinceLast) {
			($MM,$DD,$YYYY) = (localtime(time))[4,3,5];
			$MM++;
			last MMDDYY;
			}
		} # End MMDDYY.

	if ($MM and $DD and defined($YYYY)) {
		# kick INT mode, and correct for human->computer month indexing:
		$MM--;

		if ($YYYY < 1000) {
			# User is entering an abbreviated date.  Is it 01 for 2001, or 99 for 1999?
			if ($YYYY < 50) {
				$YYYY += 2000;
				}
			else {
				$YYYY += 1900;
				}
			}

		my $YDAY;
		($v_end_string,$YDAY) = &DateByNum($MM,$DD,$YYYY);
		unless ($Recent || $SinceLast) {
			$v_end_number = ($YYYY * 1000) + $YDAY;
			}
		}
	return ($v_start_number, $v_start_string, $v_end_number, $v_end_string);
	}


=item PrintDebugInfo()

Usage:
	$err = &PrintDebugInfo( $b_verbose, $b_AllowDebug );
	next Err if ($err);

This runs a filesystem test against $LogFile and dumps a ton of (hopefully) useful information to the screen.

=cut

sub PrintDebugInfo {
	my ($verbose, $b_AllowDebug) = @_;

	my ($err, $b_is_done) = ('', 1);
	Err: {

		unless ($b_AllowDebug) {
			$err = "permission denied; the AllowDebug variable has been set to zero";
			next Err;
			}

print <<"EOM";

<div class="indent">

<p>Testing log file '$LogFile'...</p>

EOM

		if (-e $LogFile) {
			print "<p>File exists.</p>\n";
			}
		else {
			print "<p>Warning: file does not exist.</p>\n";
			}

		if (open(FILE,">>$LogFile")) {
			binmode(FILE);
			close(FILE);
			print "<p><b>Success:</b> log file is writable.</p>\n";
			}
		else {
			print "<p><b>Error:</b> unable to write to the log file - $! - $^E.</p>\n";
			print "<p>Resolve this error by creating an empty file named '$LogFile' (if one doesn't already exist) and making it writable.</p>\n";
			}

		print "<p>Testing preferences file '$prefs'...</p>\n";

		if (-e $prefs) {
			print "<p>File exists.</p>\n";
			}
		else {
			print "<p>Warning: file does not exist.</p>\n";
			}

		if (open(FILE,">>$prefs")) {
			binmode(FILE);
			close(FILE);
			print "<p><b>Success:</b> prefs file is writable.</p>\n";
			}
		else {
			print "<p><b>Error:</b> unable to write to the prefs file - $! - $^E.</p>\n";
			print "<p>Resolve this error by creating an empty file named '$prefs' (if one doesn't already exist) and making it writable.</p>\n";
			}

		last Err unless ($verbose);

print <<"EOM";

<p><b>Server Information</b></p>

<table border="1" cellspacing="0" cellpadding="4" class="indent">
<tr>
	<td class="label"><b>Script Version:</b></td>
	<td>$VERSION</td>
</tr>
<tr>
	<td class="label">Script file:</td>
	<td>$0</td>
</tr>
<tr>
	<td class="label">Perl version:</td>
	<td>$]</td>
</tr>
<tr>
	<td class="label">Operating system:</td>
	<td>$^O</td>
</tr>
</table>

<p><b>Environment Variables</b></p>

<table border="1" cellspacing="0" cellpadding="4" class="indent">

EOM

foreach (sort keys %ENV) {
	print qq!<tr><td class="label">! . &html_encode($_) . ":</td><td>" . &html_encode(substr($ENV{$_},0,60)) . "<br /></td></tr>\n";
	}

print <<"EOM";

</table>

<p><br /></p>

</div>

EOM
		last Err;
		}
	return ($err, $b_is_done);
	};



sub AddCommas {
	$_ = reverse shift;
	s!(\d{3,3})!$1,!g;
	$_ = reverse $_;
	s!^,!!o;
	return $_;
	}

=item check_regex

Usage:
	$err = &check_regex($pattern);

Checks against ?{} code-executing expressions.

Uses an eval wrapper to confirm that the expression is valid.

updated 2001-09-28

=cut

sub check_regex {
	my ($pattern) = @_;
	my $err = '';
	Err: {
		if ($pattern =~ m!\?\{!) {
			$err = 'query pattern "' . &html_encode($pattern) . '" contains illegal ?{} code-executing regular expression';
			next Err;
			}
		eval '"foo" =~ m!$pattern!;';
		if ($@) {
			$err = 'unable to evaluate pattern "' . &html_encode($pattern) . '" - ' . &html_encode($@);
			undef($@);
			next Err;
			}
		}
	return $err;
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
	if ('POST' eq &query_env('REQUEST_METHOD')) {
		my $buffer = '';
		my $len = &query_env('CONTENT_LENGTH',0);
		read(STDIN, $buffer, $len);
		@Pairs = split(m!\&!, $buffer);
		}
	elsif (&query_env('QUERY_STRING')) {
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


=item Trim

Usage:

	my $word = &Trim("  word  \t\n");

Strips whitespace and line breaks from the beginning and end of the argument.

=cut

sub Trim {
	local $_ = defined($_[0]) ? $_[0] : '';
	s!^[\r\n\s]+!!o;
	s![\r\n\s]+$!!o;
	return $_;
	}





sub Assert {
	return if ($_[0]);
	my ($package, $file, $line) = caller();
	print "HTTP/1.0 200 OK\015\012" if $::private{'PRINT_HTTP_STATUS_HEADER'};
	print "Content-Type: text/html\015\012\015\012";
	print "<HR><H1><pre>Assertion Error:<br />	Package: $package<br />	File: $file<br />	Line: $line</pre></H1><HR>";
	}




sub SetDefaults {
	my ($text, $p_params) = @_;

	# short-circuit:
	if ((ref($p_params) ne 'HASH') or (not (%$p_params))) {
		return $text;
		}


	my @array = split(m!<(INPUT|SELECT|TEXTAREA)([^\>]+?)\>!is, $text);

	my $finaltext = $array[0];

	my $setval;

	my $x = 1;
	for ($x = 1; $x < $#array; $x += 3) {

		my ($uctag, $origtag, $attribs, $trail) = (uc($array[$x]), $array[$x], $array[$x+1] || '', $array[$x+2] || '');

		Tweak: {

			my $tag_name = '';
			if ($attribs =~ m! NAME\s*=\s*\"([^\"]+?)\"!is) {
				$tag_name = $1;
				}
			elsif ($attribs =~ m! NAME\s*=\s*(\S+)!is) {
				$tag_name = $1;
				}
			else {

				# we cannot modify what we do not understand:
				last Tweak;
				}
			last Tweak unless (defined($$p_params{$tag_name}));
			$setval = &he($$p_params{$tag_name});


			if ($uctag eq 'INPUT') {

				# discover VALUE and TYPE
				my $type = 'TEXT';
				if ($attribs =~ m! TYPE\s*=\s*\"([^\"]+?)\"!is) {
					$type = uc($1);
					}
				elsif ($attribs =~ m! TYPE\s*=\s*(\S+)!is) {
					$type = uc($1);
					}

				# discover VALUE and TYPE
				my $value = '';
				if ($attribs =~ m! VALUE\s*=\s*\"([^\"]+?)\"!is) {
					$value = $1;
					}
				elsif ($attribs =~ m! VALUE\s*=\s*(\S+)!is) {
					$value = $1;
					}

				# we can only set values for known types:

				if (($type eq 'RADIO') or ($type eq 'CHECKBOX')) {

					#changed 2001-11-15; strip pre-existing checks
					$attribs =~ s! (checked="checked"|checked)($| )!$2!ois;

					if ($setval eq $value) {
						$attribs = qq! checked="checked"$attribs!;
						}

					}
				elsif (($type eq 'TEXT') or ($type eq 'PASSWORD') or ($type eq 'HIDDEN')) {

					# but only hidden fields if value is null:

					last Tweak if (($type eq 'HIDDEN') and ($value ne ''));

					# replace any existing VALUE tag:
					my $qm_value = quotemeta($value);
					$attribs =~ s! value\s*=\s*\"$qm_value\"! value="$setval"!iso;
					$attribs =~ s! value\s*=\s*$qm_value! value="$setval"!iso;

					# add the tag if it's not present (i.e. if no VALUE was present in original tag)
					my $qm_setval = quotemeta($setval);
					unless ($attribs =~ m! VALUE="$qm_setval"!is) {
						$attribs = " value=\"$setval\"$attribs";
						}

					}
				}
			elsif ($uctag eq 'SELECT') {

# does not support <OPTION>value syntax, only <OPTION VALUE="value">value

				my $lc_set_value = lc($setval);

				my @frags = ();
				foreach (split(m!<option!is, $trail)) {

					#changed 2001-11-15; strip pre-existing "selected"
					$_ =~ s! (selected|selected="selected")($| )!$2!ois;

					if (m!VALUE\s*=\s*\"(.*?)\"!is) {
						if ($lc_set_value eq lc($1)) {
							$_ = ' selected="selected"' . $_;
							}
						}
					elsif (m!VALUE\s*=\s*(\S+)!is) {
						if ($lc_set_value eq lc($1)) {
							$_ = ' selected="selected"' . $_;
							}
						}
					push(@frags, $_);
					}
				$trail = join('<option', @frags);
				}
			elsif ($uctag eq 'TEXTAREA') {
				$trail =~ s!^.*?</(textarea)>!$setval</$1>!osi;
				}
			last Tweak;
			}

		$finaltext .= "<$origtag$attribs>$trail";
		}
	return $finaltext;
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




=item url_encode

Usage:
	my $str_url = &url_encode($str);

Formats strings consistent with RFC 1945 by rewriting metacharacters in their
%HH format.

=cut

sub url_encode {
	local $_ = defined($_[0]) ? $_[0] : '';
	s!([^a-zA-Z0-9_.-])!uc(sprintf("%%%02x", ord($1)))!eg;
	return $_;
	}
sub WriteFile {
	my ($file, $text) = @_;
	my $err = '';
	Err: {
		unless (defined($file)) {
			$err = "invalid argument - 'file' parameter not defined";
			next Err;
			}
		unless (defined($text)) {
			$err = "invalid argument - 'text' parameter not defined";
			next Err;
			}
		unless (open(FILE, ">$file")) {
			$err = "unable to write to file '$file' - $!";
			next Err;
			}
		unless (binmode(FILE)) {
			$err = "unable to set binmode on file '$file' - $!";
			close(FILE);
			next Err;
			}
		unless (print FILE $text) {
			$err = "error occurred while writing to file '$file' - $! - $^E";
			close(FILE);
			next Err;
			}
		unless (close(FILE)) {
			$err = "unable to close file '$file' - $! - $^E";
			next Err;
			}
		last Err;
		}
	return $err;
	};

END_OF_CODE

sub html_encode {
	local $_ = $_[0] || '';
	s!\&!\&amp;!g;
	s!\>!\&gt;!g;
	s!\<!\&lt;!g;
	s!\"!\&quot;!g;
	return $_;
	}


undef($@);
eval $all_code;
my $err = &html_encode($@); #typecast to str
if ($err) {
	print "HTTP/1.0 200 OK\015\012" if $::private{'PRINT_HTTP_STATUS_HEADER'};
	print "Content-Type: text/html\015\012\015\012";
	print "<hr /><p><b>Perl Execution Error</b> in $0:</p><blockquote><tt>$err</tt></blockquote>";
print <<"EOM";

<form method="post" action="http://www.xav.com/bug.pl">
<input type=hidden name="product" value="axs" />
<input type=hidden name="version" value="$VERSION" />
<input type=hidden name="Perl Version" value="$]" />
<input type=hidden name="Script Path" value="$0" />
<input type=hidden name="Perl Error" value="$err" />
EOM

my $name;
foreach $name (keys %FORM) {
	my $value = &html_encode($FORM{$name});
	$name = &html_encode($name);
	print qq!<input type="hidden" name="Form: $name" value="$value" />\n!;
	}
print <<"EOM";

<p>Please report this error to the script author:</p>
<blockquote><input type="submit" value="Report Error" /></blockquote>
</FORM><hr />

EOM

	}
1;

