/**
* SoundPlayer Event
* 
* @author Richard Rodney.
* @version 0.2
* 
*/

package railk.as3.sound 
{	
	import flash.events.Event;
	public class AudioPlayerEvent extends Event
	{
		static public const SOUND_PLAY:String = "onPlay";
		static public const SOUND_PAUSE:String = "onPause";
		static public const SOUND_PROGRESS:String = "onProgress";
		static public const SOUND_COMPLETE:String = "onComplete";
		static public const SOUND_LOAD_BEGIN:String = "onLoadBegin";
		static public const SOUND_LOAD_PROGRESS:String = "onLoadProgress";
		static public const SOUND_LOAD_COMPLETE:String = "onLoadComplete";
		static public const SOUND_START_BUFFERING:String = "onStartBuffer";
		static public const SOUND_STOP_BUFFERING:String = "onStopBuffer";
		
		public var percent:Number;
		public function AudioPlayerEvent(type:String, percent:Number=NaN, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.percent = percent;
		}
	}	
}