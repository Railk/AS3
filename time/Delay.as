/**
 * Delay
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.time 
{	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import railk.as3.utils.Logger;
	
	public class Delay
	{	
		private var timer:Timer;		
		private var action:Function;
		private var params:Array;

		
		/**
		 * CONSTRUCTEUR
		 */
		public function Delay(delay:int, action:Function, ...params) {
			this.action = action;
			this.params = params;
			
			timer = new Timer(delay,1)
			timer.addEventListener(TimerEvent.TIMER, update);
			timer.start();
		}
		
		 
		private function update(evt:TimerEvent):void {
			timer.removeEventListener(TimerEvent.TIMER, update);
			action.apply(null, params);
			timer.stop();
			timer = null;
		}
	}
}
