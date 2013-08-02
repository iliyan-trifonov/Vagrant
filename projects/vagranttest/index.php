<?php

echo "Hello, World! :) <br />";

$mysqli = new mysqli("localhost", "root", "root", "vagranttests");
echo "mysqli status: ";
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
echo $mysqli->host_info . "\n";

echo "<br/><br/>\n\nVisit <a href='https://github.com/Ljancho/Vagrant' target='_blank'>https://github.com/Ljancho/Vagrant</a> for more!";