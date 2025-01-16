/**
 * line shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	public class LineShape extends GraphicShape
	{
		public function LineShape( color:uint, A:Point, B:Point, thickness:Number=1,copy:Boolean=false,colorTransform:Boolean=false ) {
			super(copy);
			_type = 'line';
			this.graphicsCopy.clear();
			this.graphicsCopy.lineStyle( thickness, color, 1);
			this.graphicsCopy.moveTo(A.x, A.y);
			this.graphicsCopy.lineTo(B.x, B.y);
			if(colorTransform) this.color = color;
		}
	}
}