/**
 * Coordinate System Point
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.geom
{
	import flash.geom.Point;
	public class Point2D extends Point
	{
		public var system:CoordinateSystem;
		public function Point2D(x:Number, y:Number, system:CoordinateSystem=null) {
			super(x, y);
			this.system = system;
		}
		
		public function identity():void {
			super.x = 0;
			super.y = 0;
		}
		
		override public function toString():String {
			return '[ POINT2D > (x:' + this.x + '), (y:' + this.y + '), (system:' + this.system + ') ]';
		}
		
		public function get xProjection():Point { return (system)? system.getXProjection(this):new Point(); }
		public function get yProjection():Point { return (system)? system.getYProjection(this):new Point(); }
	}
}