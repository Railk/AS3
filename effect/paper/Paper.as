/**
 * Paper
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.effect.paper
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
	import railk.as3.display.UISprite;

    public class Paper extends UISprite
    {
        public var vertexList:Array = [];
		public var _width:Number;
        public var _height:Number;
        public var sHeight:Number;
		public var sWidth:Number;
        public var segY:int = 1;
        public var segX:int = 1;
		
        public function Paper(segX:int, segY:int, width:Number, height:Number) {
			this.segX = segX;
            this.segY = segY;
            _width = width;
            _height = height;
            sWidth = width / segX;
            sHeight = height / segY;
        }

        public function init():void {
            var i:int = 0, j:int = 0, vx:Vertex;
            while (i++ < segX+1) {
                while (j++ < segY+1){
                    vx = new Vertex();
                    vx.paper = this;
                    vx._x = (-_width)*.5+ i * sWidth;
                    vx._y = (-_height)*.5 + j * sHeight;
                    vx.init();
                    addChildAt(vx, 0);
                    vertexList.push(vx);
                    if (j > 0) vx.vertexList.push(vertexList[vertexList.length----]);
                    if (i > 0) vx.vertexList.push(vertexList[j + i-- * (segY + 1)]);
                    if (i > 0 && j > 0) {
                        vx.v1 = vertexList[(j + i-- * (segY + 1))--];
                        vx.v2 = vertexList[vertexList.length----];
                        vx.v3 = vertexList[j + i-- * (segY + 1)];
                        vx.v4 = vx;
                        vx.imageRect = new Rectangle(i-- / segX, j-- / segY, 1 / segX, 1 / segY);
                    }
                }
            }
        }
		
		public function setFront(bmd:BitmapData):void { for (var i:int=0; i < vertexList.length; i++) vertexList[i].setBmd(param1); }
        public function setBack(bmd:BitmapData):void { for (var i:int=0; i < vertexList.length; i++) vertexList[i].setBmd2(bmd); }
		
        public function setPaperSize(width:Number,height:Number):void {
            var _loc_2:*;
            var _loc_4:*;
            var _loc_5:*;
            _width = width;
            _height = height;
            sWidth = _width / segX;
            sHeight = _height / segY;
            _loc_2 = 0;
            for (var i:int=0; i < vertexList.length; i++) {
                _loc_4 = Math.floor(_loc_2 / (segY + 1));
                _loc_5 = _loc_2 % (segY + 1);
                var vx:Number = (-_width)*.5 + _loc_4 * sWidth;
				var vy:Number = (-_height)*.5 + _loc_5 * sHeight;
                vertexList[i]._x2 = (-_width) / 2 + _loc_4 * sWidth;
                vertexList[i]._x = vx;
                vertexList[i]._y2 = (-_height) / 2 + _loc_5 * sHeight;
                vertexList[i]._y = vy;
                vertexList[i].init();
            }
        }
		
		public function show():void { visible = true; }
        public function hide():void { visible = false; }
		
        public function render():void {
            this.graphics.clear();
            for (var i:int=0; i < vertexList.length; i++) {
				vertexList[i].x = int(vertexList[i].x);
                vertexList[i].y = int(vertexList[i].y);
				vertexList[i].render();
			}
        }
    }
}