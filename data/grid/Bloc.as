/**
* 
*  Bloc GRID
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.data.grid {
	
	public class Bloc 
	{	
		public var next:Bloc;
		public var prev:Bloc;
		
		public var id:int;
		public var beginX:int;
		public var beginY:int;
		public var endX:int;
		public var endY:int;
		public var width:int;
		public var height:int;
		public var used:Boolean; 
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Bloc( id:int, beginX:int, beginY:int, endX:int, endY:int, width:int, height:int ) {	
			this.id = id;
			this.beginX = beginX;
			this.beginY = beginY;
			this.endX = endX;
			this.endY = endY;
			this.height = height;
			this.width = width;
		}
		
		/**
		 * TO STRING
		 */
		public function toString():String { return "[Bloc > id is " + id + " beginning  at x:"+ beginX +",y:"+beginY+" and w:"+width+",h:"+height+"]"; }
	}
}