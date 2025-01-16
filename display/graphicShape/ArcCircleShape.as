/**
 * Arc Circle shape 
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display.graphicShape
{
	public class ArcCircleShape extends GraphicShape
	{
		public function ArcCircleShape(epaisseur:Number=1,color:uint=0x000000,centerX:Number=0,centerY:Number=0,radius:Number=10,startAngle:Number=0,arcAngle:Number=360,precision:int=100,copy:Boolean=false ) {
			super(copy);
			_type = 'arcCircle';
			this.graphicsCopy.clear();
			startAngle = startAngle/360;
			arcAngle = arcAngle/360;
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/precision;
			var X:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var Y:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			this.graphicsCopy.lineStyle( epaisseur, color,1,false,"normal","square","round",3 );
			this.graphicsCopy.moveTo(X, Y);
			for(var i:int=1; i<=precision; i++){
				var angle:Number = startAngle + i * angleStep;
				X = centerX + Math.cos(angle * twoPI) * radius;
				Y = centerY + Math.sin(angle * twoPI) * radius;
				this.graphicsCopy.lineTo(X, Y);
			}
			this.color = color;
		}
	}
	
}