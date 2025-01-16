/**
 * Triangle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	import flash.geom.Point;
	public class PolygonShape extends GraphicShape
	{
		public function PolygonShape(points:Array,color:uint=0x000000,lineThickness:Number=NaN, lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'ploygon';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.moveTo( points[0].x, points[0].y );
			var length:int = points.length;
			for (var i:int = 1; i < length; i++) this.graphicsCopy.lineTo( points[i].x, points[i].y );
			this.graphicsCopy.endFill();
			this.color = color;
		}
	}
}