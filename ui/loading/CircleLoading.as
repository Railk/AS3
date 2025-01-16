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
	
	public class CircleLoading extends UISprite implements ILoading
	{	
		private var cercle:CircleShape;
		private var bg:CircleShape;
		private var masker:CamembertShape;
		private var radius:Number;
		private var _percent:Number;
		private var _color:uint;
		
		public function CircleLoading( color:uint, bgColor:uint, radius:Number ) { 
			super();
			_color = color;
			this.radius = radius;
			bg = new CircleShape(bgColor,0,0,radius);
			cercle = new CircleShape(color,0,0,radius);
			cercle.alpha = 0;
			masker = new CamembertShape(0xff0000,0,0,radius,0,0);
			masker.rotation = -90;
			masker.x = radius;
			masker.y = radius;
			
			this.addChild(bg);
			this.addChild(cercle);
			this.addChild(masker);
			cercle.mask = masker;	
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			removeChild(masker);
			masker = new CamembertShape(_color, 0, 0, radius, 0, (((!value)?1:value) * 360) * .01);
			masker.rotation = -90;
			masker.x = radius;
			masker.y = radius;
			addChild(masker)
			cercle.alpha = 1;
		}
	}
}