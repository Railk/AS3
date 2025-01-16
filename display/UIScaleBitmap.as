/**
*	ScaleBitmapSprite
*	
*	@author		Didier Brun - http://www.bytearray.org
*	@version	1.0
*/

package railk.as3.display
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class UIScaleBitmap extends UISprite {
		
		private var _width:Number;
		private var _height:Number;
		
		private var bmd:BitmapData;
		private var inner:Rectangle;
		private var outer:Rectangle;
		private var outerWidth:Number;
		private var outerHeight:Number;
		private var minWidth:Number;
		private var minHeight:Number;

		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	bitmap
		 * @param	inner
		 * @param	outer
		 */
		public function UIScaleBitmap( bmd:BitmapData = null, inner:Rectangle, outer:Rectangle = null, pixelSnapping:String = 'auto', smoothing:Boolean = false ) {	
			this.inner = inner;
			this.outer = outer;
			this.bmd = bmd;
			
			if (outer!=null){		
				_width = outer.width;
				_height = outer.height;
				outerWidth = bmd.width - outer.width;
				outerHeight = bmd.height - outer.height;
			} else {
				_width = inner.width;
				_height = inner.height;
				outerWidth = 0;
				outerHeight = 0;	
			}
			minWidth = bmd.width - inner.width - outerWidth;
			minHeight = bmd.height - inner.height - outerHeight;
			
			scale(Math.floor(_width + outerWidth),Math.floor(_height + outerHeight));
		}
		
		/**
		 * draw
		 */
		public function scale(width:Number,height:Number):void {
			var x:int, y:int, i:int, j:int;
			var ox:Number=0, oy:Number;
			var dx:Number = 0, dy:Number;
			var wid:Number, hei:Number;
			var dwid:Number, dhei:Number;
			var sw:int = bmd.width;
			var sh:int = bmd.height;
			var mat:Matrix = new Matrix();
			var widths:Array=[inner.left, inner.width, sw-inner.right];
			var heights:Array=[inner.top, inner.height, h-inner.bottom];
			var resize:Point = new Point(	width - widths[0] - widths[2], height - heights[0] - heights[2]);
			if (outer==null) outer = new Rectangle(0,0,sw,sh);
	
			graphics.clear();
			for (x = 0; x < 3; x++) 
			{
				wid = widths[x];					
				dwid = x==1 ? resize.x:widths[x];
				dy=oy=0;
				for (y = 0; y < 3; y++)
				{
					hei = heights[y];
					dhei = y==1 ? resize.y:heights[y];
					if (dwid > 0 && dhei > 0)
					{	
						mat.a=dwid/wid;
						mat.d=dhei/hei;
						mat.tx=-ox*mat.a + dx;
						mat.ty=-oy*mat.d + dy;
						mat.translate(-outer.left,-outer.top);
						
						graphic.beginBitmapFill(bmd,mat,false,true);
						graphic.drawRect(dx - outer.left, dy - outer.top, dwid, dhei);
						graphic.endFill();
					}
					oy += hei;
					dy += dhei;
				}
				ox += wid;
				dx += dwid;
			}
			dispatchChange()
		}
		
	
		/**
		 * GETTER/SETTER
		 */
		override public function get width():Number { return _width; }
		override public function set width(w:Number):void {
			_width=Math.max(w,_minWidth);
			draw();
		}

		override public function get height():Number { return _height; }
		override public function set height(h:Number):void {
			_height=Math.max(h, _minHeight);
			draw();
		}
		
		public function get bitmapData():BitmapData { return bmd; }
		public function set bitmapData(b:BitmapData):void {
			bmd;
			draw();	
		}
	}
}