/**
 * 
 * item for scroll list
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.scrollList
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.geom.Point;
	import railk.as3.event.CustomEvent;
	
	public class ScrollListItem extends EventDispatcher
	{
		public var next:ScrollListItem;
		public var prev:ScrollListItem;
		
		public var name:String;
		public var o:Object;
		public var height:Number;
		public var width:Number;
		public var oldX:Number;
		public var oldY:Number;
		public var scrollName:String;
		
		public function ScrollListItem( name:String, o:Object, scrollName:String ) {
			this.name = name;
			this.o = o;
			this.height = o.height;
			this.width = o.width;
			this.scrollName = scrollName;
			oldX = o.x;
			oldY = o.y;
			initListeners();
		}
		
		public function initListeners():void {
			o.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
		}
		
		public function dispose():void {
			o.removeEventListener( Event.ENTER_FRAME, manageEvent );
			o = null;
		}
		
		override public function toString():String {
			return '[ SCROLLITEM > ' + name + ' FROM '+scrollName+', ( x:' + globalXY.x + ' ), ( y:' + globalXY.y + ' ) ]';
		}
		
		private function manageEvent( evt:Event ):void {
			if ( oldY != globalXY.y || oldX != globalXY.x ) {
				oldX = globalXY.x;
				oldY = globalXY.y;
				dispatchEvent( new CustomEvent( 'onScrollItemChange', { item:this }) );
			}
		}
		
		public function get globalXY():Point {
			return o.parent.localToGlobal(new Point(x,y));
		}
		
		public function get x():Number { return o.x; }
		public function set x(value:Number):void {
			o.x = value;
		}
		
		public function get y():Number { return o.y; }
		public function set y(value:Number):void {
			o.y = value;
		}
		
		
	}
	
}