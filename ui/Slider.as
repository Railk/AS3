/**
* 
* SLIDER
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui {
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import railk.as3.display.graphicShape.RectangleShape;
	import railk.as3.display.UISprite;
	import railk.as3.text.TextLink;
	import railk.as3.TopLevel;
	import railk.as3.ui.div.Div;
	
	public class Slider extends Div
	{
		static public const VERTICAL:String = "vertical";
		static public const HORIZONTAL:String = "horizontal";
		
		public var barContainer:UISprite;
		public var bar:UISprite;
		public var tracker:UISprite;
		
		protected var hasTracker:Boolean;
		protected var rect:Rectangle;
		protected var percent:Number;
		
		/**
		 * 
		 * @param	mode	Slider.VERTICAL | Slider.HORIZONTAL
		 * @param	width
		 * @param	height
		 */
		public function Slider(mode:String, name:String, color:uint, bgColor:uint, width:Number, height:Number, hasTraker:Boolean = false) {
			this.buttonMode = true;
			this.bar = createBar(name,color, bgColor, width, height);
			if (hasTraker) {
				this.tracker = createTracker(width, height);
				this.hasTracker = hasTracker;
			}
			initListeners();
		}
		
		public function setPercent(percent:Number):void {
			bar.width = (barContainer.width * percent) / 100;
		}
		
		protected function createBar(name:String, color:uint, bgColor:uint, width:Number, height:Number):UISprite {
			addChild( new RectangleShape(bgColor, 0, 0, width, height) );
			addChild( new RectangleShape(color, 0, 0, 4, height) );
			var text:TextLink = new TextLink("label", "dynamic", name);
			text.x = 10;
			text.width = 50;
			text.height = 20;
			text.y = (height - text.height) * .5;
			addChild(text);
			
			barContainer = new UISprite();
			
				barContainer.addChild( new RectangleShape(0x333333, 0, 4, width - 60, height - 8) );
				bar = new RectangleShape(color, 0, 0, 0.1, height - 8);
				bar.y = 4;
				barContainer.addChild( bar );
				
			barContainer.x = 50;
			addChild( barContainer )
				
			return  bar;
		}
		
		protected function createTracker(width:Number, height:Number):UISprite {
			return new UISprite();
		}
		
		private function initListeners():void {
			barContainer.addEventListener(MouseEvent.MOUSE_DOWN, manageMouseEvent, false, 0 , true);
			barContainer.addEventListener(MouseEvent.MOUSE_UP, manageMouseEvent, false, 0 , true);
			TopLevel.stage.addEventListener(MouseEvent.MOUSE_UP, manageMouseEvent, false, 0 , true);
		}
		
		private function delListeners():void {
			barContainer.removeEventListener(MouseEvent.MOUSE_DOWN, manageMouseEvent);
			barContainer.removeEventListener(MouseEvent.MOUSE_UP, manageMouseEvent);
			TopLevel.stage.removeEventListener(MouseEvent.MOUSE_UP, manageMouseEvent);
		}
		
		override public function dispose():void {
			super.dispose();
			delListeners();
			removeChild(bar);
			if (hasTracker) removeChild(tracker);
			bar = null;
			tracker = null;
		}
		
		private function manageMouseEvent(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN : 
					barContainer.addEventListener(MouseEvent.MOUSE_MOVE, manageMouseEvent, false, 0, true);
					dispatchEvent( new SliderEvent(SliderEvent.TRACK_BEGIN) );
					dispatchEvent( new SliderEvent(SliderEvent.TRACK, (barContainer.mouseX/barContainer.width)*100) );
					bar.width = barContainer.mouseX;
					break;
				case MouseEvent.MOUSE_UP : 
					barContainer.removeEventListener(MouseEvent.MOUSE_MOVE, manageMouseEvent);
					dispatchEvent( new SliderEvent(SliderEvent.TRACK_COMPLETE) );
					break;
				case MouseEvent.MOUSE_MOVE : 
					dispatchEvent( new SliderEvent(SliderEvent.TRACK, (barContainer.mouseX/barContainer.width)*100) );
					bar.width = barContainer.mouseX;
					break;
				default : break;
			}
		}
		
	}
}