/**
* 
* Abstract Command
* 
* @author Richard Rodney
*/

package railk.as3.pattern.mvc.command
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.observer.Notifier;
	
	public class Command extends Notifier implements ICommand,INotifier
	{
		protected var _name:String = 'undefined';
		protected var firstAction:Action;
		protected var lastAction:Action;
		
		public function Command(MID:String, name:String = '') {
			this.MID = MID;
			if(name) _name = name;
		}
		
		public function addAction( name:String, action:Function ):ICommand {
			var a:Action = new Action(name, action );
			if (!firstAction) firstAction = lastAction = a;
			else {
				lastAction.next = a;
				a.prev = lastAction;
				lastAction = a;
			}
			return this;
		}
		
		protected function getAction(name:String):Action {
			var walker:Action = firstAction;
			while ( walker ) {
				if ( walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public function execute( name:String, params:Array = null ):ICommand { getAction(name).apply(params); return this; }
		
		public function get name():String { return _name; }
	}
}