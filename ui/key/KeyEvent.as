package railk.as3.ui.key 
{	
	import flash.events.Event;
	public class KeyEvent extends Event
	{	
		static public const ON_KEY_PRESS:String = "onKeyPress";
		static public const ON_KEY_RELEASE:String = "onKeyRelease";
		
		public var keyCode:int;
		public var keyLocation:uint;
		public var altKey:Boolean;
		public var ctrlKey:Boolean;
		public var shiftKey:Boolean;
		
		public function KeyEvent(type:String,keyCode:int,altKey:Boolean,ctrlKey:Boolean,shiftKey:Boolean,keyLocation:uint,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.keyCode = keyCode;
			this.keyLocation = keyLocation;
			this.altKey = altKey;
			this.ctrlKey = ctrlKey;
			this.shiftKey = shiftKey;
		}
	}
}