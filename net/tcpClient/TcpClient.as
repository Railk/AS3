/**
* 
* Tcp Client
* 
* Connect to c#/java local server
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.tcpClient 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;	
	import railk.as3.utils.Logger;
	
	
	public class TcpClient extends EventDispatcher
	{	
		private var sc:Socket;
		private var data:String;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function TcpClient() {
			sc = new Socket();
			initListeners();
		}
		
		/**
		 * MANAGE LISTENERS
		 */
		private function initListeners():void {
			sc.addEventListener( ProgressEvent.SOCKET_DATA, manageEvent, false, 0, true );
			sc.addEventListener( Event.CONNECT, manageEvent, false, 0, true  );
			sc.addEventListener( Event.CLOSE, manageEvent, false, 0, true  );
			sc.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
			sc.addEventListener( SecurityErrorEvent.SECURITY_ERROR, manageEvent, false, 0, true );
		}
		
		private function delListeners():void {
			sc.removeEventListener( ProgressEvent.SOCKET_DATA, manageEvent );
			sc.removeEventListener( Event.CONNECT, manageEvent  );
			sc.removeEventListener( Event.CLOSE, manageEvent  );
			sc.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
			sc.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, manageEvent );
		}
		
		/**
		 * MANAGE CONNECTION
		 * 
		 * @param	adress
		 * @param	port
		 */
		public function connect( adress:String, port:int ):void { sc.connect(  adress, port ); }
		public function disconnect():void { sc.close(); }
		
		/**
		 * SEND DATA
		 * @param	data
		 */
		public function sendData( data:String ):void {
			sc.writeUTFBytes( data );
			sc.flush();
		}
		
		/**
		 * GET DATA
		 * @param	data
		 */
		public function getData( data:String ):void {
			this.data = data;
			dispatchEvent( new TcpClientEvent( TcpClientEvent.ONDATARECEIVED, { info:"data received from server", data:_data } ) );
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			disconnect();
			delListeners();
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get receivedData():String { return data; }
		
		
		/**
		 * MANAGE EVENT
		 * @param	evt
		 */
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case SecurityErrorEvent.SECURITY_ERROR : Logger.print( 'security error '+evt, Logger.ERROR ); break;
				case ProgressEvent.SOCKET_DATA :
					Logger.print( 'data reçu', Logger.MESSAGE );
					sc.writeUTFBytes( 'client deconnecte' );
					var d:String = sc.readUTFBytes( sc.bytesAvailable );
					getData( d );
					break;
				
				case Event.CONNECT :
					Logger.print( 'connecté', Logger.MESSAGE );
					dispatchEvent( new TcpClientEvent( TcpClientEvent.ONCONNECTED, { info:"connected to the server" } ) );
					break;
					
				case Event.CLOSE :
					Logger.print( 'deconnecté', Logger.MESSAGE );
					break;
					
				case IOErrorEvent.IO_ERROR :
					Logger.print( 'erreur de connexion '+evt, Logger.ERROR );
					break;
				
				default : break;
			}
		}
	}	
}