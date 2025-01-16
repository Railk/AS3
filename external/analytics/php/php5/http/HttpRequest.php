<?php
/*
* class httpRequest utilisant la librairie Curl
*
* @author Richard Rodney 2008
*/


// Available Method 
define('HTTP_REQUEST_METHOD_GET', 'GET');
define('HTTP_REQUEST_METHOD_POST', 'POST');
define('HTTP_REQUEST_METHOD_PUT', 'PUT');
define('HTTP_REQUEST_METHOD_HEAD', 'HEAD');
define('HTTP_REQUEST_METHOD_DELETE', 'DELETE');



class HttpRequest {
	
	// ________________________________________________________________________________________ VARIABLES
	private $request;
	private $url;
	private $method;
	private $auth;
	private $postData=array();
	private $headers=array();
	private $cookies=array();
	private $response;
	private $parsedResponse;
	private $sent = false;
	
	
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  					 CONSTRUCTEUR
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	public function HttpRequest(){
		$this->request = curl_init();
		$this->addHeader('Connection', 'close');
	}
	
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  					 SEND REQUEST
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	public function sendRequest(){
		
		///////////////////////////////HEADERS////////////////////////////////
		$headers = array( "Accept: *.*" );
		foreach ($this->headers as $k=>$h) {
            $headers[] = "$k: $h";
        }
        //////////////////////////////////////////////////////////////////////
        
        
        ///////////////////////////////COOKIES////////////////////////////////
        if (count($this->cookies) > 0) {
            $cookies = '';
            foreach ($this->cookies as $cookie) {
                $cookies .= ''.$cookie['name'].'='.$cookie['value'].'; ';
            }
            curl_setopt($this->request, CURLOPT_COOKIE, $cookies);
        }
        //////////////////////////////////////////////////////////////////////
        
        
        ////////////////////////////////POSTDATA//////////////////////////////
        if( $this->method == HTTP_REQUEST_METHOD_POST && count($this->postData) > 0 ){
        	 $postData = '';
            foreach ($this->postData as $key=>$value) {
                $postData .= $key.'='.urlencode($value).'&';
            }
            curl_setopt($this->request, CURLOPT_POSTFIELDS, $postData);
        }
        //////////////////////////////////////////////////////////////////////

        
		curl_setopt($this->request, CURLOPT_URL, $this->url);
        curl_setopt($this->request, CURLOPT_FOLLOWLOCATION, false);
        curl_setopt($this->request, CURLOPT_HEADER, true);
        curl_setopt($this->request, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($this->request, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($this->request, CURLOPT_SSL_VERIFYPEER, false);
		$this->response = curl_exec( $this->request );
		curl_close( $this->request );
		
		
		////////////////////////////PARSERESPONSE/////////////////////////////
		$this->parsedResponse = $this->parseResponse( $this->response );
		//////////////////////////////////////////////////////////////////////
		
	    return $this->sent=true;
	}
	
	
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  			   PARSE THE RESPONSE
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	private function parseResponse($response) {
        
		//on separe le header et le corps de la page
        list($header, $body) = explode("\r\n\r\n", $response, 2);
        //on sépare chaque ligne de header
        $header_lines = explode("\r\n", $header);
        
        
		//on recupère la ligne HTTP et on la supprime du tableau
        $http_line = array_shift($header_lines);
        //on recupere le code http et on verifie qu'il est de 200 OK
        if (preg_match('@^HTTP/[0-9]\.[0-9] 100@',$http_line, $matches)) { 
            return $this->parseResponse($body);
        } 
        else if(preg_match('@^HTTP/[0-9]\.[0-9] ([0-9]{3})@',$http_line, $matches)) { 
            $code = $matches[1]; 
        }
        
        
        //on parse le header pour en donner un tableau
        $header_array = array();
        foreach($header_lines as $line) {
            list($headerVar,$value) = explode(': ', $line, 2);
            $header_array[$headerVar] .= $value."\n";
        }
        return array("code" => $code, "header" => $header_array, "body" => $body); 
    }
	
    
    
    
    
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  					   ADD HEADER
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	function addHeader($header, $value) {
        $this->headers[$header] = $value;
    }
	
    
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  					ADD POST DATA
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	function addPostData($name, $value) {
        $this->postData[$name] = $value;
    }
    
    
    // ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  					   ADD COOKIE
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
    function addCookie($name, $value) {
        $this->cookies[$name] = array('name' => $name, 'value' => $value);
    }
	
	
	
    
    
    
    
    
    
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  				GETTER/SETTER URL
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	public function setUrl($url){
		$this->url = $url;
		curl_setopt( $this->request,CURLOPT_URL,$this->url );
	}
	
	public function getUrl(){
		return $this->url;
	}
	
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  			   GETTER/SETTER AUTH
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	public function setAuth($user,$pass){
		$this->auth = $user. ':' .$pass;
		$this->addHeader( 'Authorization', 'Basic ' . base64_encode( $this->auth ) );
	}
	
	public function getAuth($pass){
		return $auth;
	}
	
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  		GETTER/SETTER HTTP METHOD
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	public function setMethod($method){
		switch ($method) {
			case HTTP_REQUEST_METHOD_GET :
                curl_setopt($this->request, CURLOPT_HTTPGET, true);
                break;
                       		
            case HTTP_REQUEST_METHOD_POST :
                curl_setopt($this->request, CURLOPT_POST, true);
            	break;
            
            case HTTP_REQUEST_METHOD_PUT :
            	curl_setopt($this->request, CURLOPT_PUT, true);
           		break;	
            	    
            case HTTP_REQUEST_METHOD_DELETE :
                curl_setopt($this->request, CURLOPT_CUSTOMREQUEST, 'DELETE');
            	break;
            
            case HTTP_REQUEST_METHOD_HEAD :
                curl_setopt($this->request, CURLOPT_CUSTOMREQUEST, 'HEAD');
            break;
        }
        
        $this->method = $method;
	}

	public function getMethod(){
		return $this->method;
	}
	
	
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	// 																	  				 GETTERS RESPONSE
	// ——————————————————————————————————————————————————————————————————————————————————————————————————
	public function getRequest(){
		return $this->request;
	}
	
	public function getResponse(){
		return $this->response;
	}
	
	public function getResponseHeader($header=false) {
        if ($header) {
            return $this->parsedResponse['header'][$header];
        } else {
            return $this->parsedResponse['header'];
        }
    }
    
    public function getResponseCookies() {
        $hdrCookies = array();
        foreach ($this->parsedResponse['header'] as $key => $value) {
            if (strtolower($key) == 'set-cookie') {
                $hdrCookies = array_merge($hdrCookies, explode("\n", $value));
            }
        }
        $cookies = array();
        foreach ($hdrCookies as $cookie) {
            if ($cookie) {
                list($name, $value) = explode('=', $cookie, 2);
                list($value, $domain, $path, $expires) = explode(';', $value);
                $cookies[$name] = array('name' => $name, 'value' => $value);
            }
        }
        return $cookies;
    }
    
    public function getResponseBody() {
        return $this->parsedResponse['body'];
    }
    
    public function getResponseCode() {
        return $this->parsedResponse['code'];
    }
	
	public function getPostData(){
		return $this->postData;
	}
	
	public function clearPostData($data=false){
		if (!$data) {
            $this->postData = array();
        } else {
            unset($this->postData[$data]);
        }
	}
	
	public function isSent(){
		return $this->sent;
	}
	
}

?>