/**
 * 
 * commands pattern action
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.pattern.mvc.command
{
	public class Action 
	{
		public var next:Action;
		public var prev:Action;
		
		public var name:String;
		public var action:Function;
		
		public function Action(name:String,action:Function) {
			this.name= name;
			this.action = action;
		}
		
		public function apply(params:Array):void { action.apply(null, params); }
	}
	
}