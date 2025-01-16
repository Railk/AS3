/**
 * PIXELIZE
 */

package railk.as3.effect.pixelize
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class Pixelize 
	{
		private var original:BitmapData;
		private var bitmap:BitmapData;
		private var level:Number;
			
		/**
		 * CONSTRUCTEUR
		 * @param	bitmap
		 */
		public function Pixelize(bitmap:BitmapData) {
			this.bitmap = bitmap;
			this.original = bitmap.clone();
		}
		/**
		 * PIXELIZE
		 * @param	bmp
		 * @param	n
		 */
		private function pixelizeBitmap(bmp:BitmapData, n:int):Void {
			if (n < 6) return;
			for (var x:int=0; x < bmp.width; x+=n) for (var y:int=0; y < bmp.height; y+=n) bmp.fillRect(new Rectangle(x, y, n, n), bmp.getPixel(x, y));
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get level():Number { return level; }
		public function set level(n:Number):Void {
			var bmp:BitmapData = original.clone();
			pixelizeBitmap(bmp, n)
			bitmap.copyPixels(bmp, new Rectangle(0, 0, bmp.width, bmp.height), new Point(0, 0));
		}
	}
}