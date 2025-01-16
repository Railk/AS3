<?php

include 'google/analytics/GoogleAnalytics.php';

$user = $_POST["user"];
$pass = $_POST["pass"];
$end = $_POST["end"];

$ga = new GoogleAnalytics();
if($ga->login($user,$pass)){
		$accounts = $ga->getAccounts();
		$profiles = $ga->getSiteProfiles($accounts['railk']);
		$report = $ga->getReport( $profiles['portfolio'], '20070207', $end );
		$saved = $ga->saveReport($report, '../report.xml');
		
		echo $saved;
}

?>

