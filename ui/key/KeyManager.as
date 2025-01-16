package railk.as3.ui.key 
{   
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
	import flash.events.EventDispatcher;
   
    public class KeyManager extends EventDispatcher 
	{
		
		public static const CTRL:uint = 17;
		public static const SPACEBAR:uint = 32;
		public static const SHIFT:uint = 16;
		public static const TAB:uint = 9;
		public static const DEL:uint = 46;
		public static const C:uint = 67;
		public static const V:uint = 86;
		public static const A:uint = 65;
		public static const Z:uint = 90;
		public static const S:uint = 83;
       
		protected static var disp:EventDispatcher;
        private static var _initialized:Boolean = false;
        private static var keysDown:Object = new Object();
       
		/**
		 * ADD EVENT LISTENERS
		 * @param	p_type
		 * @param	p_listener
		 * @param	p_useCapture
		 * @param	p_priority
		 * @param	p_useWeakReference
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
      			if (disp == null) { disp = new EventDispatcher(); }
      			disp.addEventListener(type, listener, useCapture, priority, useWeakReference);
      	}
		
		/**
		 * REMOVE EVENT LSITENERS
		 * @param	p_type
		 * @param	p_listener
		 * @param	p_useCapture
		 */
    	public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
      			if (disp == null) { return; }
      			disp.removeEventListener(type, listener, useCapture);
      	}
		
		/**
		 * DISPATCH EVENT
		 * @param	p_event
		 */
    	public static function dispatchEvent(event:Event):void {
      			if (disp == null) { return; }
      			disp.dispatchEvent(event);
      	}
		
		/**
		 * INIT
		 * @param	stage
		 */
        public static function init(stage:Stage):void {
            if (!_initialized) {
                stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
                stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
                stage.addEventListener(Event.DEACTIVATE, clearKeys);
                _initialized = true;
            }
        }
       
		/**
		 * KEY IS DOWN
		 * @param	keyCode
		 * @return
		 */
        public static function isDown(keyCode:uint):Boolean {
            if (!_initialized) {
                throw new Error("Key class has yet been initialized.");
            }
            return keysDown[keyCode];
        }
		
		/**
		 * KEY IS PRESSED
		 * @param	evt
		 */
        private static function keyPressed(evt:KeyboardEvent):void {
            keysDown[evt.keyCode] = true;
			dispatchEvent( new KeyEvent(KeyEvent.ON_KEY_PRESS, evt.keyCode, evt.altKey, evt.ctrlKey, evt.shiftKey, evt.keyLocation ) );
        }
       
		/**
		 * KEY RELEASED
		 * @param	evt
		 */
        private static function keyReleased(evt:KeyboardEvent):void {
            if (evt.keyCode in keysDown) {
                delete keysDown[evt.keyCode];
            }
			dispatchEvent( new KeyEvent(KeyEvent.ON_KEY_RELEASE, evt.keyCode, evt.altKey, evt.ctrlKey, evt.shiftKey, evt.keyLocation) );
        }
       
		/**
		 * CLEAR KEYS
		 * @param	evt
		 */
        private static function clearKeys(evt:Event):void {
            keysDown = new Object();
        }
    }
}