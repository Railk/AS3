/**
 * CSS style class
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.styleSheet
{
	import flash.utils.Dictionary;
    public interface IStyle
    {
		function add(id:String, value:*):void;
		function update(id:String, value:*):void;
		function del(id:String):void;
		function addRelated(style:IStyle):IStyle;
		function getRelated(id:String):IStyle;
		function hasValue(id:String):Boolean;
		function getValue(id:String):*;
		function dispose():void;
		function toString():String;
		function toObject():Object;
		function get data():Dictionary;
		function get id():String;
		function get type():String;
    }
}