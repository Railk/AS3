package railk.as3.effect.sticker 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class AbstractSticker extends Sprite {
		internal var angle:Number;
		internal var distance:Number;
		internal var faceContent:DisplayObject;
		internal var backContent:DisplayObject;
		internal var face:Sprite;
		internal var back:Sprite;
		internal var faceMask:Sprite;
		internal var backMask:Sprite;
		
		public function AbstractSticker(faceContent:DisplayObject, backContent:DisplayObject) {
			this.faceContent = faceContent;
			this.backContent = backContent;
			face = new Sprite();
			back = new Sprite();
			face.addChild(faceContent);
			back.addChild(backContent);
			faceMask = new StickerMask();
			backMask = new StickerMask();
			addChild(face);
			addChild(back);
			addChild(faceMask);
			addChild(backMask);
			face.mask = faceMask;
			back.mask = backMask;
			reset();
		}
		

		public function peelByPolarCoords(angle:Number, distance:Number):void {
			var maskMatrix:Matrix = new Matrix();
			maskMatrix.translate(distance, 0);
			maskMatrix.rotate(angle);
			faceMask.transform.matrix = maskMatrix;
			backMask.transform.matrix = maskMatrix;
			//
			var backMatrix:Matrix = new Matrix();
			backMatrix.scale(-1, 1);
			backMatrix.rotate(angle);
			backMatrix.translate(distance * 2, 0);
			backMatrix.rotate(angle);
			back.transform.matrix = backMatrix;
			back.visible = true;
			
			this.angle = angle;
			this.distance = distance;
		}
		

		public function peelByPoints(pickPoint:Point, dragPoint:Point):void {
			var diff:Point = pickPoint.subtract(dragPoint);
			if (dotProduct(diff, pickPoint) > 0) {
				var angle:Number = Math.atan2(diff.y, diff.x);
				diff.normalize(1);
				var distance:Number = dotProduct(Point.interpolate(pickPoint, dragPoint, 0.5), diff);
				peelByPolarCoords(angle, distance);
			} else {
				reset();
			}
		}
		

		public function reset():void {
			var maskMatrix:Matrix = new Matrix();
			maskMatrix.translate(1000, 0);
			faceMask.transform.matrix = maskMatrix;
			backMask.transform.matrix = maskMatrix;
			back.visible = false;
		}
		

		private function dotProduct(p0:Point, p1:Point):Number {
			return p0.x * p1.x + p0.y * p1.y;
		}
	}
}

import flash.display.Sprite;

class StickerMask extends Sprite {
	public function StickerMask() {
		graphics.beginFill(0x000000, 0);
		graphics.drawRect(-2000, -1000, 2000, 2000);
		graphics.endFill();
	}
}

