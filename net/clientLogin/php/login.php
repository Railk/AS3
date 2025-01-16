<?php
	$config = $_GET['config'];
	if (!empty($config)) {
		include( base64_decode($config) );
		
		$cfg = new Config();
		$params = array(
			'accountType' => $cfg->account,
			'Email' => $cfg->login,
			'Passwd' => $cfg->password,
			'service' => $cfg->service,
			'source' => $cfg->source,
			'headers' => $cfg->headers
		);
		echo load('https://www.google.com/accounts/ClientLogin',$params);
	}
	else echo "erreur le fichier n'existe pas"; 
	
	
	function load($url,$options=array()) {
		$default_options = array(
			'method'        => 'get',
			'return_info'    => false,
			'return_body'    => true,
			'referer'        => '',
			'headers'        => array(),
			'session'        => false,
			'session_close'    => false,
		);
		foreach($default_options as $opt=>$value) if(!isset($options[$opt])) $options[$opt] = $value;
		$url_parts = parse_url($url);
		$response = '';
		$send_header = array('Accept' => 'text/*','User-Agent' => 'BinGet/1.00.A (http://www.bin-co.com/php/scripts/load/)') + $options['headers'];
		
		if(isset($url_parts['query'])) {
			if(isset($options['method']) and $options['method'] == 'post') $page = $url_parts['path'];
			else $page = $url_parts['path'] . '?' . $url_parts['query'];
		} 
		else $page = $url_parts['path'];
		
		if(!isset($url_parts['port'])) $url_parts['port'] = 80;
		$fp = fsockopen($url_parts['host'], $url_parts['port'], $errno, $errstr, 30);
		if ($fp) {
			$out = '';
			if(isset($options['method']) and $options['method'] == 'post' and isset($url_parts['query'])) $out .= "POST $page HTTP/1.1\r\n";
			else $out .= "GET $page HTTP/1.0\r\n"; //HTTP/1.0 is much easier to handle than HTTP/1.1
			$out .= "Host: $url_parts[host]\r\n";
			$out .= "Accept: $send_header[Accept]\r\n";
			$out .= "User-Agent: {$send_header['User-Agent']}\r\n";
			if(isset($options['modified_since'])) $out .= "If-Modified-Since: ".gmdate('D, d M Y H:i:s \G\M\T',strtotime($options['modified_since'])) ."\r\n";
			$out .= "Connection: Close\r\n";
			
			if(isset($url_parts['user']) and isset($url_parts['pass'])) $out .= "Authorization: Basic ".base64_encode($url_parts['user'].':'.$url_parts['pass']) . "\r\n";

			if(isset($options['method']) and $options['method'] == 'post' and $url_parts['query']) {
				$out .= "Content-Type: application/x-www-form-urlencoded\r\n";
				$out .= 'Content-Length: ' . strlen($url_parts['query']) . "\r\n";
				$out .= "\r\n" . $url_parts['query'];
			}
			$out .= "\r\n";

			fwrite($fp, $out);
			while (!feof($fp)) $response .= fgets($fp, 128);
			fclose($fp);
		}

		$headers = array();
		if($info['http_code'] == 404) {
			$body = "";
			$headers['Status'] = 404;
		} else {
			$header_text = substr($response, 0, $info['header_size']);
			$body = substr($response, $info['header_size']);
			foreach(explode("\n",$header_text) as $line) {
				$parts = explode(": ",$line);
				if(count($parts) == 2) $headers[$parts[0]] = chop($parts[1]);
			}
		}
		return $body;
	}
} 
?>