/**
* 
* Tcp Client event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.tcpClient 
{
	import flash.events.Event;
	public dynamic class TcpClientEvent extends Event
	{
		static public const ONCONNECTED                     :String = "onConnected";
		static public const ONDATARECEIVED                  :String = "onDataReceived";	
		
		public function TcpClientEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}