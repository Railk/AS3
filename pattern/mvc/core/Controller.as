/**
* 
* MVC Abstract Controller
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import flash.utils.Dictionary;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.multiton.Multiton;
	
	public class Controller implements IController
	{
		protected var MID:String;
		protected var commandStack:Array=[];
		protected var commands:Dictionary = new Dictionary(true);
		
		public static function getInstance(id:String):Controller {
			return Multiton.getInstance(id,Controller);
		}
		
		public function Controller(id:String) { 
			MID = Multiton.assertSingle(id,Controller);
		}
		
		
		public function registerCommand( commandClass:Class, name:String='' ):void {
			commands[name] = new commandClass(MID,name);
		}
		
		public function executeCommand( name:String, action:String, params:Array=null ):void {
			commandStack[commandStack.length] = getCommand(name).execute( action, params );
		}
		
		public function getCommand(name:String):ICommand {
			return (commands[name]!=undefined)?commands[name]:null;
		}
		
		public function removeCommand( name:String ):void {
			delete commands[name];
		}
		
		public function hasCommand( name:String ):Boolean {
			return (commands[name]!=undefined)?true:false;
		}
	}
}