/**
 * 
 * UI DISTRORT SPRITE
 * 
 * 3D Transforms
 * Based on wh0's work:
 * http://wonderfl.net/c/sxQJ
 * With original matrix equations from Mathlab
 * 
 * @author zeh http://zehfernando.com/2011/interactive-perspective-distorted-sprites/
 * @modification Richard Rodney
 */

package railk.as3.display 
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;

	public class UIDistortSprite extends UISprite 
	{
		private var frameWidth:Number;
		private var frameHeight:Number;
		private var redraw:Boolean;
		
		private var TL:Point;
		private var TR:Point;
		private var BL:Point;
		private var BR:Point;

		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	width
		 * @param	height
		 */
		public function UIDistortSprite(width:Number,height:Number) {
			frameWidth = width;
			frameHeight = height;
			TL = new Point(0,0);
			TR = new Point(width,0);
			BL = new Point(0,height);
			BR = new Point(width, height);
			
			/////////////////
			setRender();
			/////////////////
		}
		
		/**
		 * REDRAW SCHEDULE
		 */
		private function setRender():void {
			if (redraw) return;
			addEventListener(Event.EXIT_FRAME, onExitFrameRender);
			redraw = true;
		}
		
		private function onExitFrameRender(e:Event): void {
			redraw = false;
			removeEventListener(Event.EXIT_FRAME, onExitFrameRender);
			render();
		}
		
		/**
		 * REDRAW
		 */
		private function render():void {
			////////
			reset();
			////////
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			transform.perspectiveProjection = pp;
			var v:Vector.<Number> = transform.matrix3D.rawData;
			var cx:Number = transform.perspectiveProjection.projectionCenter.x;
			var cy:Number = transform.perspectiveProjection.projectionCenter.y;
			var cz:Number = transform.perspectiveProjection.focalLength;
			
			v[12] = TL.x+x;
			v[13] = TL.y+y;
			v[0] = -(cx*TL.x*BL.y-cx*BL.x*TL.y-cx*TL.x*BR.y-cx*TR.x*BL.y+cx*BL.x*TR.y+cx*BR.x*TL.y+cx*TR.x*BR.y-cx*BR.x*TR.y-TL.x*BL.x*TR.y+TR.x*BL.x*TL.y+TL.x*BR.x*TR.y-TR.x*BR.x*TL.y+TL.x*BL.x*BR.y-TL.x*BR.x*BL.y-TR.x*BL.x*BR.y+TR.x*BR.x*BL.y)/(TR.x*BL.y-BL.x*TR.y-TR.x*BR.y+BR.x*TR.y+BL.x*BR.y-BR.x*BL.y) / frameWidth;
			v[1] = -(cy*TL.x*BL.y-cy*BL.x*TL.y-cy*TL.x*BR.y-cy*TR.x*BL.y+cy*BL.x*TR.y+cy*BR.x*TL.y+cy*TR.x*BR.y-cy*BR.x*TR.y-TL.x*TR.y*BL.y+TR.x*TL.y*BL.y+TL.x*TR.y*BR.y-TR.x*TL.y*BR.y+BL.x*TL.y*BR.y-BR.x*TL.y*BL.y-BL.x*TR.y*BR.y+BR.x*TR.y*BL.y)/(TR.x*BL.y-BL.x*TR.y-TR.x*BR.y+BR.x*TR.y+BL.x*BR.y-BR.x*BL.y) / frameWidth;
			v[2] = (cz*TL.x*BL.y-cz*BL.x*TL.y-cz*TL.x*BR.y-cz*TR.x*BL.y+cz*BL.x*TR.y+cz*BR.x*TL.y+cz*TR.x*BR.y-cz*BR.x*TR.y)/(TR.x*BL.y-BL.x*TR.y-TR.x*BR.y+BR.x*TR.y+BL.x*BR.y-BR.x*BL.y) / frameWidth;
			v[4] = (cx*TL.x*TR.y-cx*TR.x*TL.y-cx*TL.x*BR.y+cx*TR.x*BL.y-cx*BL.x*TR.y+cx*BR.x*TL.y+cx*BL.x*BR.y-cx*BR.x*BL.y-TL.x*TR.x*BL.y+TR.x*BL.x*TL.y+TL.x*TR.x*BR.y-TL.x*BR.x*TR.y+TL.x*BR.x*BL.y-BL.x*BR.x*TL.y-TR.x*BL.x*BR.y+BL.x*BR.x*TR.y)/(TR.x*BL.y-BL.x*TR.y-TR.x*BR.y+BR.x*TR.y+BL.x*BR.y-BR.x*BL.y) / frameHeight;
			v[5] = (cy*TL.x*TR.y-cy*TR.x*TL.y-cy*TL.x*BR.y+cy*TR.x*BL.y-cy*BL.x*TR.y+cy*BR.x*TL.y+cy*BL.x*BR.y-cy*BR.x*BL.y-TL.x*TR.y*BL.y+BL.x*TL.y*TR.y+TR.x*TL.y*BR.y-BR.x*TL.y*TR.y+TL.x*BL.y*BR.y-BL.x*TL.y*BR.y-TR.x*BL.y*BR.y+BR.x*TR.y*BL.y)/(TR.x*BL.y-BL.x*TR.y-TR.x*BR.y+BR.x*TR.y+BL.x*BR.y-BR.x*BL.y) / frameHeight;
			v[6] = -(cz*TL.x*TR.y-cz*TR.x*TL.y-cz*TL.x*BR.y+cz*TR.x*BL.y-cz*BL.x*TR.y+cz*BR.x*TL.y+cz*BL.x*BR.y-cz*BR.x*BL.y)/(TR.x*BL.y-BL.x*TR.y-TR.x*BR.y+BR.x*TR.y+BL.x*BR.y-BR.x*BL.y) / frameHeight;
			
			try { transform.matrix3D.rawData = v; }
			catch(e:Error){  trace("UIDistortSprite::Error: " + e); }
		}
		
		/**
		 * RESET
		 */
		public function reset(): void {
			transform.matrix3D = null;
			rotationX = 0;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get topLeftX():Number { return TL.x; }
		public function set topLeftX(value:Number): void { TL.x = value; setRender(); }
		public function get topLeftY():Number { return TL.y; }
		public function set topLeftY(value:Number): void { TL.y = value; setRender(); }
		
		public function get topRightX():Number { return TR.x; }
		public function set topRightX(value:Number): void { TR.x = value; setRender(); }
		public function get topRightY():Number { return TR.y; }
		public function set topRightY(value:Number): void { TR.y = value; setRender(); }
		
		public function get bottomLeftX():Number { return BL.x; }
		public function set bottomLeftX(value:Number): void { BL.x = value; setRender(); }
 		public function get bottomLeftY():Number { return BL.y; }
		public function set bottomLeftY(value:Number): void { BL.y = value; setRender(); }
		
		public function get bottomRightX():Number { return BR.x; }
		public function set bottomRightX(value:Number): void { BR.x = value; setRender(); }
		public function get bottomRightY():Number { return BR.y; }
		public function set bottomRightY(value:Number): void { BR.y = value; setRender(); }
	}
}