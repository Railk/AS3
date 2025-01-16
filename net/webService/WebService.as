/**
 * Webservice base class to be extended
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.webService
{	
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader
	import flash.events.Event;
	
	public class WebService extends EventDispatcher
	{
		public var response:XML;
		protected var url:String;
		protected var action:String;
		protected var data:XML;
		private var loader:URLLoader;
		private var req:URLRequest;
		
		public function WebService(url:String) {
			this.url = url;
		}
		
		public function call():void {
			req = new URLRequest(url);
			req.contentType = "text/xml; charset=utf-8";
			req.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml; charset=utf-8"));
            req.method = URLRequestMethod.POST;
			req.data = WebServiceCall.data(data);
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResponse);
			loader.load(req);
		}
		
		private function onResponse( evt:Event ):void {
			response = new XML(loader.data);
			dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
}