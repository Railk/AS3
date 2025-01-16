/**
* 
* update and save data files
* 
* @author Richard Rodney.
* @version 0.2
*/

package railk.as3.net.saver.file 
{	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import railk.as3.net.amfphp.*;
	
	
	public class FileSaver extends EventDispatcher {
		
		private var data        :ByteArray;
		private var type        :String;
		private var path        :String;
		private var url         :String;
		private var fileName    :String;
		private var fileType    :String;
		private var amf        	:AmfphpClient;
		private var downloader  :FileReference;
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function FileSaver( amf:AmfphpClient ) {
			this.amf = amf;
			downloader = new FileReference();
			initListeners();
		}
		
		/**
		 * GESTION DES LISTENERS
		 */
		private function initListeners():void {
			amf.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		private function delListeners():void {
			amf.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
		}
		
		/**
		 * 
		 * SAVE
		 * 
		 * @param	type
		 * @param	path      dossier de sauvegarde
		 * @param	nom
		 * @param	fileType
		 * @param	data
		 * @param	update
		 */
		public function save( url:String, path:String, fileName:String, fileType:String, data:ByteArray ):void {
			this.url = url;
			this.path = path
			this.fileName = fileName;
			this.fileType = fileType;
			this.data = data;
			amf.directCall( 'File.Save.bin', path+"/"+fileName+"."+fileType, data );
		}
		
		/**
		 * DOWNLOAD THE SAVED FILE
		 * 
		 * only work with Http or Https protocol
		 */
		public function downloadFile():void {	
			downloader.download( new URLRequest ( url+'/'+path+"/"+fileName+"."+fileType ) );
		}
		
		/**
		 * DISPOSE
		 */
		private function dispose():void {
			delListeners();
			amf.close();
		}
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent(evt:AmfphpClientEvent ):void {
			switch( evt.type ) {
				case AmfphpClientEvent.ON_RESULT :
					dispatchEvent( new FileSaverEvent( FileSaverEvent.ON_SAVE_COMLETE, { info:"file "+ fileName +"saved" } ) );
					dispose();
					break;
					
				case AmfphpClientEvent.ON_ERROR :
					dispatchEvent( new FileSaverEvent( FileSaverEvent.ON_ERROR, { info:"problem with "+ fileName +" file" } ) );
					dispose();
					break;
				
				default : break;
			}
		}
	}	
}