package railk.as3.effect.sticker 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	

	public class BitmapPeeloutDetector implements IPeeloutDetector 
	{
		protected var checkBitmap:BitmapData;
		
		public function BitmapPeeloutDetector(width:uint = 500, height:uint = 1000) 
		{
			checkBitmap = new BitmapData(width, height, true, 0);
		}

		public function detect(sticker:StickerBase):Boolean {
			var matrix:Matrix = new Matrix();
			matrix.scale(-1, 1);
			matrix.rotate(sticker.angle);
			matrix.translate(sticker.distance, checkBitmap.height / 2);
			
			sticker.face.mask = null;
			checkBitmap.fillRect(checkBitmap.rect, 0);
			checkBitmap.draw(sticker.face, matrix);
			sticker.face.mask = sticker.faceMask;
			
			var bound:Rectangle = checkBitmap.getColorBoundsRect(0xFFFFFFFF, 0x00000000, false);
			return bound.isEmpty();
		}
	}
}
