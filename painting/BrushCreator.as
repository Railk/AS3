/**
* brushcreator
* 
* @author rodney richard
* @version 0.3
* 
* 
* TO DECIDE >> USE GETPIXEL32 OR USE A BYTEARRAY BUFFER there seems to do no have 
* gain or loss of speed between the two methods, stick with getpixel32 for now.
*/

package railk.as3.painting {
    
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	// _________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.painting.LookupTable;
	import railk.as3.utils.Utils;
	
	
	public class BrushCreator {
		
		// ________________________________________________________________________________________ VARIABLES
		private static var previousBrushes                         :Object = { };
		private static var buffer                                  :LookupTable;
		private static var byteBrush                               :ByteArray;
		private static var debord                                  :int;
		
		private static var _width                                  :int;                     
		private static var _height                                 :int;                     
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																  								 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	canvas
		 */
		public static function init( w:int, h:int, bmp:BitmapData ):void
		{
			_width = w;
			_height = h;
			
			var color:uint;
			var colorAlpha:int;
			var m:Boolean=true;
			var xLoop:int=0;
			var yLoop:int=0;
			var plop:int;
			var count:int = 0;
			debord = 200;
			
			buffer = new LookupTable(h,w);
			color = bmp.getPixel32( 0, 0 );
			colorAlpha = color >>> 24;
			
			while (true) {
				plop = m ? xLoop++ : --xLoop;
				buffer.addPixel( yLoop*w + plop, colorAlpha );
				if (xLoop == w|| xLoop == 0) {
					if (yLoop++ == h) break;
					m = !m;
				}
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																   AA CIRCLE BRUSH WITH SUPERSAMPLING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	bmp    			bitmap to draw (alpha=true)
		 * @param	x1     			first point x coord
		 * @param	y1     			first point y coord 
		 * @param	r      			radius
		 * @param	color    		color (0xaarrvvbb)
		 * @param   type       		brush type / AA_BRUSH / NORMAL_BRUSH / SOFT BRUSH
		 * @param   byteArrayDraw   booloean to determine if its only a byterray draw for replay stroke
		 * @param   byteArray       bytearray to draw the brush in;
		 * @return
		 */
		public static function circleBrush( bmp:BitmapData, x1:int, y1:int, r:Number, color:uint, type:String = "normal", byteArrayDraw:Boolean=false, byteArray:ByteArray=null ):BitmapData 
		{
			var col:uint;
			var colAlpha:int;
			var colorAlpha:int = color >>> 24;
			var size:int;
			
			var xLoop:int = 0;
			var yLoop:int = 0;
			var m:Boolean = true;
			var nx:int;
			var pos:int;
			
			if ( previousBrushes[String(r) + String(colorAlpha) + String(type)] != undefined ) 
			{
				byteBrush = previousBrushes[String(r) + String(colorAlpha) + String(type)];
			}
			else 
			{
				byteBrush = new ByteArray();
				
				if (type == "aa")
				{
					/////////////////////////////////////////////////////////
					byteBrush = aaBrush( x1, y1, r, colorAlpha );
					/////////////////////////////////////////////////////////
				}
				else if (type == "soft")
				{
					/////////////////////////////////////////////////////////
					byteBrush = softBrush( r, colorAlpha );
					/////////////////////////////////////////////////////////
				}
				else if (type == "normal") 
				{
					/////////////////////////////////////////////////////////
					byteBrush = normalBrush( r, colorAlpha );
					/////////////////////////////////////////////////////////
				}
				previousBrushes[String(r) + String(colorAlpha) + String(type)] = byteBrush;
			}	
			
			if ( type == 'aa' ){ size = r + r + 1.99; }
			else{ size = r + r + .99; }
			
			bmp.lock();
			while (true) {
				nx = m ? xLoop++ : --xLoop;
				pos = yLoop * size + nx;
				
				if ( byteBrush[pos] != 0 && byteBrush[pos] != undefined )
				{
					/*if ( byteArrayDraw)
					{
						writeByte( byteArray, x1 - r + nx, y1 - r + yLoop, byteBrush[pos] );
					}*/
					writePixel( bmp, x1 - r + nx, y1 - r + yLoop, byteBrush[pos], color );
				}
				
				if (xLoop == size || xLoop == 0) {
					if (yLoop++ == size) break;
					m = !m;
				}
			}
			bmp.unlock();
			return bmp;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		 AA BRUSH 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function aaBrush( x1:int, y1:int, r:Number, alpha:int ):ByteArray 
		{
			var brush:ByteArray = aaByteBrush( r,alpha );
			var brushAA:ByteArray = new ByteArray();
			var size:int = r+r+.99;
			var sizeAA:int = r+r+.99 + 1;
			
			var nx:Number = x1 - size/2 + .5;
			var ny:Number = y1 - size/2 + .5;
			var dx:Number = Math.abs(nx - int(nx));
			var dy:Number = Math.abs(ny - int(ny));

			for (var y:int = 0; y < sizeAA; y++) {
				for (var x:int = 0; x < sizeAA; x++) {
					brushAA[y * sizeAA + x] = 0;
				}
			}

			for ( y = 0; y < size; y++) {
				for ( x = 0; x < size; x++) {
					var brushAlpha:int = brush[y * size + x] & 0xff;

					brushAA[y * sizeAA + x] += int(brushAlpha * (1 - dx) * (1 - dy));
					brushAA[y * sizeAA + (x + 1)] += int(brushAlpha * dx * (1 - dy));
					brushAA[(y + 1) * sizeAA + x + 1] += int(brushAlpha * dx * dy);
					brushAA[(y + 1) * sizeAA + x] += int(brushAlpha * (1 - dx) * dy);
				}
			}
			return brushAA;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   	AA BYTE BRUSH 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function aaByteBrush( r:Number, alpha:int ):ByteArray 
		{
			var brush:ByteArray = new ByteArray();
			var size:int = r+r+.99;
			var sqrRadius:Number = r*r;
			var sqrRadiusInner:Number = (r-1)*(r-1);
			var sqrRadiusOuter:Number = (r+1)*(r+1);

			var offset:int = 0;
			for (var j:int = 0; j < size; j++) {
				for (var i:int = 0; i < size; i++) {
					var x:Number = (i + .5 - r);
					var y:Number = (j + .5 - r);

					var sqrDist:Number = x*x + y*y;

					if (sqrDist <= sqrRadiusInner) {
						brush[offset++] = alpha;
					} else if (sqrDist > sqrRadiusOuter) {
						brush[offset++] = 0;
					} else {
						var count:int = 0;
						for (var oj:int = 0; oj < 4; oj++) {
							for (var oi:int = 0; oi < 4; oi++) {
								x = i + oi * (1 / 4) - r;
								y = j + oj * (1 / 4) - r;

								sqrDist = x*x + y*y;
								
								if (sqrDist <= sqrRadius) {
									count += 1;
								}
							}
						}
						brush[offset++] = Math.min(count * 16, alpha);
					}
				}
			}
			return brush;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   	   SOFT BRUSH 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function softBrush( r:Number, alpha:int ):ByteArray 
		{
			var brush:ByteArray = new ByteArray();
			var size:int = r+r+.99;
			var sqrRadius:Number = r*r;
			
			var offset:int = 0;
			for (var j:int = 0; j < size; j++) {
				for (var i:int = 0; i < size; i++) {
					var x:Number = (i + .5 - r);
					var y:Number = (j + .5 - r);

					var sqrDist:Number = x*x + y*y;

					if (sqrDist <= sqrRadius) {
						brush[offset++] = alpha * (1 - (sqrDist / sqrRadius));
					} else {
						brush[offset++] = 0;
					}
				}
			}
			return brush;
		}

		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   	 NORMAL BRUSH 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function normalBrush( r:Number, alpha:int ):ByteArray 
		{
			var brush:ByteArray = new ByteArray();
			var size:int = r+r+.99;
			var sqrRadius:Number = r * r;
			var sqrDist:Number;
			var x:Number;
			var y:Number;
			var nx:int;
			var yLoop:int;
			var xLoop:int;
			var m:Boolean = true;
			
			var offset:int = 0;
			for (var j:int = 0; j < size; j++) {
				for (var i:int = 0; i < size; i++) {
					x = (i + .5 - r);
					y = (j + .5 - r);

					sqrDist = x*x + y*y;

					if (sqrDist <= sqrRadius) {
						brush[offset++] = alpha;
					} else {
						brush[offset++] = 0;
					}
				}
			}
			return brush;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					       WRITE BYTE 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function writeByte( byteArray:ByteArray, x:int, y:int, alpha:int ):void 
		{
			var pos:int = y * _width + x;
			if( Utils.sign( pos ) == 1 ){
				if ( byteArray[pos] < alpha )
				{
					byteArray[pos] = alpha;
				}
			}	
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					      WRITE PIXEL 
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function writePixel( bmp:BitmapData, x:int, y:int, alpha:int, color:uint ):void 
		{
			//var pos:int = (y+debord) * buffer.W + x;
			var colorOld:uint = bmp.getPixel32(x, y);
			var alphaOld:int = colorOld >>> 24;//buffer.getPixel( pos );
			
			if ( alphaOld < alpha )
			{
				var newColor:uint = redoColor( color, alpha );
				bmp.setPixel32(x, y, newColor);
				//trace( newColor );
				//buffer.addPixel( pos, alpha );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		   REDO COLOR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function redoColor( color:uint, alpha:int ):uint 
		{			
			var a:uint = alpha;
			var r:uint = color >>> 16 & 0xFF;
			var g:uint = color >>>  8 & 0xFF;
			var b:uint = color & 0xFF;
			color =  a << 24 | r << 16 | g << 8 | b;
			
			return color;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	PARSE SMALL BRUSH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function parseSmallBrushes( brushes:Array ):void 
		{
			for ( var i:int = 0; i < brushes.length; i++ )
			{
				var offset:int = 0;
				var brush:ByteArray = new ByteArray();
				brush.position = 0;
				var pixelStr:String = brushes[i].pixels;
				var pixels:Array = pixelStr.split(',');
				
				//--first
				for ( var j:int = 0; j < pixels.length; j++ )
				{
					brush[offset++] = pixels[j];
				}
				previousBrushes[ String(brushes[i].radius) + String(255) + String(brushes[i].type)] = brush;
				
				//--the 254 other alpha possibility of the brushes
				var step:int = .56;
				for ( var k:int = 254; k >=1 ; k-- )
				{
					brush = new ByteArray();
					offset = 0;
					for ( var l:int=0; l< pixels.length; l++ )
					{
						var newAlpha:Number = pixels[l] - step;
						if ( newAlpha < 1 ) newAlpha = 1;
						brush[offset++] = newAlpha;
					}
					step += step;
					previousBrushes[ String(brushes[i].radius) + String(k) + String(brushes[i].type)] = brush;
				}
			}
		}
	}
}