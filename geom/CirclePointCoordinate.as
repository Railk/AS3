/**
 * Utilities to get coordinate of point on circle
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.geom
{	
	public class CirclePointCoordinate
	{
		static public function get(x:Number, y:Number, radius:Number, start:int, end:int, number:int):Array {
			var seg:Number = (end-start)/number;
			var angle:Number = start-90;
			var result:Array = [];
			while( --number > -1 ) {
				var rad:Number = angle*0.0174532925;
				result[result.length] = {x:x+Math.cos(rad)*radius,y:y+Math.sin(rad)*radius,angle:angle}  
				angle += seg;
			}
			return result;
		}
	}
}