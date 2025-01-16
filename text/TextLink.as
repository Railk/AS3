/**
* TextLink class to create textfield link
* 
* @author Richard Rodney
* @version 0.1
* 
*/

package railk.as3.text
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;	
	import railk.as3.display.UISprite;
	
	
	public class  TextLink extends UISprite
	{
		public static const AUTOSIZE_LEFT    :String = TextFieldAutoSize.LEFT;
		public static const AUTOSIZE_RIGHT   :String = TextFieldAutoSize.RIGHT;
		public static const AUTOSIZE_CENTER  :String = TextFieldAutoSize.CENTER;
		public static const DYNAMIC_TYPE     :String = TextFieldType.DYNAMIC;
		public static const INPUT_TYPE       :String = TextFieldType.INPUT;
		
		private var textLink                 :Sprite;
		private var format                   :TextFormat;
		private var texte                    :TextField;
		private var textMask                 :Sprite;
		
		private var _name                    :String;
		private var _type                    :String;
		private var _text                    :String; 
		private var _color                   :uint;
		private var _font                    :String; 
		private var _embedFont               :Boolean; 
		private var _size                    :Number; 
		private var _align                   :String;
		private var _pixelFont               :Boolean;
		private var _wordwrap                :Boolean; 
		private var _htmlText                :Boolean; 
		private var _selectable              :Boolean; 
		private var _width                   :Number; 
		private var _height                  :Number; 
		private var _autoSize                :Boolean; 
		private var _hasMask                 :Boolean; 
		private var _autoSizeType            :String;
		private var _backgroundColor         :uint;
		private var _borderColor             :uint;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	name
		 * @param	type         'dynamic'
		 * @param	text
		 * @param	color
		 * @param	font
		 * @param	embedFonts
		 * @param	size
		 * @param	align
		 * @param	selectable
		 * @param	autoSize
		 * @param	autoSizeType
		 * @param	width
		 * @param	height
		 */
		public function TextLink(	name:String = '', type:String = 'dynamic', text:String = '', color:uint = 0xffffff, 
									font:String = 'arial', embedFont:Boolean = false, size:Number = 10, align:String = 'left', 
									pixelFont:Boolean = false, wordwrap:Boolean = false, htmlText:Boolean = false, 
									selectable:Boolean = false, autoSize:Boolean = false, autoSizeType:String = '', 
									width:Number = 0, height:Number = 0, hasMask:Boolean = false, 
									backgroundColor:uint = 0x00FFFFFF, borderColor:uint = 0x00FFFFFF ) {
			super();
			super.name = _name = name;
			_type = type;
			_text = text;
			_color = color;
			_font = font;
			_embedFont = embedFont;
			_size = size;
			_align = align;
			_pixelFont = pixelFont
			_wordwrap = wordwrap;
			_htmlText = htmlText;
			_selectable = selectable;
			_width = width;
			_height = height;
			_autoSize = autoSize;
			_autoSizeType = autoSizeType;
			_hasMask = hasMask;
			_backgroundColor = backgroundColor;
			_borderColor = borderColor;
			init();
		}
		
		private function init():void {
			textLink = new Sprite();
			
				format = new TextFormat();
				format.color = _color;
				format.font =  _font;
				format.size = _size;
				format.align = _align;
			
				texte = new TextField();
				texte.name = _name;
				texte.type = _type;
				texte.wordWrap = _wordwrap;
				if ( !_htmlText ){
					texte.text = (_text) ? _text : ' ';
					texte.setTextFormat( format );
				} else { 
					texte.htmlText = (_text) ? _text : ' '; 
				}
				texte.width = texte.textWidth+_size;
				texte.height = texte.textHeight+_size;
				texte.embedFonts = _embedFont;
				texte.selectable = _selectable;
				if ( autoSize ) {
					texte.autoSize = _autoSizeType;
					if( width != 0) texte.width = _width;
					if( height != 0) texte.height = _height;
				} else {
					if( _width != 0) texte.width = _width;
					texte.height = (_height!=0)?_height:_size+2;
				}
				if ( _backgroundColor != 0x00FFFFFF ) {
					texte.background = true;
					texte.backgroundColor = _backgroundColor;
				}
				if ( _borderColor != 0x00FFFFFF ) {
					texte.border = true;
					texte.borderColor = _borderColor;
				}
				
				texte.mouseEnabled = _selectable;
				if(!_pixelFont) texte.antiAliasType = AntiAliasType.ADVANCED;
				textLink.addChild( texte );
				
			addChild( textLink );
			if (_hasMask) enableMask();
		}
		
		/**
		 * GESTION DU MASK
		 * @return
		 */
		public function enableMask():void {
			textMask = new Sprite();
			textMask.graphics.beginFill(0xff0000);
			textMask.graphics.drawRect(0, 0, 1, this.height + 3);
			addChild(textMask);
			textLink.mask = textMask;
		}
		
		public function get maskWidth():Number { return textMask.width; }
		public function set maskWidth(value:Number):void {
			textMask.width = value;
		}
		
		public function get maskHeight():Number { return textMask.height;  }
		public function set maskHeight(value:Number):void {
			textMask.height = value;
		}
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '[ TEXTLINK > ' + this._name + ' ]';
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get textfield():TextField { return texte; }
		
		override public function get name():String { return super.name; }
		override public function set name(value:String):void {
			super.name =  name;
			texte.name = value;
			_name = value;
		}
		
		public function get thickness():Number { return texte.thickness; } 
		public function set thickness(value:Number):void { texte.thickness = value; } 
		
		public function get type():String { return _type; }
		public function set type(value:String):void {
			texte.type = value;
			_type = value;
		}
		
		public function get text():String { return _text; }
		public function set text(value:String):void {
			texte.appendText('');
			texte.text = value;
			_text = value;
		}
		
		public function get textColor():uint { return _color; }
		public function set textColor(value:uint):void {
			texte.textColor = value;
			_color = value;
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void {
			texte.textColor = value;
			_color = value;
		}
		
		public function get font():String { return _font; }
		public function set font(value:String):void {
			format.font =  value;
			_font = value;
		}
		
		public function get embedFont():Boolean { return _embedFont; }
		public function set embedFont(value:Boolean):void {
			texte.embedFonts = value;
			_embedFont = value;
		}
		
		public function get leading():Number { return format.leading as Number; }
		public function set leading(value:Number):void { 
			format.leading = value;
			texte.setTextFormat( format );
		}
		
		public function get letterSpacing():Number { return format.letterSpacing as Number }
		public function set letterSpacing(value:Number):void { 
			format.letterSpacing = value;
			texte.setTextFormat( format );
		}
		
		public function get bold():Boolean { return format.bold; }
		public function set bold(value:Boolean):void { 
			format.bold = value;
			texte.setTextFormat( format );
		}
		
		public function get size():Number { return _size; }
		public function set size(value:Number):void {
			format.size = value;
			_size = value;
			texte.setTextFormat( format );
		}
		
		public function get align():String { return _align; }
		public function set align(value:String):void {
			format.align = value;
			_align = value;
		}
		
		public function get selectable():Boolean { return _selectable; }
		public function set selectable(value:Boolean):void {
			texte.selectable = value;
			_selectable = value;
		}
		
		public function get wordwrap():Boolean { return _wordwrap; }
		public function set wordwrap(value:Boolean):void {
			texte.wordWrap = value;
			_wordwrap = value;
		}
		
		override public function get width():Number { return texte.width; }
		override public function set width(value:Number):void {
			if (!_autoSize) {
				texte.width = value;
				_width = value;
			}	
		}
		
		override public function get height():Number { return texte.height; }
		override public function set height(value:Number):void {
			if (!_autoSize){
				texte.height = value;
				_height = value;
			}
		}
		
		public function get textWidth():Number { return texte.textWidth; }
		public function get textHeight():Number { return texte.textHeight; }
		
		public function get autoSize():Boolean { return _autoSize; }
		public function set autoSize(value:Boolean):void { _autoSize = value; }
		
		public function get autoSizeType():String { return _autoSizeType; }
		public function set autoSizeType(value:String):void {
			if (_autoSize){
				texte.autoSize = value;
				_autoSizeType = value;
			}
		}
	}
}