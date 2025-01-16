/**
 * Font Curve
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * info: get the radius from the thx to the height of the curve -> radius = height*.5+(ab*ab)/(height*8);
 */

package railk.as3.font.line
{
	import flash.geom.Point;
	public class Curve extends Line implements ILine
	{
		private const PI:Number = Math.PI;
		
		public var radius:Number;
		public var angle:Number;
		public var startRad:Number;
		
		private var height:Number;
		private var clock:Boolean;
		
		public function Curve(begin:Point, end:Point, radius:Number, clock:Boolean=true, first:Boolean=false) {
			this.clock = clock;
			this.radius = radius;
			super(begin,end,first);
		}
		
		override protected function getLength():Number {
			var ab:Number = Math.sqrt(dx*dx+dy*dy);
			_rad = Math.asin((ab/(2*radius)))*2;
			height = radius - radius*Math.cos(_rad*.5);
			return radius*_rad;			
		}
		
		override public function getPoint(value:Number):Point {
			var r:Number;
			if (!clock) r = startRad - (_rad*value)/length + PI*.5;
			else r = startRad + (_rad*value)/length - PI*.5;
			var X:Number = ((3*PI)*.5-(PI*.5+(!startRad?PI:startRad)))*(radius/(PI*.5));
			var Y:Number = radius - ((3 * PI) * .5 - (PI * .5 + startRad)) * (radius / (PI * .5));
			return new Point((!clock?X:-X)+begin.x+Math.cos(r)*radius,(!clock?Y:-Y)+begin.y+Math.sin(r)*radius)
		}
	}
}