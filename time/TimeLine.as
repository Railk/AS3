/**
 * TimeLine
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.time 
{	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class TimeLine
	{	
		public const PLAYING:String = 'isPlaying';
		public const STOPED:String = 'isStoped';
		
		private var ticker:Shape = new Shape();
		private var time:int=0;
		private var startTime:int = 0;
		private var elapsedTime:int = 0;
		private var current:DelayItem;
		private var first:DelayItem;
		private var last:DelayItem;
		private var state:String;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function TimeLine() {
		}
		
		/**
		 * MANAGEMENT
		 */
		public function add(time:int, action:Function, ...params):TimeLine { 
			var delay:DelayItem = new DelayItem(time, action,params);
			if (!first) first = last = delay
			else insert(delay);
			return this; 
		}
		
		public function insert(delay:DelayItem):void {
			var walker:DelayItem = first, prev:DelayItem, next:DelayItem, inserted:Boolean=false;
			while (walker) {
				if ( delay.time < walker.time) {
					next = walker;
					if (prev) prev.next = delay;
					else first = delay
					delay.next = next;
					inserted = true;
					break;
				}
				prev = walker;
				walker = walker.next;
			}
			if (!inserted) {
				last.next = delay;
				last = delay;
			}
		}
		
		/**
		 * ACTION
		 */
		public function start():void {
			reset();
			if (!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			state = PLAYING;
		}
		
		public function stop():void {
			pause();
			startTime = time = 0;
		}
		
		public function pause():void {
			elapsedTime = time;
			ticker.removeEventListener(Event.ENTER_FRAME, update);
			state = STOPED;
		}
		
		public function reset():void {
			startTime = getTimer();
			current = first;
		}
		 
		private function update(evt:Event):void {
			time = getTimer()-startTime+elapsedTime;
			if (time >= current.time) {
				current.exec();
				current = current.next;
				if (!current) stop();
			}
		}
		
		public function clear():void {
			stop();
			first = last = null;
			first;
		}
		
		public function toString():String {
			var result:String = '[ TIMELINE ';
			var walker:DelayItem = first;
			while (walker) {
				result += ' ' + walker.time;
				walker = walker.next;
			}
			result += ' ]';
			return result;
		}
	}
}

internal class DelayItem {
	public var next:DelayItem;
	public var time:int;
	private var action:Function;
	private var params:Array;
	
	public function DelayItem(time:int, action:Function,params:Array) {
		this.time = time;
		this.action = action;
		this.params = params;
	}
	
	public function exec():void { action.apply(null, params); }
}
