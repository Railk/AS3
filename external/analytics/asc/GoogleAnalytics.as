/**
* 
* GoogleAnalytics
* 
* @author richard rodney
* @version 0.1
*/

package railk.as3.external.analytics.asc
{
	import com.adobe.net.URI;
	import org.httpclient.*;
	import org.httpclient.http.*;
	import org.httpclient.events.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	
	import railk.as3.net.oauth.*;
	import railk.as3.net.clientLogin.ClientLogin;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.utils.URLEncoding;
	
	public class GoogleAnalytics extends EventDispatcher 
	{
		private const scope:String = 'https://www.google.com/analytics/feeds/';
		private const tokenRequest:String='https://www.google.com/accounts/OAuthGetRequestToken';
		private const tokenAuth:String='https://www.google.com/accounts/OAuthAuthorizeToken';
		private const tokenAccess:String = 'https://www.google.com/accounts/OAuthGetAccessToken';
		
		public var authToken:String;
		public var data:XML;
		public var account:String;
		
		/**
		 * SINGLETON
		 */
		public static function getInstance():GoogleAnalytics{
			return Singleton.getInstance(GoogleAnalytics);
		}
		
		public function GoogleAnalytics() { Singleton.assertSingle(GoogleAnalytics); }
		
		/**
		 * LOGINS
		 */
		public function oauthLogin(name:String, password:String, consumer_key:String, consumer_secret:String):void {
			var oauth:OAuth = new OAuth('GET', tokenRequest, {scope:scope} );
			oauth.consumer.key = consumer_key;
			oauth.consumer.secret = consumer_secret;
			oauth.call(oauth.buildRequest());
		}
		
		public function clientLogin(email:String, password:String, source:String):void {
			/*var cl:ClientLogin = ClientLogin.getInstance();
			cl.addEventListener(Event.COMPLETE, function() { 
				authToken = cl.AUTH; 
				dispatchEvent( new GoogleAnalyticsEvent(GoogleAnalyticsEvent.ON_LOGIN_COMPLETE));
			});
			cl.locale(email, password, source);*/
			Security.allowDomain("https://www.google.com");
			Security.allowDomain("http://www.google.com");
			var client:HttpClient = new HttpClient();
			var uri:URI = new URI("https://www.google.com/accounts/ClientLogin");
			var request:HttpRequest = new Post();
			request.setFormData([	{name:"accountType",value:"GOOGLE"},
									{name:"Email", value:email},
									{name:"Passwd",value:password},
									{name:"source",value:source},
									{name:"service",value:"analytics"} ]);
			
			var buffer:String = new String();
			client.listener.onData = function(event:HttpDataEvent):void { buffer += event.readUTFBytes(); };
			client.listener.onError = function(event:*):void { dispatchEvent(new GoogleAnalyticsEvent(GoogleAnalyticsEvent.ON_ERROR,{error:event.text})); };
			client.listener.onComplete = function(event:HttpResponseEvent):void { 
				var lines:Array = buffer.match(/[a-zA-Z0-9=_\-]{1,}/mg);
				authToken = String(lines[2]).split('Auth=')[1]; 
				dispatchEvent(new GoogleAnalyticsEvent(GoogleAnalyticsEvent.ON_LOGIN_COMPLETE,{token:buffer})); 
			};
			client.request(uri, request);
			
		}
		
		public function logout(name:String, password:String):void {
		}
		
		/**
		 * GET ACCOUNT
		 */
		public function getAccount(start:int,max:int):void {
			var req:URLRequest = new URLRequest('https://www.google.com/analytics/feeds/accounts/default');
			req.requestHeaders.push(new URLRequestHeader('Authorization', 'GoogleLogin auth='+authToken));
			req.requestHeaders.push(new URLRequestHeader('Content-type', 'application/x-www-form-urlencoded'));
			req.method = URLRequestMethod.GET;
			req.data = "start-index="+start+"&max-results="+max;
			load(req,'account');
		}
		
		/**
		 * GET DATA
		 */
		public function getData(id:String, type:String):void {
			var client:HttpClient = new HttpClient();
			var uri:URI = new URI("https://www.google.com/analytics/feeds/accounts/default");
			var request:HttpRequest = new Get();
			request.addHeader("Authorization", "GoogleLogin auth=" + authToken);
			
			var buffer:String = new String();
			client.listener.onData = function(event:HttpDataEvent):void { buffer += event.readUTFBytes(); };
			client.listener.onComplete = function(event:HttpResponseEvent):void { account=buffer; dispatchEvent(new GoogleAnalyticsEvent(GoogleAnalyticsEvent.ON_ACCOUNT,{data:account})); };
			client.request(uri, request);
						
			/*var req:URLRequest = new URLRequest('https://www.google.com/analytics/feeds/data');
			req.requestHeaders.push(new URLRequestHeader('Content-type', 'application/x-www-form-urlencoded'));
			req.requestHeaders.push(new URLRequestHeader('Authorization', 'GoogleLogin auth='+authToken));
			req.method = URLRequestMethod.GET;
			req.data = "ids=ga:"+id+"&"+type;
			load(req,'data');*/
		}
		
		/**
		 * LOAD
		 */
		private function load(req:URLRequest,type:String):void {
			var loader:URLLoader = new URLLoader()
			loader.addEventListener(Event.COMPLETE, function() {
				switch(type) {
					case 'account' : account = loader.data; dispatchEvent(new GoogleAnalyticsEvent(GoogleAnalyticsEvent.ON_ACCOUNT,{data:account})); break;
					case 'data' : data = loader.data; dispatchEvent(new GoogleAnalyticsEvent(GoogleAnalyticsEvent.ON_DATA,{data:data})); break;
				}
			});
			loader.load(req);
		}
	}
}