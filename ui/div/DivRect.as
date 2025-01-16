/**
 * DIV RECT
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.div
{
	public class DivRect 
	{
		public var top:Number = 0;
		public var right:Number = 0;
		public var bottom:Number = 0;
		public var left:Number = 0;
		
		public function DivRect() { }
		
		public function set all(value:Number):void {
			top = right = bottom = left = value;
		}
		
		public function reset():void {
			top = right = bottom = left = 0;
		}
	}
}