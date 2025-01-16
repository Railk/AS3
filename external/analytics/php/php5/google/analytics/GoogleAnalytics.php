<?php
/*
* google analytic data retriever
*
* @author Richard Rodney 2008
*/


include 'http/HttpRequest.php';


// Available Languages for Google Analytics (28-05-2006)
define('GA_LANGUAGE_ENGLISH_US', 'en-US');
define('GA_LANGUAGE_ENGLISH_GB', 'en-GB');
define('GA_LANGUAGE_GERMAN', 'de-DE');
define('GA_LANGUAGE_FRENCH', 'fr-FR');
define('GA_LANGUAGE_ITALIAN', 'it-IT');
define('GA_LANGUAGE_SPANISH', 'es-ES');
define('GA_LANGUAGE_DUTCH', 'nl-NL');
define('GA_LANGUAGE_JAPANESE', 'ja-JP');
define('GA_LANGUAGE_PORTUGUESE_BRAZIL', 'pt-BR');
define('GA_LANGUAGE_DANISH', 'da-DK');
define('GA_LANGUAGE_FINISH', 'fi-FI');
define('GA_LANGUAGE_NORWEGIAN', 'no-NO');
define('GA_LANGUAGE_SWEDISH', 'sv-SE');
define('GA_LANGUAGE_CHINESE_1', 'zh-TW');
define('GA_LANGUAGE_CHINESE_2', 'zh-CN');
define('GA_LANGUAGE_KOREAN', 'ko-KR');
define('GA_LANGUAGE_RUSSIAN', 'ru-RU');


class GoogleAnalytics {

	// ________________________________________________________________________________________ VARIABLES
    private $response;
    private $headers;
    private $cookies;
    private $request;
    private $error;
    private $loggedin=false;
    

    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  				 GESTION DU LOGIN
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
    public function login($user, $passwd) {
        
        /*
            PARSE LOGIN FORM
        */
        $this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
        $loginForm = "https://www.google.com/accounts/ServiceLoginBox?service=analytics&nui=1&hl=en-US&continue=http://www.google.com/analytics/home/%3Fet%3Dreset%26hl%3Den-US";
        $this->request->setMethod(HTTP_REQUEST_METHOD_GET);
        $this->request->setURL($loginForm);
        $this->request->sendRequest();
        $cookies = $this->request->getResponseCookies();
        $response = $this->request->getResponseBody();
        

        if (!ereg('Google Accounts', $response)) {
            $this->setError('Unable to establish a connection to Google Analytics. Make sure your server has the proper <a href="http://us2.php.net/manual/en/ref.curl.php">libcurl</a> libraries (with OpenSSL support) for PHP installed.');
            return false;
            echo "connection impossible";
        }
        $hidden['GA3T'] = $cookies['GA3T']['value'];
        

        /*
            PERFORM THE LOGIN ACTION
        */
        $this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
        $loginAction = "https://www.google.com/accounts/ServiceLoginBoxAuth";
        $this->request->setMethod(HTTP_REQUEST_METHOD_POST);
        $this->request->setURL($loginAction);
        $this->request->addPostData('continue', 'http://www.google.com/analytics/home/?et=reset&amp;hl=en-US');
        $this->request->addPostData('service', 'analytics');
        $this->request->addPostData('nui', '1');
        $this->request->addPostData('hl', 'en-US');
        $this->request->addPostData('GA3T', $hidden['GA3T']);
        $this->request->addPostData('Email', $user);
        $this->request->addPostData('Passwd', $passwd);
        $this->request->sendRequest();
        $this->headers = $this->request->getResponseHeader();
        $this->cookies = $this->request->getResponseCookies();
        $this->response = $this->request->getResponseBody();
        

        // ugly
        $nextLink = ereg_replace(".*<a href=\"(.*)\" target=.*", "\\1", $this->response);
        $nextLink = ereg_replace('amp;', '', $nextLink);

        /*
            CHECK IF LOGIN WAS OK
        */
        if (!ereg('accounts/TokenAuth', $nextLink)) {
            $this->setError("Your login and password don't match. Make sure you've typed them in correctly.");
            return false;
            echo "mauvais couple mot de passe/login";
        }
        

        /*
            REDIRECT TO COOKIE CHECK
        */
        $this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
        $this->request->clearPostData();
        $this->request->setMethod(HTTP_REQUEST_METHOD_GET);
        $this->request->setURL($nextLink);
        foreach ($this->cookies as $c) {
            $this->request->addCookie($c['name'], $c['value']);
        }
        $this->request->sendRequest();
        $nextLink = $this->request->getResponseHeader('Location');
        if (!$nextLink) {
            $this->setError("Unable to forward to Google Analytics.");
            return false;
            echo "impossible d'aller vers le service google analytics";
        }

        /*
            REDIRECT TO SERVICE
        */
        $this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
        $this->request->setURL($nextLink);
        foreach ($this->cookies as $c) {
            $this->request->addCookie($c['name'], $c['value']);
        }
        $this->request->sendRequest();

        /*
            We're now logged in, so we can now go grab reports.
        */

        $this->loggedin = true;
        return true;
    }

    
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  		   RECUPERATION DU COMPTE
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
    public function getAccounts () {
		if ( !$this->isLoggedIn() ) return array();
		
		$this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
		$url = "https://www.google.com/analytics/home/";
		$this->request->setMethod(HTTP_REQUEST_METHOD_GET);
		$this->request->setURL($url);
		foreach ($this->cookies as $c) {
            $this->request->addCookie($c['name'], $c['value']);
        }
		$this->request->sendRequest();
		$body = $this->request->getResponseBody();
		
		
		if (!strpos($body, "name=\"account_list\"")) {
		    return array();
		}

		$body = substr($body, strpos($body, "name=\"account_list\""));
		$body = substr($body, 0, strpos($body, "</select>"));
		preg_match_all("/<option.*value=\"(.*)\".*>(.*)<\/option>/isU", $body, $matches);
		
		$accounts = array();
		foreach ( $matches[1] as $matchNumber => $accountID ) {
			$accountName = ( isset($matches[2][$matchNumber]) ) ? $matches[2][$matchNumber] : null;
			if ( !is_null($accountID) && $accountID != 0 ){ 
				$accounts[$accountName] = $accountID;
			}	
		}
		
		return $accounts;
	}
    
    
	
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  		RECUPERATION DES PROFILES
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
    public function getSiteProfiles($accountID = null) {
        if (!$this->isLoggedIn()) { return array(); }
    	
        $this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
        $url = "https://www.google.com/analytics/home/admin?scid={$accountID}";
        $this->request->setMethod(HTTP_REQUEST_METHOD_GET);
        $this->request->setURL($url);
        foreach ($this->cookies as $c) {
            $this->request->addCookie($c['name'], $c['value']);
        }
        $this->request->sendRequest();
        $body = $this->request->getResponseBody();
        
		$body = substr($body, strpos($body, "name=\"profile_list\""));
		$body = substr($body, 0, strpos($body, "</select>"));
		preg_match_all("/<option.*value=\"(.*)\".*>(.*)<\/option>/isU",$body, $matches);

		$profiles = array();
		foreach ( $matches[1] as $matchNumber => $siteID ) {
			$profileName = ( isset($matches[2][$matchNumber]) ) ? $matches[2][$matchNumber] : null;
			if ( $siteID != 0 && !is_null($profileName) ) $profiles[$profileName] = $siteID;
		}

        return $profiles;
    }
	
    
	
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  	  RECUPERATION DU RAPPORT XML
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
    public function getReport($profileID, $dateStart, $dateStop, $reportType='1', $reportMode='GeoMapReport', $reportView='WORLD') {
        if (!$this->isLoggedIn()) { return ''; }
		
        $this->request = new HttpRequest();
        $this->request->addHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)");
		$url = "https://www.google.com/analytics/reporting/export?fmt=$reportType&id=$profileID&pdr=$dateStart-$dateStop&cmp=average&trows=300&rpt=$reportMode&d1=FR&segkey=city&tab=0&tchcol=0&tst=0&tscol=0&tsdir=0&mdet=$reportView&midx=0&gidx=0";
        $this->request->setMethod(HTTP_REQUEST_METHOD_GET);
        $this->request->setURL($url);
        foreach ($this->cookies as $c) {
            $this->request->addCookie($c['name'], $c['value']);
        }
        $this->request->sendRequest();

        return $this->request->getResponseBody();
    }
    
    public function saveReport( $report, $filePath ){
		//on vérifie sir le fichiir existe ou non pour le créer si besoin est
		if( file_exists( $filePath ) ){ unlink($filePath); touch($filePath); $fp = fopen($filePath, "w"); }
		else{ touch($filePath); $fp = fopen($filePath, "w"); }
		//--
		$xml = new SimpleXMLElement($report);
		$geomap = $xml->Report->GeoMap->asXML();
		//--
		$xmlstring = "<?xml version='1.0'?>
					<reports>$geomap</reports>";
		$xml = new SimpleXMLElement($xmlstring);
		//--
		$xmlToSave = $xml->asXML();
		//ecriture du fichier et fermeture
		fwrite($fp, $xmlToSave);
		fclose($fp);
		
		return $xmlToSave;
    }
    
    
    
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	                    GETTER/SETTER
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
    public function getError() {
        return $this->error;
    }
    
    public function setError($err) {
        $this->error = $err;
    }
    
    public function isLoggedIn() {
        return $this->loggedin ? true : false;
    }
    
    public function getSession() {
        return $this->cookies;
    }
    
    public function setSession($session) {
        if (!is_array($session)) {
            return false;
        }
        $this->cookies = $session;
        foreach ($this->cookies as $c) {
            $this->req->addCookie($c['name'], $c['value']);
        }
        $this->loggedin = true;
        return true;
    }

	
    
}
?>