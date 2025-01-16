/**
* INFO BULLE
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui
{
	import flash.filters.DropShadowFilter;
	import railk.as3.display.UISprite;
	import railk.as3.text.Text;
	import railk.as3.ui.FontManager
	
	public class ToolTip extends UISprite
	{
		private var _font:uint;
		private var _color:uint;
		private var _size:uint;
		private var _align:String;
		private var _texte:String;
		private var _graphics:Object;
		private var _dropShadow:Boolean;
		private var txt:Text;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	texte
		 * @param	color
		 * @param	size
		 * @param	graphics
		 * @param	dropShadow
		 */
		public function ToolTip( texte:String, font:String, color:uint, size:Number, align:String, graphics:Object, dropShadow:Boolean=false ) {
			super();
			_font = font;
			_color = color;
			_size = size;
			_texte = texte;
			_graphics = addChild(graphics);
			_dropShadow = dropShadow;
			if (_dropShadow) _graphics.filters.push( new DropShadowFilter( 8, 45, 0xffffff, .1 ) );
			txt = addChild( new Text('tooltip','dynamic',_texte,_color,FontManager.getFont(_font),true,_size,_align,false, true) ) as Text;
			init();
		}
		
		private function init():void {
			_graphics.height = (_graphics.height*txt.width+20)/_graphics.width;
			_graphics.width = txt.width+20;
			txt.x2 = _graphics.x2;
			txt.y2 = _graphics.y2;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get font():uint { return _font; }
		public function set font(value:uint):void { txt.font = _font = value; }
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void { _color = txt.color = value; }
		
		public function get size():uint { return _size; }
		public function set size(value:uint):void { _size = txt.size = value; }
		
		public function get align():String { return _align; }
		public function set align(value:String):void { _align = txt.align = value; }
		
		public function get texte():String { return _texte; }
		public function set texte( value:String ):void {
			txt.appendText( '' );
			_texte = txt.text = value;
			init();
		}	
		
		public function get graphics():Object { return _graphics; }
		public function set graphics(value:Object):void {
			_graphics = value;
			removeChild( _graphics );
			addChild( _graphics );
			init();
		}
		
		public function get dropShadow():Boolean { return _dropShadow; }
		public function set dropShadow(value:Boolean):void {
			_dropShadow = value;
			var filters:Array = _graphics.filters;
			for (var i:int = 0; i < filters.length; i++) if ( filters[i] is DropShadowFilter) filters.slice(i, 1);
			_graphics.filters = filters;
		}
	}
}