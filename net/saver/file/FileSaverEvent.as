/**
* 
* XmlSaver event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.saver.file 
{
	import flash.events.Event;
	public dynamic class FileSaverEvent extends Event
	{
		static public const ON_SAVE_COMLETE                    	:String = "onSaveComplete";
		static public const ON_ERROR                    		:String = "onError";
		
		public function FileSaverEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}