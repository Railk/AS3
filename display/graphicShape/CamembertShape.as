/**
 * Camembert shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class CamembertShape extends GraphicShape
	{
		/**
		 * 
		 * @param	color
		 * @param	X
		 * @param	Y
		 * @param	radius
		 * @param	startAngle
		 * @param	endAngle
		 * @param	segments
		 * @param	lineThickness
		 * @param	lineColor
		 * @param	copy
		 */
		public function CamembertShape(color:uint=0x000000,X:Number=0,Y:Number=0,radius:Number=10,startAngle:Number=0,endAngle:Number=360,direction:int=1,copy:Boolean=false ) {
			super(copy);
			_type = 'camembert';
			this.color = color;
			drawCamembert(radius, startAngle, endAngle, direction);
			this.x = X;
			this.y = Y;
		}
		
		public function drawCamembert(radius:Number, startAngle:Number, endAngle:Number, direction:int):void {
			this.graphicsCopy.clear();
			this.graphicsCopy.beginFill(color, 1);
			startAngle = Math.PI * 2 * (startAngle / 360);
			endAngle = Math.PI * 2 * (endAngle / 360);
			var difference:Number = Math.abs(endAngle - startAngle);        
			var divisions:Number = Math.floor(difference / (Math.PI/4))+1;         
			var span:Number = direction * difference / (2*divisions);     
			var controlRadius:Number = radius / Math.cos(span);         
			
			this.graphicsCopy.moveTo((Math.cos(startAngle)*radius),Math.sin(startAngle)*radius);
			for(var i:Number=0; i<divisions; ++i){         
				endAngle    = startAngle + span;         
				startAngle  = endAngle + span;                
				this.graphicsCopy.curveTo(Math.cos(endAngle)*controlRadius,Math.sin(endAngle)*controlRadius,Math.cos(startAngle)*radius,Math.sin(startAngle)*radius);   
			}
			
			this.graphicsCopy.lineTo(0, 0);	
			this.graphicsCopy.endFill();
		}
	}
}