/**
 * CSS PARSING
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.styleSheet
{
    public interface ICSS
    {
		function dispose():void
		function toString():String;
		function toArray():Array;
		function hasStyle(name:String):Boolean;
		function getStyle(name:String):IStyle;
		function applyStyle(o:Object, name:String):Object;
		function get length():int;
    }
}