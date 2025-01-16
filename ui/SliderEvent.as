/**
* 
* SLIDER EVENT
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui 
{
	import flash.events.Event;
	public class SliderEvent extends Event
	{
		static public const TRACK:String = "onTrack";
		static public const TRACK_BEGIN:String = "onTrackBegin";
		static public const TRACK_COMPLETE:String = "onTrackComplete";
		
		public var percent:Number;
		public function SliderEvent(type:String, percent:Number=NaN, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.percent = percent;
		}
	}
}