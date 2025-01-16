/**
 * EnterFrame
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.time 
{	
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.getTimer;
	import railk.as3.pattern.singleton.Singleton;
	
	public class EnterFrame extends EventDispatcher 
	{	
		public var time:Number=0;
		
		protected var ticker:Shape = new Shape();
		protected var startTime:Number=0;
		protected var elapsedTime:Number=0;
		
		/**
		 * SINGLETON
		 */
		public static function getInstance():EnterFrame{
			return Singleton.getInstance(EnterFrame);
		}
		
		public function EnterFrame() { Singleton.assertSingle(EnterFrame); }
		
		/**
		 * ACTION
		 */
		public function start():void {
			reset();
			if(!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener(Event.ENTER_FRAME, dispatch,false,0,true);
		}
		
		public function stop():void {
			pause();
			startTime = time = 0;
		}
		
		public function pause():void {
			elapsedTime = time;
			ticker.removeEventListener(Event.ENTER_FRAME, dispatch);
		}
		
		public function reset():void {
			startTime = getTimer();
		}
		 
		 /**
		 * NOTIFY
		 */
		protected function dispatch(evt:Event):void {
			time = getTimer()-startTime + elapsedTime;
			dispatchEvent(evt);
		}
	}
}
