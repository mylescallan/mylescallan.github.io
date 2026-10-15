<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title>Multidimensional Arrays</title>
</head>
<body>
<p>Some North American States, Provinces, and Territories:</p>
<?php # Script 2.7 - multi.php

// Create one array:
$mexico = array(
'YU' => array('Yucatan', 'blah'),
'BC' => array('Baja California', 'blah'),
'OA' => array('Oaxaca', 'blah')
);

// Create another array:
$us = array (
'MD' => array('Maryland', 'blah'),
'IL' => array('Illinois', 'blah'),
'PA' => array('Pennsylvania', 'blah'),
'IA' => array('Iowa', 'blah')
);

// Create a third array:
$canada = array (
'QC' => array('Quebec',  'blah'),
'AB' => array('Alberta'),
'NT' => array('Northwest Territories', 'blah'),
'YT' => array('Yukon', 'blah'),
'PE' => array('Prince Edward Island', 'blah')
);

//	echo "<h2>{$canada[0:1]}</h2><ul>";


// Combine the arrays:
$n_america = array(
'Mexico' => $mexico,
'United States' => $us,
'Canada' => $canada
);

// Loop through the countries:
foreach ($n_america as $country => $list) {

	// Print a heading:
	echo "<h2>$country</h2><ul>";
	
	
	// Print each state, province, or territory:
	foreach ($list as $k => $v) {
		echo "<li>$k - $v[0] ' rating is ' $v[1]</li>\n";
	}
	
	// Close the list:
	echo '</ul>';

} // End of main FOREACH.

?>
</body>
</html>