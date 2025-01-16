/**
 * State Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import flash.utils.Dictionary;
	
	public class StateManager
	{
		static private var states:Dictionary = new Dictionary(true);
		
		static public function setState(key:String,value:String):void {
			states[key] = value;
		}
		
		static public function getState(name:String):String {
			if ( states[name] != undefined) return states[name];
			else return "";
		}
	}
}