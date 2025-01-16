/**
* uploader gestion
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.uploader 
{
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.events.*;
	
	public class UpLoader extends EventDispatcher {
		
		private var uploadURL              :URLRequest;
		private var uploadVAR              :URLVariables;
		private var fileRef                :FileReference;
		private var fileType               :String;
		private var uploadBT               :Object;
		
		/**
		 * CONSTRUCTEUR
		 * @param	uploadFilePath
		 */
		public function UpLoader( uploadFilePath:String ) {
			uploadURL = new URLRequest( uploadFilePath );
			uploadURL.method = URLRequestMethod.POST;
			uploadVAR = new URLVariables();
			
			fileRef = new FileReference();
			configListenersFile( fileRef );
		}
		
		/**
		 * MANAGE LISTENERS
		 * @param	dispatcher
		 */
		private function configListenersFile( dispatcher:IEventDispatcher ):void {
            dispatcher.addEventListener( Event.CANCEL, onCancel, false, 0, true );
			dispatcher.addEventListener( Event.SELECT, onSelect, false, 0, true );
			dispatcher.addEventListener( Event.OPEN, onBegin, false, 0, true );
			dispatcher.addEventListener( ProgressEvent.PROGRESS, onProgress, false, 0, true );
            dispatcher.addEventListener( Event.COMPLETE, onComplete, false, 0, true );
			dispatcher.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onDataUploaded, false, 0, true );
            dispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatus, false, 0, true );
			dispatcher.addEventListener( IOErrorEvent.IO_ERROR, onIOError, false, 0, true );
			dispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true );
        }
		
		private function delListenersFile( dispatcher:IEventDispatcher ):void {
			dispatcher.removeEventListener( Event.CANCEL, onCancel );
			dispatcher.removeEventListener( Event.SELECT, onSelect );
			dispatcher.removeEventListener( Event.OPEN, onBegin );
			dispatcher.removeEventListener( ProgressEvent.PROGRESS, onProgress );
            dispatcher.removeEventListener( Event.COMPLETE, onComplete );
			dispatcher.removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA,onDataUploaded );
            dispatcher.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onHttpStatus );
			dispatcher.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			dispatcher.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
        }
		
		
		/**
		 * MANAGE EVENT
		 * @param	evt
		 */
		private function onCancel( evt:Event ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_CANCEL, { info:"upload annule" } ) );
		}
		
		private function onSelect( evt:Event ):void {
            fileRef.upload( uploadURL );
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_SELECT, { info: fileRef.name } ) );
		}
		
		private function onBegin( evt:Event ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_BEGIN, { info:"debut du transfert" } ) );
		}
		
		private function onProgress( evt:ProgressEvent ):void {
			try {
				var percent:Number = Math.floor(evt.bytesLoaded * 100 / evt.bytesTotal);
				dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_PROGRESS, { info:percent } ) );
				
			} catch(e:Error) {
				trace("Error: " + e.message)
				return;
			}	
		}
		
		private function onComplete( evt:Event ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_COMPLETE, { info:"transfert termine" } ) );
		}
		
		private function onDataUploaded( evt:DataEvent ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_DATA_UPLOADED, { info:"data uploaded" } ) );
		}
		
		private function onHttpStatus( evt:HTTPStatusEvent ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_HTTP_STATUS, { info:evt } ) );
		}
		
		private function onIOError( evt:IOErrorEvent ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_IOERROR, { info:evt } ) );
		}
		
		private function onSecurityError( evt:SecurityErrorEvent ):void {
			dispatchEvent( new UpLoaderEvent( UpLoaderEvent.ON_SECURITY_ERROR, { info:evt }) );
		}
		
		
		/**
		 * DECORATE THE BUTTON
		 * 
		 * @param	button
		 * @param	type UpLoaderFilters.IMGFILE/TXTFILE/SWFFILE/XMLFILE/
		 * @param	url the folder where to save the file
		 */
		public function decorate( button:Object, type:String, urlFolder:String ):void {
			fileType = type;
			uploadBT = button;
			uploadVAR.folder = urlFolder;
			uploadURL.data = uploadVAR;
			configListernersButton( uploadBT );
		}
		
		/**
		 * MANAGE BUTTON LISTENERS
		 * @param	button
		 */
		private function configListernersButton( button:Object ):void {
			button.buttonMode = true;
			button.addEventListener( MouseEvent.CLICK, browse, false, 0, true );
		}
		
		private function delListenersButton( button:Object ):void {
			button.buttonMode = false;
			button.removeEventListener( MouseEvent.CLICK, browse );
		}

		private function browse( evt:MouseEvent ):void {
			var target = evt.currentTarget;
			fileRef.browse( [UpLoaderFilters.Type( fileType )] );
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			delListenersButton( uploadBT );
			delListenersFile( fileRef );
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get fileName():String {
			return fileRef.name;
		}
	}
}