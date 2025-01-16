/**
* 
* AMFPHP client
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.net.amf 
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	import railk.as3.crypto.Base64;
	import railk.as3.net.amf.service.IService;
	import railk.as3.utils.ObjectDumper;
	
	
	public class  AmfClient extends NetConnection
	{
		public var currentService:String;
		public var currentRequester:String;
		public var credentials:Object;
		private var responder:Responder;
		private var mode:String;
		private var server:String;
		private var path:String;		
		
		/**
		 * CONSCTRUCTEUR
		 * 
		 * @param	server
		 * @param	path
		 * @param	ssl
		 */
		public function AmfClient( server:String, path:String, ssl:Boolean = false ) {	
			this.server = server;
			this.path = path;
			this.mode = (ssl)?'https':'http';
			this.responder = new Responder(this.onResult, this.onError);
			open();
		}
		
		/**
		 * OPEN CONNECTION
		 */
		public function open():void {
			connect((((((mode + "://") + server) + "/") + path) + (((path == "")) ? "" : "/")));
            addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
            addEventListener(IOErrorEvent.IO_ERROR, onNetStatus, false, 0, true);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, onNetStatus, false, 0, true);
            addEventListener(AsyncErrorEvent.ASYNC_ERROR, onNetStatus, false, 0, true);
		}
		
		/**
		 * CALL TO A SERVICE
		 * 
		 * @param	service 	service to be used
		 * @param	requester   requester of the call
		 */
		public function serviceCall( service:IService, requester:String='' ):void { 
			currentRequester = requester;
			currentService = service.name;
			service.exec( this, responder );
		}
		
		/**
		 * DIRECT CALL
		 * @param	service
		 * @param	...args
		 */
		public function directCall( service:String, ...args ):void { 
			var a:Array = [service, responder];
            a = a.concat(args);
            call.apply(null, a);
		}
		
		
		/**
		 * CALL MANAGEMENT
		 */
		private function onResult( response:Object ):void {
			dispatchEvent( new AmfClientEvent( AmfClientEvent.ON_RESULT, { info:"service call success", requester:currentRequester, service:currentService, data:response } ) );
		}
		
		private function onError( response:Object ):void {
			var result:String = '';
			for ( var prop:String in response ) { result += prop+' : '+String( response[prop] )+'\n'; }			
			dispatchEvent( new AmfClientEvent( AmfClientEvent.ON_ERROR, { info:"service call error", requester:currentRequester, service:currentService, data:result } ) );
		}
		
		private function onNetStatus( evt:NetStatusEvent ):void {
			dispatchEvent( new AmfClientEvent( AmfClientEvent.ON_CONNEXION_ERROR, { info:"connexion error\n"+ ObjectDumper.dump(evt.info) } ) );
		}
		
		/**
		 * credentials
		 */
		public function addCredentials(userid:String,password:String):void {	
			addHeader('Credentials', false, {userid:Base64.encode(userid),password:Base64.encode(password)} );
		}	
		 
		public function removeCredentials():void {
			open();
		}
		
		/**
		 * TOSTRING
		 */
		override public function toString():String {
			return '[ AMFPHP CLIENT > mode:'+mode+' ]'
		}
	}
}	