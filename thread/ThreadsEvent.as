/**
* 
* Threads event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.thread 
{
	import flash.events.Event;
	public dynamic class ThreadsEvent extends Event
	{
		static public const ON_THREAD_COMPLETE :String = "onThreadComplete";		
		public var thread:Function;
		
		public function ThreadsEvent(type:String, thread:Function, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			this.thread = thread;
		}
	}
}