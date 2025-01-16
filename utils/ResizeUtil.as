/**
* 
* Resize Utils class
* 
* @author RICHARD RODNEY
* @version 0.3
*/


package railk.as3.utils 
{	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	public class ResizeUtil 
	{	
		public static function adaptScreen(o:DisplayObject,stage:Stage):void {
			o.width = stage.stageWidth; 
			o.scaleY = o.scaleX;
			if (o.height < stage.stageHeight) {
				o.height = stage.stageHeight;
				o.scaleX = o.scaleY; 
			}
		}
	}	
}		