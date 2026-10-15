<?php
$name=$_POST['name'];
$email=$_POST['email'];
$message=$_POST['message'];
$from='From: YourWebsite.com';
$to='feedback@mylescallan.com';
$subject='Feedback on your site';
$body="From: $name\n E-Mail: $email\n Message:\n $message";
?>
