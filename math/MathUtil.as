/**
 * MathUtils
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.math
{	
	public class MathUtil
	{
		static public function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {  
			var dx:Number = x2 - x1, dy:Number = y2 - y1;  
            return Math.sqrt(dx*dx + dy*dy);  
        }  
		
		static public function randRange(min:Number, max:Number):Number {
			 return min + (max - min) * Math.random();
		}
		
		static public function floatRound(n:Number,floatCount:Number):Number {
			var r:Number = 1, i:Number = -1;
			while (++i < floatCount) r *= 10;
			return Math.round(n*r)/r ;
		}
	}
}