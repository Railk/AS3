/**
 * Noise Gradient
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import railk.as3.display.UIBitmap;
	
	public final class NoiseGradient extends UIBitmap
	{
		private var _type:String;
		private var _amount:Number;
		private var _beginColor:uint;
		private var _endColor:uint;
		
		private var gradient:Shape = new Shape();
		private var matrix:Matrix = new Matrix();
		
		public function NoiseGradient(type:String, width:Number, height:Number, beginColor:uint, endColor:uint, rotation:Number=0) {
			_type = type;
			_amount = amount;
			_beginColor = beginColor;
			_endColor = endColor;
			this.smoothing = true;
			
			////////////////////////////
			create(width,height);
			////////////////////////////
		}
		
		/**
		 * CREATE THE NOISE GRADIENT
		 * @param	width
		 * @param	height
		 */
		private function create(width:Number, height:Number):void {
			// init
			var noise:BitmapData = new BitmapData(width, height, true, 0x00000000);
			bitmapData = noise.clone();
			matrix.identity();
			
			// create
			noise.noise(0, 0, 0xFF, 7, true);
			matrix.createGradientBox(width, height, rotation*0.0174532925, 0, 0);
			gradient.graphics.beginGradientFill(type,[endColor,beginColor],[100,100],[0,0xFF],matrix);
			gradient.graphics.drawRect(0, 0, width, height);
			gradient.graphics.endFill();
			
			// draw
			bitmapData.draw( gradient );
			bitmapData.draw( noise,null, new ColorTransform(1,1,1,.05,0,0,0,0) );
			
			//dispose intermediatary
			noise.dispose();
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { 
			this.bitmapData.dispose();
			gradient = null;
		}
		
		
		/**
		 * GETTER/SETTER
		 */
		public function get beginColor():uint { return _beginColor }
		public function set beginColor(value:uint):void { 
			_beginColor = value;
			create(width, height);
		}
		
		public function get endColor():uint { return _endColor; }
		public function set endColor(value:uint):void {
			_endColor = value;
			create(width, height);
		}
		
		override public function set height(value:Number):void { 
			height = value; 
			create(width, height);
		}
		
		override public function set width(value:Number):void { 
			width = value;
			create(width, height);
		}
		
		public function get amount():Number { return _amount; }
		public function set amount(value:Number):void { 
			_amount = value;
			create(width, height);
		}
		
		public function get type():String { return _type; }
		public function set type(value:String):void {
			_type = value;
			create(width, height);
		}
	}
}