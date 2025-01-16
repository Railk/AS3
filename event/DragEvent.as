/**
* Custom event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.event 
{
	import flash.events.Event;
	public class DragEvent extends Event
	{
		static public const ON_DRAG:String = "onDrag";
		static public const ON_STOP_DRAG:String = "onStopDrag";

		public var position:Number;
		public function DragEvent(type:String, position:Number, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.position = position;
		}	
	}
}