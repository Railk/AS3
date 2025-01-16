/**
* lookupTable
* 
* @author rodney richard
* @version 0.2
*/

package railk.as3.painting 
{    
	import flash.utils.ByteArray;
	public class LookupTable 
	{
		public var bytes:ByteArray;
		public var height:int;
		public var width:int;
		
		/**
		 * CONBSTRUCTEUR
		 * 
		 * @param	H
		 * @param	W
		 */
		public function LookupTable(width:int, height:int):void {
			this.width = width;
			this.height = height;
			bytes = new ByteArray();
			bytes.position = 0;
		}
		
		/**
		 * MANAGE PIXELS
		 */
		public function addPixel( pos:int, alpha:int ):void{ bytes[pos] = alpha ; }
		public function getPixel( pos:int ):int { return bytes[pos]; }
		public function setPosition( pos:int ):void { bytes.position = pos; }
	}
}