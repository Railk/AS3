/**
* 
* Wytiwyg event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.witywig 
{
	import flash.events.Event;
	public dynamic class WitywigEvent extends Event{
			
		static public const ON_ACTIVATION                   	 :String = "onStageResize";
		static public const ON_DESACTIVATION                   	 :String = "onMouseActive";
		
		public function WitywigEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}