/**
 * CSS style class
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.styleSheet
{
	import flash.utils.Dictionary;
    final public class Style implements IStyle
    {
		public static const TYPE_ID:String = 'id';
		public static const TYPE_CLASS:String = 'class';
		public static const TYPE_ELEMENT:String = 'element';
		public static const TYPE_LINK:String = 'link';
		
		private static const NUMBER:RegExp = /[0-9][px|]{1,}/;
		private static const COLOR:RegExp = /#[a-zA-Z0-9]{6,}/;
		private static const BOOLEAN:RegExp = /true|false/;
		private static const URL:RegExp = /url([a-zA-Z0-9 .\/_-]{0,})/;
		
		private var related:Dictionary = new Dictionary(true);
		private var pairs:Dictionary = new Dictionary(true);
		private var colors:Object = {red:0xff0000,green:0x00ff00,yellow:0xffff00,blue:0x0000ff,white:0xffffff,black:0x000000}
		private var _id:String;
		private var _type:String;
		
		
        /**
         * CONSTRUCTEUR
         */
        public function Style(id:String, type:String) {
			this._id = id;
			this._type = type;
		}
		
		/**
		 * MANAGE PAIRS
		 */
		public function add(id:String, value:*):void {
			var splitValue:Array = value.split(' '), length:int =  splitValue.length;
			if ( length > 1) {
				var values:Array = [];
				for (var i:int = 0; i < length; i++) values[values.length] = stringTo(splitValue[i]);
				pairs[id] = values;
			}
			else pairs[id] = stringTo(value);
		}
		public function update(id:String,value:*):void { add(id, value); }
		public function del(id:String):void { delete pairs[id]; }
		
		/**
		 * MANAGE RELATED
		 */
		public function addRelated(style:IStyle):IStyle {
			related[style.id] = style;
			return style;
		}
		
		public function getRelated(id:String):IStyle {
			return (related[id] != undefined)?related[id]:null;
		}
		
		/**
		 * UTILITIES
		 */
		public function hasValue(id:String):Boolean { return (pairs[id] != undefined)?true:false; }
		public function getValue(id:String):* { return hasValue(id)?pairs[id]:null; }
		
		private function stringTo(value:String):* {
			if (value.match(NUMBER)) return Number(value.replace('px',''));
			else if (value.match(COLOR)) return stringToColor(value);
			else if (value.match(BOOLEAN)) return stringToBoolean(value);
			else if (value.match(URL)) return value.replace("url(",'').replace(")",'');
			else if (colors.hasOwnProperty(value)) return colors[value];
			return value;
		}
		
		private function stringToBoolean(bool:String):Boolean {
			var lookup:Object = { '1':1, 'yes':1, 'true':1, '0':0, 'no':0, 'false':0 };
			return lookup[bool];
		}
		
		private function stringToColor(color:String):uint {
			if ( color.charAt(0) == '#' ) color = color.replace(/#/, '0x');
			else if (color.substr(0, 2) != '0x') color = '0x' + color;
			return uint(color);
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			related = null;
		}
		
		/**
		 * TOSTRING
		 */
		public function toString():String { 
			var str:String='';
			for (var id:String in pairs) str+=' '+id+':'+pairs[id]+';'; 
			return '[STYLE TYPE_'+((type!=TYPE_LINK)?type.toUpperCase()+' ':'ELEMENT A:')+this.id.toUpperCase()+' >'+str+' ]';
		}
		
		/**
		 * TOOBJECT
		 */
		public function toObject():Object {
			var o:Object={};
			for (var id:String in pairs) o[id] = pairs[id]; 
			return o;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get data():Dictionary { return pairs; }
		public function get id():String { return _id; }
		public function get type():String { return _type; }
    }
}