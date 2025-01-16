/**
 * Gradient shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	import flash.geom.Matrix;
	import railk.as3.display.UISprite;
	
	public class GradientShape extends UISprite 
	{
		public var graphicsCopy:*;
		protected var copy:Boolean;
		protected var _type:String;
		
		/**
		* 
		* @param	colors     [ 0xffffff, ... ]
		* @param	W
		* @param	H
		* @param	rotation   0 | 360
		* @param	type      'radial' | 'linear'
		* @param	alphas    [ 100, 100, ...]
		* @param	ratios    [ 0, 0xFF, ... ]
		* @param	hide
		* @return
		*/
		public function GradientShape(colors:Array,W:Number,H:Number,rotation:Number,type:String,alphas:Array,ratios:Array,copy:Boolean=false ) {
			super();
			this.copy = copy;
			if ( copy ) graphicsCopy = new GraphicCopy(graphics);
			else graphicsCopy = graphics;
			
			_type = 'gradient';
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(W, H, rotation*0.0174532925, 0, 0);
			
			this.graphicsCopy.clear();
			this.graphicsCopy.beginGradientFill(type, colors, alphas, ratios, matrix, "pad","RGB"); 
			this.graphicsCopy.lineTo(W, 0);
			this.graphicsCopy.lineTo(W, H);
			this.graphicsCopy.lineTo(0, H);
			this.graphicsCopy.lineTo(0, 0);
			this.graphicsCopy.endFill();
		}
		
		override public function toString():String {
			return '[ GRAPHICSHAPE > ' + this.name.toUpperCase() + ', (type:' + this._type + ') ]';
		}
		
		public function get type():String { return _type; }
	}
	
}