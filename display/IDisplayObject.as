/**
 * IDISPLAYOBJECT
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display 
{
	import flash.display.IBitmapDrawable;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	public interface IDisplayObject extends IBitmapDrawable 
	{
		function addChild(child:DisplayObject):DisplayObject;
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		function removeChild(child:DisplayObject):DisplayObject;
		function removeChildAt(index:int):DisplayObject;
		function getChildAt(index:int):DisplayObject;
		function getChildByName(name:String):DisplayObject;
		function getChildIndex(child:DisplayObject):int;
		function get stage():Stage;
	}
}