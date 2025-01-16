/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import railk.as3.display.graphicShape.*;
	import railk.as3.display.UISprite;
	import railk.as3.geom.CirclePointCoordinate;
	
	public class CircleDotLoading extends UISprite
	{	
		private var radius:Number;
		private var _percent:Number;
		private var _color:uint;
		public var segment:Number;
		
		public function CircleDotLoading( color:uint, radius:Number,dotNumber:int,dotRadius:Number ) { 
			super();
			_color = color;
			segment = 360 / dotNumber;
			var a:Array = CirclePointCoordinate.get(radius, radius, radius, 0, 360, dotNumber), alpha:Number=1;
			for (var i:int = a.length-1; i > -1; i--) {
				var c:CircleShape = new CircleShape(color, a[i].x, a[i].y, dotRadius);
				c.alpha = alpha;
				addChild( c );
				if (i > dotNumber * .5) alpha -= 1 / (dotNumber * .5);
				if (i == dotNumber * .5) alpha -= .1;
			}
		}
	}
}