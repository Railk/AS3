/**
 * bounds
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.geom
{
	import flash.geom.Point;
	
	public class Bounds
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var top_left:Point;
		public var top:Point;
		public var top_right:Point;
		public var right:Point;
		public var bottom_right:Point;
		public var bottom:Point;
		public var bottom_left:Point;
		public var left:Point;
		public var center:Point;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Bounds( x:Number, y:Number, width:Number, height:Number ) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.getBounds();
		}
		
		/**
		 * GET BOUNDS
		 */
		private function getBounds():void {
			top_left = new Point(x,y);
			top_right = new Point(x+width,y);
			bottom_left = new Point(x,y+height);
			bottom_right = new Point(x+width,y+height);
			top = new Point(x+width*.5,y);
			bottom = new Point(x+width*.5,y+height);
			left = new Point(x,y+height*.5);
			right = new Point(x+width,y+height*.5);
			center = new Point(x+width*.5,y+height*.5);
		}
	}
}