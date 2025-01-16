/**
* 
* File check class coupled with filecheck.php
* 
* @author Default
*/

package railk.as3.net.checker 
{	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import railk.as3.net.amfphp.*;
	
	
	public class FileCheck extends EventDispatcher 
	{
		public var amf:AmfphpClient;
		
		/**
		 * SINGLETON
		 */
		public static function getInstance():FileCheck{
			return Singleton.getInstance(FileCheck);
		}
		
		public function FileCheck() { Singleton.assertSingle(FileCheck); }
		
		
		/**
		 * CHECK
		 * 
		 * @param	file    the file to check if it exist
		 */
		public function check( amf:AmfphpClient, path:String, name:String ):void {	
			this.amf = amf;
			initListeners();
			amf.directCall( ((isUrl(name))?'File.Check.url':'File.Check.dir'), unescape(path+file) );
		}
		
		/**
		 * MANAGE LISTENERS
		 */
		private function initListeners():void {
			amf.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		private static function delListeners():void {
			amf.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		/**
		 * UTILITIES
		 */
		private function isUrl(filename:String):Boolean {
            filename = filename.toLowerCase();
            var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/; 
            var result:Object = pattern.exec(filename);
            if(result == null) return false;
            return true;
		}
		
		/**
		 * DISPOSE
		 */
		private static function dispose():void {
			delListeners();
			amf.close();
			amf = null;
		}
		
		/**
		 * MANAGE EVENT
		 */
		private static function manageEvent( evt:AmfphpClientEvent ):void {
			switch( evt.type ) {	
				case AmfphpClientEvent.ON_RESULT :
					dispatchEvent( new FileCheckEvent( FileCheckEvent.ON_FILE_CHECK_COMPLETE, { info:"fichier present", data:evt.data } ) );
					dispose();
					break;
					
				case AmfphpClientEvent.ON_ERROR :
					dispatchEvent( new FileCheckEvent( FileCheckEvent.ON_FILE_CHECK_ERROR, { info:"check error" } ) );
					dispose();
					break;
					
				default : break;
			}
		}
	}
}