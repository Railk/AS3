/**
* 
* MultiLoaderEvent
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.loader 
{
	import flash.events.Event;	
	public dynamic class MultiLoaderEvent extends Event
	{	
		static public const ON_MULTILOADER_BEGIN:String = "onMultiLoaderBegin";
		static public const ON_MULTILOADER_PROGRESS:String = "onMultiLoaderProgress";
		static public const ON_MULTILOADER_COMPLETE:String = "onMultiLoaderComplete";
		static public const ON_MULTILOADER_LOADNEXT:String = "onMultiLoaderLoadNext";
		
		static public const ON_ITEM_BEGIN:String = "onItemBegin";
		static public const ON_ITEM_PROGRESS:String = "onItemProgress";
		static public const ON_ITEM_COMPLETE:String = "onItemComplete";
		static public const ON_ITEM_ERROR:String = "onItemError"
		
		static public const ON_STREAM_READY:String = "onStreamReady";
		static public const ON_STREAM_BUFFERING:String = "onStreamBuffering";
		static public const ON_STREAM_PLAYED:String = "onStreamPlayed";
		
		public function MultiLoaderEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}