/**
 * Bezier segments
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils{	
	public class Seg {
		public var p:Number;
		public var d1:Number;
		public var d2:Number;
		public function Seg(p:Number, p1:Number, p2:Number) {
			this.p = p;
			d1 = p1-p;
			d2 = p2-p;
		}
		public function calc(t:Number):Number { return p+t*(2*(1-t)*d1+t*d2); }
	}
}