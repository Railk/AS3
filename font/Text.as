/**
 * Font Text
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.font
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import railk.as3.display.UISprite;
	import railk.as3.ui.styleSheet.CSS;
	import railk.as3.font.line.*;
	
	public class Text extends UISprite
	{
		private var text:String;
		private var css:CSS;
		private var font:Dictionary = new Dictionary(true);
		
		public function Text(text:String, font:XML, css:CSS=null) {
			this.css = css;
			this.text = text;
			parseFont(font);
		}
		
		/**
		 * RENDER
		 * 
		 * @param	text
		 */
		public function render(pixel:Boolean=false):Text {
			var X:Number=0, Y:Number=0;
			for (var i:int = 0; i < text.length; ++i) {
				var letter:Letter = new Letter(font[text.charAt(i)]);
				addChild( letter[(pixel?'pixel':'vector')] );
			}
			return this;
		}
		
		/**
		 * PARSE FONT
		 * 
		 * @param	font
		 * @return
		 */
		private function parseFont(xml:XML):void {
			var length:int = xml.children().length();
			for (var i:int = 0; i < length; ++i) font[xml.children()[i].@id.toString()] = getGlyph(xml.children()[i].@id.toString(),Number(xml.children()[i].@precision),xml.children()[i].@struct.split(';'));
		}
		
		private function getGlyph(id:String, precision:Number, s:Array):Glyph {
			var g:Glyph = new Glyph(id,precision);
			for (var i:int = 0; i < s.length - 1; ++i) {
				var p1:Array = s[i].split(':')[1].split(','), p2:Array = s[i+1].split(':')[1].split(','), first:Boolean = (s[i].charAt() == 'M')?true:false;
				if (s[i+1].charAt() == 'L') g.addLine( new Line(P(p1[0],p1[1]), P(p2[0],p2[1])) );
				else g.addLine( new Curve(P(p1[0],p1[1]),P(p2[0],p2[1]),N(p2[2]),Boolean(N(p2[3]))) );
			}
			return g.setup();
		}
		
		private function P(x:String, y:String):Point { return new Point(N(x), N(y)); }
		
		private function N(s:String):Number { return Number(s); }		
	}
}