/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import railk.as3.display.graphicShape.*;
	import railk.as3.display.UISprite;
	
	public class DonutLoading extends UISprite implements ILoading
	{	
		private var cercle:DonutShape;
		private var bg:DonutShape;
		private var masker:CamembertShape;
		private var _percent:Number;
		private var _color:uint;
		private var radius:Number;
		
		public function DonutLoading( color:uint, bgColor:uint, radius:Number, innerRadius:Number ) { 
			super();
			_color = color;
			this.radius = radius;
			bg = new DonutShape(bgColor,0,0,radius,innerRadius);
			cercle = new DonutShape(color,0,0,radius,innerRadius);
			masker = new CamembertShape(0x000000, radius, radius, radius, 0, 1);
			masker.rotation = -90;
			
			addChild(bg);
			addChild(cercle);
			addChild(masker);
			cercle.mask = masker;	
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			masker.drawCamembert(radius,0,(((!value)?1:value)*360)*.01, 1);
		}
	}
}