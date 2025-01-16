/**
 * Rectangle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class RoundRectangleShape extends GraphicShape
	{
		public function RoundRectangleShape(color:uint = 0x000000, X:Number = 0, Y:Number = 0, W:Number = 100, H:Number = 100, cornerW:Number = 30, cornerH:Number = NaN, lineThickness:Number = NaN, lineColor:uint = 0xFFFFFF, copy:Boolean = false, colorTransform:Boolean = false ) {
			super(copy);
			_type = 'roundRectangle';
			this.graphicsCopy.clear();
			if(!isNaN(lineThickness)) this.graphicsCopy.lineStyle(lineThickness,lineColor,1);
			this.graphicsCopy.beginFill(color);
			this.graphicsCopy.drawRoundRect(X,Y,W,H,cornerW,cornerH);
			this.graphicsCopy.endFill();
			if(cornerH) this.setScaleGrid((cornerH > cornerW)?cornerH:cornerW);
			if(colorTransform) this.color = color;
		}
	}
}