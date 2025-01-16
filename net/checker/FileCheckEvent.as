/**
* 
* filecheck event
* 
* @author Richard rodney
*/


package railk.as3.net.checker 
{
	import flash.events.Event;
	public dynamic class FileCheckEvent extends Event
	{
		static public const ON_FILE_CHECK_COMPLETE :String = "onFileCheckComplete";
		static public const ON_FILE_CHECK_ERROR    :String = "onFileCheckError";
		
		public function  FileCheckEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}