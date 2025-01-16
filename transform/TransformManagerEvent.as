/**
* 
* transform manager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform 
{
	import flash.events.Event;
	public dynamic class TransformManagerEvent extends Event
	{	
		static public const ON_ITEM_OPEN                    :String = "ontemOpen";
		static public const ON_ITEM_SELECTED                :String = "onItemSelected";
		static public const ON_ITEM_MOVING                	:String = "onItemMoving";
		static public const ON_ITEM_STOP_MOVING             :String = "onItemStopMoving";
		
		public function TransformManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}