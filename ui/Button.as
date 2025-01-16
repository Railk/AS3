/**
* MOUSE SCROLL
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui
{
	public class Button
	{
		static public const OUT:String = 'out';
		static public const HOVER:String = 'hover';
		static public const DO:String = 'do';
		static public const UNDO:String = 'undo';
		
		public var state:String;
		public var doAction:Function;
		
		public function Button(target:Object) {
			
		}
		
		public function init() {
			
		}
		
		public function action(type:String,requester:Object,data:*):void {
			switch(type) {
				case 'do' :break;
				case 'undo' :break;
				case 'hover' :break;
				case 'out' :break;
			}
		}
	}
}
