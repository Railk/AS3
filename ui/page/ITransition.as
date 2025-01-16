/**
 * interface for a Transition from a page to another you can specify both in and out transition
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.display.Sprite;
	public interface ITransition
	{
		function easeIn(component:Sprite):void;
		function easeOut(component:Sprite, complete:Function):void;
		function easeInOut(component:Sprite, x:Number, y:Number, complete:Function):void;
	}
}