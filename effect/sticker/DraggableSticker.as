package railk.as3.effect.sticker 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	

	public class DraggableSticker extends Sticker {
		public var peeloutDetector:IPeeloutDetector;
		
		protected var hit:Sprite;
		protected var overPoint:Point;
		protected var mouseDown:Boolean = false;
		protected var dragging:Boolean = false;
		protected var draggingFilters:Array;
		
		
		public function DraggableSticker(faceContent:DisplayObject, backContent:DisplayObject, hitContent:DisplayObject) {
			super(faceContent, backContent);
			
			peeloutDetector = new BoundaryPeeloutDetector();
			
			hit = new Sprite();
			hit.addChild(hitContent);
			hit.alpha = 0;
			addChildAt(hit, 0);
			
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			back.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			back.buttonMode = true;
			
			draggingFilters = [new DropShadowFilter(5, 45, 0, 0.5, 8, 8, 1, 3)];
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		

		protected function rollOverHandler(event:MouseEvent):void {
			if (!mouseDown) {
				overPoint = new Point(mouseX, mouseY);
				var t:Point = overPoint.clone();
				t.normalize(20);
				peelByPoints(overPoint, overPoint.subtract(t));
				dispatchEvent(new StickerEvent(StickerEvent.HANDLE_OPEN));
			}
		}
		

		protected function rollOutHandler(event:MouseEvent):void {
			if (!mouseDown) {
				reset();
				dispatchEvent(new StickerEvent(StickerEvent.HANDLE_CLOSE));
			}
		}
		
		

		protected function mouseDownHandler(event:MouseEvent):void {
			mouseDown = true;
			dispatchEvent(new StickerEvent(StickerEvent.PEEL_BEGIN));
		}
		

		protected function mouseMoveHandler(event:MouseEvent):void {
			if (mouseDown) {
				if (!dragging) {
					var dragPoint:Point = new Point(mouseX, mouseY);
					peelByPoints(overPoint, dragPoint);
					if (peeloutDetector.detect(this)) {
						dragging = true;
						filters = draggingFilters;
						reset();
						dispatchEvent(new StickerEvent(StickerEvent.DRAG_BEGIN));
					}
				}
				if (dragging) {
					if (parent) {
						x = parent.mouseX;
						y = parent.mouseY - 5;
					}
				}
				event.updateAfterEvent();
			}
		}
		

		protected function mouseUpHandler(event:MouseEvent):void {
			if (mouseDown) {
				mouseDown = false;
				if (dragging) {
					dragging = false;
					filters = null;
					if (parent) {
						x = parent.mouseX;
						y = parent.mouseY;
					}
					dispatchEvent(new StickerEvent(StickerEvent.DRAG_END));
				} else {
					reset();
					dispatchEvent(new StickerEvent(StickerEvent.PEEL_END));
				}
			}
		}
		
		
		protected function addedToStageHandler(event:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		

		protected function removedFromStageHandler(event:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
	}
}


