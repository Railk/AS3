/**
* 
*  Cell GRID
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.data.grid 
{
	public class Cell 
	{	
		public var next:Cell;
		public var prev:Cell;
		
		public var id:int;
		public var contiguous:Object={};
		public var x:Number;
		public var y:Number;
		public var centerX:Number;
		public var centerY:Number;
		public var height:Number;
		public var width:Number;
		public var ligne:Number;
		public var colonne:Number;
		public var debug:Boolean;
		public var used:Boolean;
		
		
		/**
		 *CONSTRUCTEUR
		 */
		public function Cell( id:int, x:Number, y:Number, centerX:Number, centerY:Number, height:Number, width:Number, ligne:Number, colonne:Number ) {	
			this.id = id;
			this.x = x;
			this.y = y;
			this.centerX = centerX;
			this.centerY = centerY;
			this.height = height;
			this.width = width;
			this.ligne = ligne;
			this.colonne = colonne;
		}
	}
}