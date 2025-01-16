/**
* MOUSE SCROLL
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui
{
	import flash.display.Stage;
	import flash.events.Event;
	
	public class MouseScroll
	{
		static public const VERTICAL:String = 'vertical';
		static public const HORIZONTAL:String = 'horizontal';
		
		private var target:Object;
		private var stage:Stage;
		private var direction:String;
		private var offset:Number;
		private var speed:Number;
		
		private var type:String;
		private var mouse:Number;
		private var size:Number;
		private var targetSize:Number;
		private var scroll:Number;
		
		public function MouseScroll(stage:Stage, target:Object, direction:String, offset:Number=0, speed:Number=8) {
			this.target = target;
			this.stage = stage;
			this.offset = offset;
			this.speed = speed;
			this.offset = offset;
			this.direction = direction;
			type = (direction == VERTICAL?'y':'x');
			stage.addEventListener(Event.ENTER_FRAME, move, false, 0, true);
		}
		
		private function move(evt:Event):void {
			size = (direction == VERTICAL)?stage.stageHeight:stage.stageWidth;
			targetSize = (direction == VERTICAL)?target.height:target.width;
			if (targetSize > size) {	
				mouse = (direction == VERTICAL)?stage.mouseY:stage.mouseX;
				scroll = -((targetSize+offset*2-size)*(mouse/size)-offset);
				target[type] += ((scroll - target[type]) / speed);
			}
			else {
				target[type] = size*.5 - targetSize *.5;
			}
			
            
		}
		
		public function dispose():void { stage.removeEventListener(Event.ENTER_FRAME, move); }
	}
}