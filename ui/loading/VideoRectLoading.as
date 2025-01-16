/**
* 
* loading object class
* 
* @author RICHARD RODNEY
* @version 0.3
*/
package railk.as3.ui.loading
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import railk.as3.display.graphicShape.RectangleShape;
	import railk.as3.display.UISprite;
	import flash.events.MouseEvent;
	import railk.as3.event.DragEvent;
	import railk.as3.utils.Logger;
	import railk.as3.TopLevel;
	
	public class VideoRectLoading extends UISprite
	{	
		public var playBar:RectangleShape;
		public var loadBar:RectangleShape;
		public var bg:RectangleShape;
		public var tracker:*;
		private var trackerRect:Rectangle;
		private var isDragging:Boolean;
		
		private var _played:Number;
		private var _loaded:Number;
		
		public function VideoRectLoading(bgColor:uint,playedColor:uint,loadedColor:uint,x:Number,y:Number,width:Number,height:Number,tracker:*=null) { 
			super();
			this.tracker = tracker;
			bg = new RectangleShape(bgColor, x, y, width, height);
			playBar = new RectangleShape(playedColor, x, y, .1, height);
			loadBar = new RectangleShape(loadedColor, x, y, .1, height);
			addChild(bg);
			addChild(loadBar);
			addChild(playBar);
			if (tracker!=null) {
				addChild(tracker);
				tracker.addEventListener(MouseEvent.MOUSE_DOWN,manageMouseEvent, false, 0, true);
			}
		}
		
		private function manageMouseEvent(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN :
					isDragging = true;
					tracker.startDrag(false, new Rectangle(0, 0, bg.width, 0));
					tracker.addEventListener(MouseEvent.MOUSE_UP,manageMouseEvent, false, 0, true);
					TopLevel.stage.addEventListener(MouseEvent.MOUSE_UP,manageMouseEvent, false, 0, true);
					tracker.addEventListener(MouseEvent.MOUSE_MOVE,manageMouseEvent, false, 0, true);
					TopLevel.stage.addEventListener(MouseEvent.MOUSE_MOVE,manageMouseEvent, false, 0, true);
					break;
				case MouseEvent.MOUSE_UP :
					isDragging = false;
					tracker.stopDrag();
					tracker.removeEventListener(MouseEvent.MOUSE_MOVE, manageMouseEvent);
					TopLevel.stage.removeEventListener(MouseEvent.MOUSE_MOVE, manageMouseEvent);
					tracker.removeEventListener(MouseEvent.MOUSE_UP,manageMouseEvent);
					TopLevel.stage.removeEventListener(MouseEvent.MOUSE_UP, manageMouseEvent);
					dispatchEvent(new DragEvent(DragEvent.ON_STOP_DRAG,tracker.x));
					break;
				case MouseEvent.MOUSE_MOVE :
					e.updateAfterEvent();
					playBar.width = tracker.x;
					dispatchEvent(new DragEvent(DragEvent.ON_DRAG,tracker.x));
					break;
				default: break;
			}
		}
		
		public function get played():Number { return _played; }
		public function set played(value:Number):void {
			_played = value;
			if(!isDragging) playBar.width =  (value * bg.width) * .01;
			if(tracker!=null && !isDragging ) tracker.x = playBar.width;
		}
		
		public function get loaded():Number { return _loaded; }
		public function set loaded(value:Number):void {
			_loaded = value;
			loadBar.width =  (value * bg.width) * .01;
		}
	}
}