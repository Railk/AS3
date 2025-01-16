/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.link
{	
	import flash.utils.Dictionary;
	public interface ILink
	{	
		function addTarget(name:String, target:Object, event:String = 'mouse', action:Function = null, colors:Object = null, inside:Boolean = false, data:*= null):ILink;
		function action():void;
		function doAction():void;
		function undoAction():void;
		function enable():void;
		function disable():void;
		function dispose():void;
		function get prev():ILink;
		function set prev(value:ILink):void;
		function get name():String;
		function get group():String;
		function get navigation():Boolean;
		function get targets():Dictionary;
		function get active():Boolean;
		function set active(value:Boolean):void;
		function toString():String;
	}
}