/**
* 
* ResizeManager event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.resize 
{
	import flash.events.Event;
	public dynamic class ResizeManagerEvent extends Event
	{		
		static public const ON_REMOVE_ONE                    :String = "onRemoveOne";
		static public const ON_REMOVE_ALL                    :String = "onRemoveAll";
		static public const ON_MOVE_FINISH                   :String = "onMoveFinish";
		static public const ON_ACTION_ERROR                  :String = "onActionError";
		
		public function ResizeManagerEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}