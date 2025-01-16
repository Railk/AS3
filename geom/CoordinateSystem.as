/**
 * Repere de coordonnée
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.geom 
{
	import flash.geom.Point;
	public class CoordinateSystem 
	{
		public var origin:Point;
		public var x:Point;
		public var y:Point;
		public var vectorX:Vector2D;
		public var vectorY:Vector2D;
		private var determinant:Number;
		
		
		public function CoordinateSystem(origin:Point=null, x:Point=null, y:Point=null) {
			if( origin && x && y) define(origin, x, y);
		}
		
		public function define( origin:Point, x:Point, y:Point ):void {
			this.origin = origin;
			this.x = x;
			this.y = y;
			vectorX = new Vector2D(origin,x);
			vectorY = new Vector2D(origin,y);
			determinant = vectorY.dx * vectorX.dy - vectorX.dx * vectorY.dy;
		}
		
		public function getXProjection( p:Point ):Point {
			p = project(p);
			return new Point( origin.x+vectorX.dx*p.y, origin.y+vectorX.dy*p.y);	
		}
		
		public function getYProjection( p:Point ):Point {
			p = project(p);
			return new Point( origin.x+vectorY.dx*p.x, origin.y+vectorY.dy*p.x);
		}
		
		private function project( p:Point ):Point {
			var dx:Number = p.x - origin.x;
			var dy:Number = p.y - origin.y;
			return new Point( (vectorX.dy*dx-vectorX.dx*dy)/determinant, (-vectorY.dy*dx+vectorY.dx*dy)/determinant );
		}
		
		public function toString():String {
			return '[ COORDINATE SYSTEM > (origin:' + this.origin + '), (x:' + this.x + '), (y:' + this.y + ') END ]';
		}
	}
}