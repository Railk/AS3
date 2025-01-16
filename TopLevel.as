/**
* TOPLEVEL
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class TopLevel
	{
		private static var inited:Boolean = false;
		public static var root:DisplayObject;
		public static var stage:Stage;
		public static var main:Sprite;
		public static var local:Boolean;
		public static function init(d:DisplayObject):void {
			if (inited) return;
			root = d.root;
			stage = d.stage;
			main = d as Sprite;
			local = (root.loaderInfo.url.indexOf("file") == 0)?true:false;
			inited = true;
		}
	}
}