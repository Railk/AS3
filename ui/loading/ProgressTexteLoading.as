/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import flash.display.Shape;
	import railk.as3.text.TextLink;
	import railk.as3.display.UISprite;
	
	public class ProgressTexteLoading extends UISprite implements ILoading
	{	
		private var text:TextLink;
		private var textBG:TextLink;
		private var masker:Shape;
		private var _percent:Number;
		
		public function ProgressTexteLoading( texte:String, fontName:String, fontSize:Number, bgcolor:uint, color:uint ) { 
			super();
			
			textBG = new TextLink('bg','dynamic',texte,bgcolor,fontName,false,fontSize, 'center',false,false,false,false,true,'left');
			textBG.alpha = .5;
			addChild( textBG );
			
			masker = new Shape();
			masker.graphics.beginFill(0x000000, 1);
			masker.graphics.drawRect(0,0,1,fontSize+2);
			addChild(masker);
			
			text = new TextLink('bg', 'dynamic', texte, color, fontName, false, fontSize, 'center',false,false,false,false,true,'left');
			text.mask = masker;
			addChild( text );
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			masker.width = width * (value / 100);
		}
	}
}