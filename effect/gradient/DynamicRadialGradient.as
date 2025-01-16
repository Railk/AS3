package railk.as3.effect.gradient
{
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.display.InterpolationMethod;
    
    public class DynamicRadialGradient extends Sprite 
	{
        public var color:int;
        public function DynamicRadialGradient(color:uint) {
            this.Color = color;
        }
        
        private function redraw(p:Point):void {
			var center:Point = new Point (stage.stageWidth*.5, stage.stageHeight*.5), matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth * 2, stage.stageHeight * 2, Math.atan2(p.y-center.y, p.x-center.x), -center.x, -center.y);
			graphics.clear ();
			graphics.beginGradientFill( GradientType.RADIAL,[fillColor, 0x000000],[1, 1],[0x00, 0xFF],matrix,SpreadMethod.PAD,InterpolationMethod.RGB,Point.distance(p,center)/stage.stageWidth);
			graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill ();
        }
    }
}