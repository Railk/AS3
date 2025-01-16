/**
* 
* Uploader event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.uploader {

	import flash.events.Event;
	public dynamic class UpLoaderEvent extends Event{
	
		static public const ON_CANCEL                        :String = "onCancel";
		static public const ON_SELECT                        :String = "onSelect";
		static public const ON_BEGIN                         :String = "onBegin";
		static public const ON_PROGRESS                      :String = "onProgress";
		static public const ON_COMPLETE                      :String = "onComplete";
		static public const ON_HTTP_STATUS                   :String = "onHttpStatus";
		static public const ON_DATA_UPLOADED                 :String = "onDataUploaded";
		static public const ON_IOERROR                       :String = "onIoError";
		static public const ON_SECURITY_ERROR                :String = "onSecurityError";
		
		public function UpLoaderEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
		
	}
}