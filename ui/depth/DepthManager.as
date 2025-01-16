/**
 * Depth manager (UNDER CONSTRUCTION)
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.depth
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class DepthManager
	{
		private var firstChild:Child;
		private var lastChild:Child;
		private var target:*;

		public function DepthManager(target:*) {
			this.target = target;
		}
		
		/**
		 * 
		 * @param	child 	a displayobject
		 * @param	index	a int or 'onTop'
		 * @return
		 */
		public function add( child:*, index:*= null ):* {
			var c:Child = new Child(child, ((index==null)?getIndex(index):index), getIndex(index));
			if (!firstChild) firstChild = lastChild = c;
			else { lastChild.next = c; c.prev = lastChild; lastChild = c; }
			target.addChildAt(child, c.realIndex);
			return child;
		}
		
		public function remove( child:* ):void {
			var walker:Child = firstChild;
			loop:while ( walker ) {
				if ( walker.target == child ) {
					if ( length > 1 ) {
						if ( walker == firstChild ) { firstChild = firstChild.next; firstChild.prev = null; }
						else if ( walker == lastChild ) { lastChild = lastChild.prev; lastChild.next = null; } 
						else { walker.prev.next = walker.next; walker.next.prev = walker.prev; }
					}
					else lastChild = firstChild = null; 
					walker.dispose();
					walker = null;
					target.removeChild(child);
					break loop;
				}
				walker = walker.next;
			}
		}
		
		public function get( name:String ):* {
			var walker:Child = firstChild;
			while (walker) {
				if ( walker.target.name == name) return walker.target
				walker = walker.next;
			}
			return null;
		}
		
		public function changeDepth( name:String, depth:int ):void {
			var i:int = target.numChildren;
			target.swapChildren( get(name), target.getChildAt(depth) );
		}
		
		public function getIndex( index:int ):int {
			var walker:Child = lastChild, index:int=0;
			while (walker) {
				if ( walker.index == 'onTop') index = (index>walker.realIndex)?walker.realIndex-1:index;
				walker = walker.prev;
			}
			return index;
		}
		
		public function dispose():void { target = null; }
		public function get length():int { return target.numChildren; }
	}
	
}