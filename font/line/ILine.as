/**
 * Font path
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.font.line
{
	import flash.geom.Point;
	public interface ILine 
	{	
		function getPoint(value:Number):Point;
		function get begin():Point;
		function get end():Point;
		function get first():Boolean;
		function get length():Number;
		function get rad():Number;
		function get next():ILine;
		function set next(value:ILine):void;
		function get prev():ILine;
		function set prev(value:ILine):void;
	}
}