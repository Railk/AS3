package railk.as3.effect.sticker 
{
	import flash.events.Event;

	public class StickerEvent extends Event 
	{
		static public const HANDLE_OPEN:String = "handleOpen";
		static public const HANDLE_CLOSE:String = "handleClose";
		static public const PEEL_BEGIN:String = "peelBegin";
		static public const PEEL_END:String = "peelEnd";
		static public const DRAG_BEGIN:String = "dragBegin";
		static public const DRAG_END:String = "dragEnd";
		
		public function StickerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
