/**
* 
* Flow Engine event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.painting 
{
	import flash.events.Event;
	public dynamic class FlowEngineEvent extends Event
	{	
		static public const ONNOREPLAYPOINTS                 :String = "onNoReplayPoints";
		static public const ONREPLAYPROGRESS                 :String = "onReplayProgress";
		static public const ONREPLAYCOMPLETE                 :String = "onReplayComplete";
		
		public function FlowEngineEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}