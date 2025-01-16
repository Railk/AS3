/**
* 
* BrushState class
* 
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.painting {
		
	public class BrushState 
	{
		private static var _x:int;
		private static var _y:int;
		private static var _type :String;
		private static var _size :Number;
		private static var _radius:Number;
		private static var _alpha:int;
		private static var _color:uint;
		private static var _spacing:uint;
		private static var _pressure:int;
		private static var _cursor:int;
		private static var _flipX:Boolean;
		private static var _flipY:Boolean;
		private static var _status:String;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function init( x:int, y:int, type:String, size:Number, alpha:int, color:uint, pressure:int = 0, cursor:int = 1 ):void
		{
			_x = x;
			_y = y; 
			_type = type;
			_size = size;
			_radius = size/2;
			_alpha = alpha;
			_color = color;
			_spacing = 1;
			_pressure = pressure;
			_cursor = cursor;
			_status = 'begin';
			_flipX = false;
			_flipY = false;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GETTER/SETTER
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function get x():int { return _x; }
		
		public static function set x( value:int ):void { _x = value; }
		
		public static function get y():int { return _y; }
		
		public static function set y( value:int ):void { _y = value; }
		
		public static function get type():String { return _type; }
		
		public static function set type( value:String ):void { _type = value; }
		
		public static function get size():Number { return _size; }
		
		public static function set size( value:Number ):void {
			_size = value;
			_radius = value/2;
		}
		
		public static function get radius():Number { return _radius; }
		
		public static function get alpha():int { return _alpha; }
		
		public static function set alpha( value:int ):void { _alpha = value; }
		
		public static function get color():uint { return _color; }
		
		public static function set color( value:uint ):void { _color = value; }
		
		public static function get spacing():int { return _spacing; }
		
		public static function set spacing( value:int ):void { _spacing = value; }
		
		public static function get pressure():int { return _pressure; }
		
		public static function set pressure( value:int ):void { _pressure = value; }
		
		public static function get cursor():int { return _cursor; }
		
		public static function set cursor( value:int ):void { _cursor = value; }
		
		public static function get flipX():Boolean { return _flipX; }
		
		public static function set flipX( value:Boolean ):void { _flipX = value; }
		
		public static function get flipY():Boolean { return _flipY; }
		
		public static function set flipY( value:Boolean ):void { _flipY = value; }
		
		public static function get status():String { return _status; }
		
		public static function set status( value:String):void { _status = value; }
		
		public static function get state():Object {
			var result:Object = { x:_x, y:_y, type:_type, size:_size, radius:_radius, alpha:_alpha, color:_color, spacing:_spacing, pressure:_pressure, cursor:_cursor, status:_status };
			return result;
		}
	}
}