/**
* 
* Notification
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.observer
{
	import flash.events.Event;
	public class Notification extends Event 
	{	
		static public const NOTE:String = 'note';
		
		public var note:String;
		public var info:String;
		public var data:*;
		
		public function Notification(note:String, info:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false) {
			super('note', bubbles, cancelable);
			this.note = note;
			this.info = info;
			this.data = data;
		}
	}
}	