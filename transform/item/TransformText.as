/**
* 
* Tool for manipulating Text in flash
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform.item 
{	
	import flash.display.Stage;	
	public class TransformText extends TransformItem
	{
		public function TransformText( stage:Stage, name:String, object:* ) {	
			super( stage, name, object );
		}
		
		private function skew( item:*, constraint:String='' ):void { };
	}
}