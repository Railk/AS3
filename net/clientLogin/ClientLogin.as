/**
 * ClientLogin
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.clientLogin
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.system.Security;
	import railk.as3.pattern.singleton.Singleton
	import railk.as3.utils.URLEncoding;
		
	public class ClientLogin extends EventDispatcher
	{
		public var AUTH:String;
		public var LSID:String;
		public var SID:String;
		
		public static function getInstance():ClientLogin{
			return Singleton.getInstance(ClientLogin);
		}
		
		public function ClientLogin() { Singleton.assertSingle(ClientLogin); }
		
		public function server(url:String,config:String) {
			var req:URLRequest = new URLRequest(url);
			req.data = { config:config }
			load(req);
		}
		
		public function locale(email:String, password:String, source:String) {
			var req:URLRequest = new URLRequest('https://www.google.com/accounts/ClientLogin');
			req.contentType = "application/x-www-form-urlencoded";
			req.requestHeaders.push(new URLRequestHeader('Content-type', 'application/x-www-form-urlencoded'));
			req.method = URLRequestMethod.POST;
			req.data = "accountType=GOOGLE&Email="+URLEncoding.escape(email)+"&Passwd="+URLEncoding.escape(password)+"&source="+URLEncoding.escape(source)+"&service=analytics";
			load(req);
		}
		
		private function load(req:URLRequest):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function() { parseResponse( loader.data ); });
			loader.load(req);
		}
		
		private function parseResponse(data:String):void {
			var lines:Array = data.match(/[a-zA-Z0-9=_\-]{1,}/mg);
			SID = String(lines[0]).split('SID=')[1];
			LSID = String(lines[1]).split('LSID=')[1]; 
			AUTH = String(lines[2]).split('Auth=')[1]; 
			dispatchEvent( new Event(Event.COMPLETE));
		}
	}
}