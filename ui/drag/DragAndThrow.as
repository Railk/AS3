/**
 * 
 * drag and trown object with bounds or not
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.drag
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import railk.as3.event.CustomEvent;
	
	public class DragAndThrow extends EventDispatcher
	{
		private static var _stage:Stage;
		private static var firstItem:DragItem;
		private static var lastItem:DragItem;
		protected static var disp:EventDispatcher;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	   GESTION DES LISTENERS DE CLASS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
			if (disp == null) { disp = new EventDispatcher(); }
			disp.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      	}
		
    	public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
			if (disp == null) { return; }
			disp.removeEventListener(p_type, p_listener, p_useCapture);
      	}
		
    	public static function dispatchEvent(p_event:Event):void {
			if (disp == null) { return; }
			disp.dispatchEvent(p_event);
      	}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   	 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( stage:Stage ):void{
			_stage = stage;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   ENABLE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	o
		 * @param	orientation
		 * @param	useRect			object passed must contain a public object name content where the content to scroll is
		 * @param	bounds
		 */
		public static function enable( name:String, o:Object, orientation:String, useRect:Boolean=false, bounds:Rectangle=null  ):void {
			add( new DragItem(_stage, name, o, orientation, useRect, bounds) );
			lastItem.addEventListener( 'onScrollListDrag', manageEvent, false, 0, true );
		}
		
		public static function disable( name:String  ):void {
			getItem(name).removeEventListener( 'onScrollListDrag', manageEvent);
			getItem(name).dispose();
			remove( name );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							PROG DRAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function drag( name:String, x:Number, y:Number ):void {
			var from:DragItem = getItem( name ), walker:DragItem;
			if ( from == firstItem ) {
				walker = from.next;
				while ( walker ) {
					move( walker,x,y );
					walker = walker.next;
				}
			} else if (from == lastItem ) {
				walker = from.prev;
				while ( walker ) {
					move( walker,x,y );
					walker = walker.prev;
				}
			} else {
				var prev:DragItem = from.prev;
				while ( prev ) {
					move( prev,x,y );
					prev = prev.prev;
				}
				
				var next:DragItem = from.next;
				while ( next ) {
					move( next,x,y );
					next = next.next;
				}
			}
		}
		
		private static function move( item:DragItem, x:Number, y:Number ):void {
			if ( item.useRect ) {
				var rect:Rectangle = item.o.content.scrollRect;
				rect.y = y;
				rect.x = x;
				item.o.content.scrollRect = rect;
			} else {
				item.o.y = y;
				item.o.x = x;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE ITEMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function add( item:DragItem ):void {
			if (!firstItem) firstItem = lastItem = item;
			else {
				lastItem.next = item;
				item.prev = lastItem;
				lastItem = item;
			}
		}
		
		public static function getItem( name:String ):DragItem {
			var walker:DragItem = firstItem;
			while ( walker ) {
				if(walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public static function remove( name:String ):void {
			var i:DragItem = getItem(name);
			if (i.next) i.next.prev = i.prev;
			if (i.prev) i.prev.next = i.next;
			else if (firstItem == i) firstItem = i.next;
			i = null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function dispose():void {
			var walker:DragItem = firstItem;
			while ( walker ) {
				walker.dispose();
				walker = walker.next;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function manageEvent(evt:CustomEvent):void {
			switch(evt.type) {
				case 'onScrollListDrag' : dispatchEvent( new CustomEvent( evt.type, { name:evt.name } ) ); break;
				default : break;
			}
		}
	}
}