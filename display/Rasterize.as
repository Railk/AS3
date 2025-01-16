/**
* 
* Rasterize
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.display 
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class Rasterize
	{	
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	o
		 * @param	scale
		 * @param	rect
		 * @return
		 */
		public function Rasterize(o:Object, scale:Number = 1 , rect:Rectangle=null ) {
			var H:int = (rect)?rect.height:(int(img.width)+1)*scale;
			var W:int = (rect)?rect.width:(int(img.height)+1)*scale;
			var matrix:Matrix = new Matrix();
		    matrix.identity();
			matrix.scale(scale,scale);
			
			var bmd = new BitmapData( W, H, true, 0x00FFFFFF );
			bmd.draw(o,matrix,null,null,rect,true);
			return new Bitmap(bmd,"auto",true);
		}
	}
}