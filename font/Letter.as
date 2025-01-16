/**
 * Font Render
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.font
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import railk.as3.display.UISprite;
	import railk.as3.font.line.*;
	
	public class Letter extends UISprite
	{
		public var color:uint;
		public var size:Number;
		public var thickness:Number;
		public var struct:Glyph;
		
		private var _pixel:Bitmap;
		private var _vector:Shape;
		
		public function Letter(struct:Glyph, color:uint=0xffffff, size:Number=10, thickness:Number=1) {
			this.struct = struct;
			this.color = color;
			this.size = size;
			this.thickness = thickness;
		}
		
		/**
		 * RENDER
		 */
		public function get vector():Letter {
			clear();
			if(!_vector) {
				_vector = new Shape();
				_vector.graphics.clear();
				_vector.graphics.lineStyle(thickness, color, 1, true, 'normal', 'circle', 'round', 1);
				
				var length:int = struct.path.length, i:int = 0;
				while ( i < length ) {
					var p:Point = resize(struct.path[i]);
					if (!i) _vector.graphics.moveTo(p.x, p.y);
					else _vector.graphics.lineTo(p.x, p.y);
					i++
				}
			}
			addChild(_vector);
			return this;
		}
		
		public function get pixel():Letter {
			clear();
			if (!_pixel) {
				_pixel = new Bitmap( new BitmapData(size*(struct.width+thickness*2),size*(struct.height+thickness*2),true,0xff000000) );
				var length:int = struct.path.length, i:int = 0;
				while ( i < length-1 ) {
					lineTo(resize(struct.path[i],true), resize(struct.path[i+1],true))
					i++;
				}
			} 
			addChild(_pixel);
			return this;
		}
		
		/**
		 * UTILITIES
		 */
		private function resize(p:Point,round:Boolean=false):Point { return new Point(round?Math.round(size*p.x):size*p.x,round?Math.round(size*p.y):size*p.y); }
		
		private function lineTo(from:Point, to:Point):void {
			var x:Number=from.x, y:Number=from.y, x2:Number = to.x, y2:Number=to.y;
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
			
			if((shortLen ^ (shortLen >> 31))-(shortLen >> 31) > (longLen^(longLen >> 31))-(longLen >> 31)) {
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
				var yLonger:Boolean = true;
			}
			else yLonger = false;
			
			var inc:int = longLen<0?-1:1, multDiff:Number = longLen==0?shortLen:shortLen/longLen;
			if (yLonger) for (var i:int = 0; i != longLen; i += inc) _pixel.bitmapData.setPixel(x + i*multDiff, y+i, color);
			else for (i = 0; i != longLen; i += inc) _pixel.bitmapData.setPixel(x+i, y+i*multDiff, color);
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { 
			clear();
			_vector.graphics.clear();
			_pixel.bitmapData.dispose();
			_pixel = null;
			_vector = null;
		}
		
		private function clear():void {
			while(numChildren) removeChildAt(0);
		}
	}
}