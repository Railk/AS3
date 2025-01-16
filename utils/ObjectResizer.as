/**
 * Object Resizer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{	
	public class ObjectResizer
	{
		static public function resizeHeight(o:Object, value:Number):void {
			o.width = (o.width*value)/o.height;
			o.height = value;
		}
		
		static public function resizeWidth(o:Object, value:Number):void {
			o.height = (o.height*value)/o.width;
			o.width = value;
		}
	}
}