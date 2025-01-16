
/**
* Interface service pour la creéation de service
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.amf.service
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public interface IService {
		function exec( connexion:NetConnection, responder:Responder ):void;
		function get name():String;
	}
	
}