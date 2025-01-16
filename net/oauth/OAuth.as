/**
 * oAuth
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.oauth
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import railk.as3.crypto.HMACSHA1;
	import railk.as3.utils.URLEncoding;
	
	public class OAuth extends EventDispatcher
	{		
		public var method:String;
		public var url:String;
		public var params:Object;
		public var consumer:Consumer = new Consumer();
		public var token:Token = new Token();
		public var rep:String;
		
		private var loader:URLLoader;
		private var req:URLRequest;
		
		/**
		 * 	CONSTRUCTEUR
		 * 
		 * @param	method		GET/POST/HEAD
		 * @param	url
		 * @param	params
		 * @param	consumer
		 * @param	token
		 */
		public function OAuth(method:String,url:String,params:Object=null) {
			this.method = method;
			this.url = url;
			this.params = (params)?params:new Object();
		}
		
		/**
		 * BUILD REQUEST
		 */
		public function buildRequest(type:String = 'STRING', headerRealm:String = ''):* {
			params['oauth_version'] = '1.0';
			params["oauth_nonce"] = getNonce(32);
			params["oauth_timestamp"] = String((new Date()).time).substring(0, 10);
			params["oauth_consumer_key"] = consumer.key;
			params["oauth_signature_method"] = "HMAC-SHA1";
			if (!token.empty) params["oauth_token"] = token.key;
			else { if (params.hasOwnProperty("oauth_token")) var checkDelete:Boolean = delete(params.oauth_token); }
			
			var message:String = URLEncoding.escape(method.toUpperCase())+'&'+URLEncoding.escape(url)+'&'+URLEncoding.escape(s_paramsToString);
            var key:String = URLEncoding.escape(consumer.secret)+'&'+((!token.empty)?URLEncoding.escape(token.secret):'');
			params["oauth_signature"] = URLEncoding.escape(HMACSHA1.base64(key, message));
			
			switch (type) {
				case 'STRING': return url+'?'+paramsToString; break;
				case 'VARIABLES':
					var result:URLVariables = new URLVariables();
					for (var param:Object in params) result[param] = params[param];
					return result;
					break;
				case 'POST': return paramsToString; break;
				case 'HEADER':
					var data:String = 'OAuth ';
					if (headerRealm.length > 0) data += 'realm=\"'+headerRealm+'\"';
					for (param in params) if (!param.toString().indexOf('oauth')) data += ','+param+'=\"'+URLEncoding.escape(params[param])+'\"';
					return new URLRequestHeader("Authorization",data);
					break;
				default : break;
			}
		}
		
		/**
		 * CALL
		 */
		public function call(url:String):void {
			req = new URLRequest(url);
			req.contentType = "application/x-www-form-urlencoded";
			req.requestHeaders.push(new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded"));
            req.method = URLRequestMethod.GET;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, callResponse);
			loader.load(req);
		}
		
		private function callResponse( evt:Event ):void {
			rep = loader.data;
			dispatchEvent( new Event(Event.COMPLETE));
		}
		
		/**
		 * SIGNED PARAMS TO STRING
		 */
		private function get s_paramsToString():String {
			var result:Array = [];
			for (var param:String in params) { 
				if (param != 'oauth_signature') {
					result.push(param + '=' + ((param=='scope')?URLEncoding.escape(params[param].toString()):params[param].toString())); 
				}
			}
			result.sort();
			return result.join('&');
		}
		
		/**
		 * PARAMS TO STRING
		 */
		private function get paramsToString():String {
			var result:Array = [];
			for (var param:String in params) result.push(param+'='+((param=='scope')?URLEncoding.escape(params[param].toString()):params[param].toString()));
			result.sort();
			return result.join('&');
		}
		
		/**
		 * GET NONCE
		 */
		private function getNonce(length:int=6):String {
			var chars:String = '0123456789abcdefghiklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXTZ', result:String = "";
			for (var i = 0; i < length; ++i) {
				var rnd = Math.floor(Math.random()*chars.length);
				result += chars.substring(rnd, rnd+1);
			}
			return result;
		}
	}
}