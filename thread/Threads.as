/**
 * THREADS
 * 
 * @author Richard Rodney
 * @version 0.1 
 */

package railk.as3.thread
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.Dictionary;
	
	public class Threads extends EventDispatcher
	{
		private var ticker:Shape = new Shape();
		private var idleLength:Number;
		private var running:Array=[];
		private var threads:Dictionary = new Dictionary(true);
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	cpuRatio
		 * @param	frameRate
		 */
		public function Threads(cpuRatio:Number, frameRate:Number) {
			idleLength = 1000 / frameRate * cpuRatio;
		}
		
		public function run(f:Function):void {
			runnning[running.length] = threads[f];
			if(!ticker.hasEventListener(Event.ENTER_FRAME) ticker.addEventListener(Event.ENTER_FRAME, loop, false, 100); 
		}
		
		public function kill(f:Function,end:Boolean=false):void {
			if (running.indexOf(f) != -1) running.splice(running.indexOf(f), 1);
			if (end) dispatchEvent( new ThreadsEvent(ThreadsEvent.ON_THREAD_COMPLETE, f) ); 
			if (!running.length) stop();
		}

		private function loop(evt:Event){
			var startTime:Number = getTimer(), i = running.length;
			while (getTimer() - startTime < idleLength && running.length > 0) while ( --i > -1 ) if(running[i].apply()) kill(running[i]);
		}
		
		private function stop():void {
			ticker.removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		/**
		 * MANAGE THREADS
		 */
		public function addThread(f:Function):void { if (threads[f]==undefined) threads[f] = f; }
		public function removeThread(f:Function):void { kill(f); delete threads[f]; }
		public function removeAllThreads():void { 
			threads = new Dictionary(true); 
			running = [];
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose() {
			stop();
			removeAllThreads();
		}
	}
}