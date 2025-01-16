/**
 * Circle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class CircleShape extends GraphicShape
	{
		public function CircleShape(color:uint=0x000000,X:Number=0,Y:Number=0,radius:Number=10,lineThickness:Number=NaN,lineColor:uint=0xFFFFFF,copy:Boolean=false ) {
			super(copy);
			_type = 'cercle';
			this.graphicsCopy.clear();
			if(lineThickness) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color,alpha);
			this.graphicsCopy.drawCircle(X+radius,Y+radius,radius);
			this.graphicsCopy.endFill();
			this.color = color;
		}
	}
	
}