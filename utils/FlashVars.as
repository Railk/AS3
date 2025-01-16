/**
 * Flash vars
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{	
	import flash.display.DisplayObject;
	public class FlashVars
	{
		static private var params:Object;
		static public function init(root:DisplayObject):void { params = root.loaderInfo.parameters; }
		static public function getByName(name:String,defaut:String=""):String { return (params[name] != undefined)?params[name]:defaut; }
	}
}