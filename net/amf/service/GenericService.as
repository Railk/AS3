/**
* Service for amfphp
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.amf.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class GenericService implements IService
	{
		private var _action                          :String;
		private var _vars                            :Array;
		
		public function GenericService( service:String, method:String, ...args ) {
			_vars = args;
			_action = service + '.' + method;
		}
		
		public function exec( connexion:NetConnection, responder:Responder ):void {
			if ( _vars.length > 0 ) connexion.call( _action, responder, _vars );
			else connexion.call( _action, responder );
		}
		
		public function get name():String { return 'generic'; }
	}
	
}