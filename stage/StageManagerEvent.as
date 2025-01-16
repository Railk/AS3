/**
* 
* StageManager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage 
{
	import flash.events.Event;
	public dynamic class StageManagerEvent extends Event
	{
		static public const ONSTAGERESIZE :String = "onStageResize";
		static public const ONMOUSEACTIVE :String = "onMouseActive";
		static public const ONMOUSEIDLE   :String = "onMouseIdle";
		static public const ONMOUSELEAVE  :String = "onMouseLeave";
		static public const ONMOUSEBACK   :String = "onMouseBack";
		
		public function StageManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}