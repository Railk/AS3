/**
* VideoPlayer Event
* 
* @author Richard Rodney.
* @version 0.2
* 
*/

package railk.as3.video 
{	
	import flash.events.Event;
	public class VideoPlayerEvent extends Event
	{
		static public const VIDEO_STOP:String = "onPlay";
		static public const VIDEO_START:String = "onStop";
		static public const VIDEO_PROGRESS:String = "onProgress";
		static public const VIDEO_LOAD:String = "onLoad";
		static public const VIDEO_LOAD_COMPLETE:String = "onLoadComplete";
		static public const VIDEO_START_BUFFERING:String = "onStartBuffer";
		static public const VIDEO_STOP_BUFFERING:String = "onStopBuffer";
		static public const VIDEO_METADATA:String = "onMetadata";
		public static const VIDEO_BANDWITH_CHECK:String = "onBandwidth";
		
		public var percent:Number;
		public function VideoPlayerEvent(type:String, percent:Number=NaN, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.percent = percent;
		}
	}	
}