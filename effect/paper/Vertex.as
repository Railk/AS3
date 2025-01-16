/**
 * Vertex
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.effect.paper
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
	import railk.as3.geom.distort.SDistort;

    public class Vertex extends Sprite
    {
		public var _x:Number;
        public var _y:Number;
		public var _x2:Number;
		public var _y2:Number;
		
		public var front:BitmapData;
		public var frontD:SDistort;
		public var back:BitmapData;
		public var backD:SDistort;
		public var imageRect:Rectangle;
		
		public var paper:Paper;
        public var vertexList:Array;
		public var v1:Vertex;
        public var v2:Vertex;
        public var v3:Vertex;
		public var v4:Vertex;
		
        public var part:Object;
        public var mc:Object;
        public var history:Object;
        
		
        public function Vertex() {
            history = new Array();
            vertexList = new Array();
        }

        public function init():void {
            x = _x;
            y = _y;
        }

        public function render():void {
            for each (_loc_1 in vertexList)
            {
                lineShape.graphics.lineStyle(0.5, 6316128, 0.5);
                lineShape.graphics.moveTo(0, 0);
                lineShape.graphics.lineTo(_loc_1.x - x, _loc_1.y - y);
            }
            if (v1 && v2 && v3) {
				var d1:Number = v3.x - v4.x;
				var d2:Number = v1.x - v2.x;
                var dist:Number = ((v3.y+v4.y)*0.5)-((v1.y+v2.y)*0.5);
                var tan:Number = Math.atan2(((!dist)?1:dist),((d1<0)?-d1:d1)-((d2<0)?-d2:d2));
                var brightness:Number = (tan-Math.PI*.5)/Math.PI;
                var bCorrection = 0;
                if (brightness > 0 && brightness < 0.4) bCorrection = (0.2 - Math.abs(brightness - 0.2)) * 2;
                brightness = brightness + bCorrection;
                brightness = Math.min(brightness, 0.9);
                brightness = Math.max(brightness, -0.6);
                if (frontD) {
                    frontD.TL.x = v1.x;
                    frontD.TL.y = v1.y;
                    frontD.TR.x = v2.x;
                    frontD.TR.y = v2.y;
                    frontD.BL.x = v3.x;
                    frontD.BL.y = v3.y;
                    frontD.BR.x = v4.x;
                    frontD.BR.y = v4.y;
                    if (v2.x > v1.x)
                    {
                        frontD.brightness = brightness;
                        frontD.updateFrame();
                        frontD.visible = true;
                    }
                    else frontD.visible = false;
                }
                if (backD) {
                    backD.TL.x = v1.x;
                    backD.TL.y = v1.y;
                    backD.TR.x = v2.x;
                    backD.TR.y = v2.y;
                    backD.BL.x = v3.x;
                    backD.BL.y = v3.y;
                    backD.BR.x = v4.x;
                    backD.BR.y = v4.y;
                    if (v1.x > v2.x)
                    {
                        backD.brightness = brightness;
                        backD.updateFrame();
                        backD.visible = true;
                    }
                    else backD.visible = false;
                }
            }
        }
		
		public function setFront(bmd:BitmapData):void {
            if (frontD) removeChild(frontD);
            if (v1 && v2 && v3) {
                var x:Number = Math.floor(bmd.width * imageRect.x);
                var y:Number = Math.floor(bmd.height * imageRect.y);
                var width:Number = Math.floor(bmd.width * imageRect.width);
                var height:Number = Math.floor(bmd.height * imageRect.height);
                var m:Matrix = new Matrix();
                m.translate( -x, -y);
				front = new BitmapData(width, height, false, 0);
                front.draw(bmd, m, null, null, new Rectangle(0, 0, width, height), true);
                frontD = new SDistort(paper, 0, 0, width, 0, 0, height, width, height, front);
                addChild(frontD);
            }
        }
		
        public function setBack(bmd:BitmapData):void {
            if (backD) removeChild(backD);
            if (v1 && v2 && v3) {
                var x:Number = Math.floor(bmd.width * imageRect.x);
                var y:Number = Math.floor(bmd.height * imageRect.y);
                var width:Number = Math.floor(bmd.width * imageRect.width);
                var height:Number = Math.floor(bmd.height * imageRect.height);
                var m:Matrix = new Matrix();
				m.scale(-1, 1);
                m.translate(bmd.width-x, -y);
                back = new BitmapData(width, height, false, 0);
                back.draw(bmd, m, null, null, new Rectangle(0, 0, width, height), true);
                backD = new SDistort(paper, 0, 0, width, 0, 0, height, width, height, back);
                addChild(backD);
            }
        }
		
        public function setBrightness(param1, param2):void {
            var _loc_3:*;
            _loc_3 = param2 * 100;
            param1.filters = [new ColorMatrixFilter([1, 0, 0, 0, _loc_3, 0, 1, 0, 0, _loc_3, 0, 0, 1, 0, _loc_3, 0, 0, 0, 1, 0])];
        }
    }
}