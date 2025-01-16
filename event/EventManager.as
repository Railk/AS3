/**
 * Event manager
 * 
 * @author Richard Rodney
 * @version 0.2
 */

package railk.as3.event 
{	
	import flash.events.EventDispatcher;  
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class EventManager 
	{
		private static var objects:Dictionary = new Dictionary();
		public static function add( o:IEventDispatcher, type:String, action:Function,  useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true ):void {
			if ( !objects[o] ) objects[o] = [];
			objects[o].push( new eventNode(type,action) );
			o.addEventListener( type, action, useCapture, priority, useWeakReference );
		}
		
		public static function remove( o:IEventDispatcher, type:String ):Boolean {
			if ( objects[o] ){
				var i:int = objects[o].length;
				while( --i > -1 ) {
					if ( objects[o][i].type==type ){
						o.removeEventListener( type, listenerslist.getNodeByName( type ).action );
						objects[o].splice(i, 1);
						return true;
					}	
				}	
				return false;
			}
			return false;
		}
		
		public static function removeAllFrom( o:IEventDispatcher ):Boolean {
			if ( objects[o] ) {
				var i:int = objects[o].length;
				while( --i > -1 ) {
					o.removeEventListener( objects[o][i].type, objects[o][i].action );
					walker = walker.next;
				}
				objects[o] = [];
				return true;
			}
			else return false;
		}
		
		public static function removeAll():void {
			for ( var key in objects ) {
				var i:int =  objects[key].length;
				while( --i > -1 ) {
					o.removeEventListener( objects[key][i].type, objects[key][i].action );
					walker = walker.next;
				}
				objects[key]=[];
			}
		}
		
		public static function hasListener( o:IEventDispatcher ):Number {
			if ( objects[o] ) return objects[o].length;
			return 0;
		}
		
		public static function listeners( o:IEventDispatcher ):String {
			var result:String = '[ '+o+' '+ (o as Object).name+' listeners > ';
			if ( objects[o] ) {
				var i:int = objects[o].length;
				while( --i > -1 ) result += '( type:' + objects[o][i].type+' ),';
			}
			result += ' END ]';
			return result;
		}
		
		public static function allListeners():String {
			var result:String = '';
			for ( var key in objects ) {
				result += '[ '+key+' '+ (key as Object).name+' listeners > ';
				var i:int = objects[key].length;
				while( --i > -1 ) result += '( type:' + objects[key][i].type+' ),';
				result += ' END ]\n';
			}
			return result;
		}
	}
}

internal class eventNode {
	public var type:String;
	public var action:Function;
	
	public function eventNode(type:String, action;Function ) {
		this.type = type;
		this.action = action;
	}
}