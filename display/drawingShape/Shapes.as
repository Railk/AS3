/**
* 
* Shapes for the drawshape function of GraphicShape class
* 
* basic shapes that i often use
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.display.drawingShape
{
	import flash.geom.Point;
	public class Shapes
	{
		public static function arrow(size:int=1):Array { return [new Point(0,0),new Point(1,0),new Point(4,3),new Point(1,6),new Point(0,6),new Point(3,3)  ]; }
		public static function speaker(size:int=1):Array { return [new Point(6,0),new Point(6,9),new Point(3,6),new Point(0,6),new Point(0,3),new Point(3,3)]; }
	}
	
}