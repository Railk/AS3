/**
* MOUSE DRAG
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	public class MouseDrag
	{	
		private var target:Object;
		private var rect:Rectangle;
		
		public function MouseDrag(target:Object,constraint:Object ) {
			this.target = target;
			this.rect = constraint.getRect(constraint.root);
			target.addEventListener(MouseEvent.MOUSE_DOWN,manageMouseEvent, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_UP,manageMouseEvent, false, 0, true);
		}
		
		public function stop():void {
			target.removeEventListener(MouseEvent.MOUSE_DOWN,manageMouseEvent);
			target.removeEventListener(MouseEvent.MOUSE_UP,manageMouseEvent);
		}
		
		private function manageMouseEvent(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN :
					target.startDrag(false,rect);
					break;
				case MouseEvent.MOUSE_UP :
					target.stopDrag();
					break;
			}
		}
	}
}
