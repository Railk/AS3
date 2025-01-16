<?php
$folder = $_POST["folder"];
$file = $_FILES["Filedata"];

if ( isset ( $file ) ) move_uploaded_file ( $file['tmp_name'], $folder.'/' .utf8_decode($file['name']));
?>