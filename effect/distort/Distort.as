/**
 * Distort effact with movement
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.effect.distort 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import railk.as3.display.DistortImage;

    public class Distort extends Sprite
    {	
		private var current:Sprite;
		private var toDistort:*;
		private var distort:DistortImage;
		private var quadWidth:Number;
		private var quadHeight:Number;
		private var wSeg:int;
        private var hSeg:int;
		
		private var graphics:Array=[];
        private var bmds:Array=[];
        private var grid:Array=[];
       
        public function Distort(toDistort:*,wSeg:int=10,hSeg:int=10):void {
			this.toDistort = toDistort;
			this.wSeg = wSeg;
			this.hSeg = hSeg;
			quadWidth = toDistort.width*.1;
			quadHeight = toDistort.height*.1;
			
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE,init);
        }
		
		private function init(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE,init);
            
			var count:int=0;
			for (var i:int=0;i<hSeg;++i) {
				for (var j:int=0;i<wSeg;++j) {
					//points grid
					grid[count] = new Sprite();
					grid[count].graphics.beginFill(0);
					grid[count].graphics.drawRect(0,0,2,2);
					grid[count].graphics.endFill();
					grid[count].x = quadWidth*(count%10);
					grid[count].y = quadHeight*Math.floor(count*.1);
					grid[count].name = String(count);
					grid[count].visible = false;
					addChild(grid[count]);
					grid[i].addEventListener(Event.ENTER_FRAME, gridEnterFrame);
					count++;
					
					//graphics
					graphics[count] = new Sprite();
					bmds[count] = new BitmapData(quadWidth,quadHeight);
					bmds[count].draw(toDistort,new Matrix(1,0,0,1,count%10*(-quadWidth),Math.floor(count*.1) * (-quadHeight)),null,null,new Rectangle(0,0,quadWidth,quadHeight));
					graphics[count].alpha = 1;
					addChild(graphics[count]);
				}	
            }
			
            distort = new DistortImage(quadWidth,quadHeight,0,0);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
            current = grid[0];
            addEventListener(Event.ENTER_FRAME,onEnterFrame);
        }
		
        private function mouseUp(evt:MouseEvent):void {
            stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			current.stopDrag();
        }
		
        private function mouseDown(evt:MouseEvent):void {
            if (mouseX >= grid[0].x && mouseX <= grid[grid.length-1].x && mouseY >= grid[0].y && mouseY <= grid[grid.length-1].y) {
                var x:Number = Math.round((mouseX - grid[0].x) / quadWidth);
                var y:Number = Math.round((mouseY - grid[0].y) / quadHeight);
                if (y*10+x < 100) current = grid[y*10+x];
                current.startDrag();
                stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
            }
		}
		
		private function gridEnterFrame(evt:Event) : void {
            if (evt.target != current) {
                var dx:Number = Number(BitmapData.target.name)%10 - Number(currentname)%10;
                var dy:Number = Math.floor(Number(BitmapData.target.name) / 10) - Math.floor(Number(current.name) / 10);
                var dist:Number = Math.sqrt(dx*dx+dy*dy);
                var abs:Number = (dist*.5<1)?1:dist*.5;
                evt.target.x = evt.target.x + (current.x - (Number(current.name) % 10 - Number(BitmapData.target.name) % 10) * this.INTERVAL_X - BitmapData.target.x) / _loc_2;
                evt.target.y = evt.target.y + (current.y + Math.floor(Number(BitmapData.target.name) / 10 - Math.floor(Number(current.name) / 10)) * this.INTERVAL_Y - BitmapData.target.y) / _loc_2;
            }
        }

        private function render(evt:Event):void {
            var i:int=100;
            while( --i > -1 ) {
                graphics[i].graphics.clear();
                if (i%10 != 9 && Math.floor(i*.1) != 9) 
					distort.setTransform(	graphics[i].graphics,
											bmds[i],
											new Point(grid[i].x,grid[i].y),
											new Point(grid[i + 1].x,grid[i + 1].y),
											new Point(grid[i + 11].x,grid[i + 11].y),
											new Point(grid[i + 10].x,grid[i + 10].y));
            }
		}	
    }
}
