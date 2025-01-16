/**
* 
* Static class ResizeManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.ui.resize 
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ResizeManager 
	{		
		protected static var disp:EventDispatcher;		
		private static var firstItem:Item;
		private static var lastItem:Item;		
		private static var _width:Number=0;
		private static var _height:Number=0;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   LISTENERS DE CLASS
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
		// 																				  			 ADD ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	displayObject
		 * @param	action
		 * @param	group
		 */
		public static function add( name:String, displayObject:Object, action:Function = null, group:String = 'main' ):void {
			var i:Item = new Item(name, displayObject, group, action);
			if (!firstItem) firstItem = lastItem = i;
			else {
				lastItem.next = i;
				i.prev = lastItem;
				lastItem = i;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			MOVE ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function action( name:String, width:Number, height:Number ):void {
			_height = height;
			_width = width;
			getItem( name ).action.apply();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		MOVE ALL ITEM
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function groupAction( width:Number, height:Number, group:String = 'main' ):void {
			_height = height;
			_width = width;
			var walker:Item = firstItem;
			while ( walker ) {
				if ( walker.group == group ) walker.action.apply();
				walker = walker.next;
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE ITEMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):void {
			var walker:Item = firstItem;
			while ( walker ) {
				walker.action = null;
				walker.target = null;
				walker = walker.next;
			}
			dispatchEvent( new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ONE, { info:'removed'+ name +'item' } ));
		}
		
		public static function removeAll():void {
			var walker:Item = firstItem;
			firstItem = null;
			while ( walker ) {
				walker.action = null;
				walker.target = null;
				walker = walker.next;
			}
			lastItem = null;
			dispatchEvent( new ResizeManagerEvent( ResizeManagerEvent.ON_REMOVE_ALL, { info:"removed all item" } ));
		}
		
		public static function getItem( name:String ):Item {
			var walker:Item = firstItem;
			while ( walker ) {
				if (walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function toString():String {
			var result:String = '[ RESIZE ITEM >';
			var walker:Item = firstItem;
			while ( walker ) {
				result+= walker.name.toUpperCase()+','+ walker.group.toUpperCase()+' GROUP';
				walker = walker.next;
			}
			result += ' ]'
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		static public function get width():Number { return _width; }
		static public function get height():Number { return _height; }
	}
}

internal class Item {
	public var next:Item;
	public var prev:Item;
	public var name:String;
	public var target:Object;
	public var group:String;
	public var action:Function;
	
	public function Item(name:String,target:Object,group:String,action:Function) {
		this.name = name;
		this.action = action;
		this.target = target;
		this.group = group;
	}
}