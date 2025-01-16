/**
 * Donut shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class DonutShape extends GraphicShape
	{
		public function DonutShape(color:uint=0x000000,X:Number=0,Y:Number=0,outerRadius:Number=10,innerRadius:Number=5,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'donut';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color, 1);
			this.graphicsCopy.drawCircle(outerRadius, outerRadius, outerRadius);
			this.graphicsCopy.drawCircle(outerRadius, outerRadius, innerRadius);
			this.graphicsCopy.endFill();
			this.color = color;
		}
	}
	
}