/**
 * Depth manager CHILD
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.depth
{	
	public class Child
	{
		public var next:Child;
		public var prev:Child;		
		public var index:*;
		public var realIndex:int;
		public var target:*
		
		public function Child(target:*,index:*,realIndex:int) {
			this.target = target;
			this.index = index;
			this.realIndex = realIndex;
		}
		
		public function dispose():void { 
			target = null; 
			next = prev = null;
		}
	}
}	