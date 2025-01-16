/**
 * Coordinate System Vector
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.geom
{
	import flash.geom.Point;
	public class Vector2D
	{
		public var origin:Point;
		public var end:Point;
		public var distance:Number;
		public var dx:Number;
		public var dy:Number;
		
		public function Vector2D(origin:Point, end:Point) {
			this.origin = origin;
			this.end = end;
			dx = end.x - origin.x;
			dy = end.y - origin.y;
			distance = Math.sqrt( dx * dx + dy * dy);
		}
		
		public function toString():String {
			return '[VECTOR 2D > (x:'+this.dx+'), (y:' + this.dy + ') ]';
		}
	}
}