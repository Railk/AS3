/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import railk.as3.display.UISprite;
	
	public class TexteLoading extends UISprite implements ILoading
	{	
		private var texte:TextField;
		private var _percent:Number;
		
		public function TexteLoading( fontName:String, fontSize:Number, fontColor:uint, fontAlign:String ) { 
			super();
			var format:TextFormat = new TextFormat();
			format.font = fontName;
			format.color = fontColor;
			format.size = fontSize;
			format.align = fontAlign;
			
			texte = new TextField();
			texte.autoSize = TextFieldAutoSize.CENTER;
			texte.text = "00";
			texte.height = fontSize;
			texte.embedFonts = true;
			texte.selectable = false;
			texte.setTextFormat( format );
			addChild( texte );
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			texte.appendText('');
			texte.text = String(value);
		}
	}
}