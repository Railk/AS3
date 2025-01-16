/**
 * 
 * BRUSH SAMPLING
 * 
 * @author RICHARD RODNEY
 * @version 0.2
 * 
 */
package railk.as3.painting {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class BrushSampling extends Sprite 
	{	
		// ___________________________________________________________________ variables
		private var bmd                        :BitmapData;
		private var matrix                     :Matrix;
		
		
		// ___________________________________________________________________ fonction de conversion
		/**
		* 
		* @param	brush
		* @param	scale
		* @return
		*/
		public function sample( brush:Bitmap, scale:Number=1):Bitmap {
			
			matrix = new Matrix();
		    matrix.identity();
			matrix.scale(scale,scale);
			
			var H:int = (int(brush.height)+1)*scale; 
			var W:int = (int(brush.width)+1)*scale;
			
			bmd = new BitmapData( W, H, true, 0x00FFFFFF );
			bmd.draw(brush,matrix,null,null,null,true);
			brush = new Bitmap(bmd,"auto",true);
			return brush;
		}
		
		// ___________________________________________________________________ suppression du bitmapdata
		public function dispose():void {
			bmd.dispose();
			bmd = null;
		}
	}
}