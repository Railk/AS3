/**
* 
*  Grid
* 
* @author Richard Rodney
* @version 0.3
* 
* TODO > GET RANDOMS BLOC
*/

package railk.as3.data.grid 
{
	import railk.as3.data.grid.Cell;
	import railk.as3.data.grid.Bloc;
	import railk.as3.utils.Utils;
	
	
	public class Grid 
	{	
		public var columns:Number;
		public var rows:Number;
		public var height:Number;
		public var width:Number;
		
		private var firstCell:Cell;
		private var lastCell:Cell;
		private var cell:Cell;
		private var cellWidth:int;
		private var cellHeight:int;
		
		private var firstBloc:Bloc;
		private var lastBloc:Bloc;
		private var bloc:Bloc;
		private var blocs:Number;
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Grid( name:String, width:Number, height:Number, cellWidth:Number, cellHeight:Number, espaceW:Number, espaceH:Number ) {
			this.height = height;
			this.width = width;
			this.cellHeight = cellHeight;
			this.cellWidth = cellWidth;
			this.columns = Math.round(width/(cellWidth + espaceW));
			this.rows = Math.round(height / (cellHeight + espaceH));
			//////////////////
			init();
			//////////////////
		}
		
		public function init():void {
			var X:int=0, Y:int = 0, i:int=0, j:int = 0, m:Boolean = true, pos:int, count:int=0;
			while (true) {
				pos = m ? i++ : --i;
				cell = new Cell( count, X, Y, X + (cellWidth/2), Y+(cellHeight/2), cellHeight, cellWidth, pos, j );
				contiguous( j, pos, columns-1, rows-1 );
				
				if (!firstCell) firstCell = lastCell = cell;
				else {
					lastCell.next = cell;
					cell.prev = lastCell;
					lastCell = cell;
				}
				
				X+= cellWidth+espaceW;
				count++;
				
				if (i == columns || i == 0) {
					if (j++ == rows) break;
					X=0;
					Y+= cellHeight+espaceH;
					m = !m;
				}
			}
		}
		
		/**
		 * CELLS
		 */
		private function contiguous( x:int, y:int, h:int, w:int, r:int = 1 ):void {
			var vx:int = x + r, vy:int = y + r, count:int = 0;
			
			while ( vx >= x-r) {
				while ( vy >= y-r ) {
					if( vx==x && vy==y ){ }
					else {
						//--Haut_gauche OK
						if ( (x == 0 && vx != x-r) && (y == 0 && vy != y-r) ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--Haut Droite OK
						else if ( ( x == w && vx != x+r) && (y == 0 && vy != y-r) ){
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--Premiere ligne OK
						else if ( x != 0 && (y == 0 && vy != y - r) && x!=w ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--premiere colonne OK
						else if ( y != 0 && (x == 0 && vx != x - r) && y != h ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--entre les limites OK
						else if ( (x > 0 && x < w) && (y > 0 && y < h)  ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--derniere colonne
						else if ( y != 0 && (x == h && vx != x + r) && y != h ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--derniere ligne OK
						else if ( x != 0 && (y == h && vy != y + r) && x!=w ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--Bas_gauche OK
						if ( (x == 0 && vx != x-r) && (y == h && vy != y+r) ) {
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
						//--bas Droite OK
						else if ( ( x == w && vx != x+r) && (y == h && vy != y+r) ){
							cell.contiguous[count] = { x:vx, y:vy };
							count++;
						}
					}
					vy--;
				}
				vx--;
				vy = y+r;
			}
		}
		
		/**
		 * @param	type   "coord" | "center" | "place"    |
		 * @param	data    {x,y}  |  {x,y}   | {ligne,col} | 
		 */
		public function getCellByType( type:String, data:Object ):Cell {
			var walker:Cell = firstCell;
			while ( walker ) {
				if(type=='coord') if ( walker.x == data.x && walker.y == data.y ) return walker;
				else if(type =='center') if ( walker.centerX == data.x && walker.centerY == data.y ) return walker;
				else if(type=='place') if ( walker.ligne == data.ligne && walker.colonne == data.col ) return walker;
				walker = walker.next;
			}
			return null;
		}
		

		public function getRandomCell():Cell {
			var l = Utils.randRange( 0, rows-1);
			var c = Utils.randRange( 0, columns-1);
			return getCellByType( 'place', { ligne:l, col:c } );
		}
		
		
		/**
		 * BLOCS
		 */
		private function addBloc( id:int, beginX:int, beginY:int, endX:int , endY:int,  h:int, w:int ):void {
			bloc = new Bloc(id, beginX, beginY, endX , endY, w, h);
			if (!firstBloc) firstBloc = lastBloc = bloc;
			else {
				lastBloc.next = bloc;
				bloc.prev = lastBloc;
				lastBloc = bloc;
			}
			blocs++;
		}
		 
		public function getBlocsPlace( blocs:Array ):Array {
			var result:Array = [];
			addBloc( 1,0,0,width,height,width,height );
			
			blocs.sortOn('width', Array.DESCENDING | Array.NUMERIC );
			for (var i:int = 0; i < blocs.length; ++i) {
				var b:Object=blocs[i], o:Object = manageBlocs( b.width, b.height );
				o.extra = b.extra;
				result.push( o );
			}
			return result;
		}
		
		public function getRandomBlocsPlace( height:int, width:int, value:int, minSize:int, maxSize:int ):Array {
			var result:Array = new Array();
			return result;
		}
		
		private function manageBlocs( w:Number, h:Number ):Object {
			var result:Object, b:Bloc;
			var walker:Bloc = firstBloc;
			while (walker) {
				if ( walker.width >= w && walker.height >= h && !walker.used ) {
					b = walker;
					result = { x:walker.beginX, y:walker.beginY };
					break;
				}
				walker = walker.next;
			}
			
			//--Cell > used
			var c:Cell, x:int = b.beginX, y:int = b.beginY;
				
			while (y <= h+b.beginY ) {
				while ( x <= w+b.beginX ) {
					c = getCellByType( 'coord', { x:x, y:y } );
					c.used = true;
					x += cellWidth;
				}
				y += cellHeight;
				x = 0;
			}
			
			//-- redecoupage du bloc si necéssaire
			if ( b.width > w && b.height > h) {
				/*bloc1*/addBloc( blocs+1, b.beginX, h-cellHeight, b.width, b.height-cellHeight, b.width, b.height-h );
				/*bloc2*/addBloc( blocs+1, w+cellWidth, b.beginY, b.width, h, b.width-w, h  );
				b.width = w;
				b.height = h-cellHeight;
				b.endX = w;
				b.endY = h-cellHeight;
				b.used = true;
			}
			else if ( b.width > w && b.height == h ) {
				/*bloc1*/addBloc( blocs+1, w+cellWidth, b.beginY, b.width+cellWidth, b.height, b.width-w, b.height   );
				b.width = w;
				b.height = h-cellHeight;
				b.endX = w;
				b.endY = h-cellHeight;
				b.used = true;
			}
			else if ( b.width == w && b.height > h ) {
				/*bloc1*/addBloc( blocs+1, b.beginX, h-cellHeight, b.width, b.height-cellHeight, b.width, b.height-h  );
				b.width = w;
				b.height = h-cellHeight;
				b.endX = w;
				b.endY = h - cellHeight;
				b.used = true;
			}
			else if ( b.width == w && b.height == h ) b.used = true;
			return result;
		}
		
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			firstBloc = lastBloc = null;
			firstCell = lastCell = null;
		}
		
		
		/**
		 * GETTER/SETTER
		 */
		public function get coord():Array {
			var result:Array = new Array();
			var walker:Cell = firstCell;
			while ( walker ){
				result.push( { x:walker.x, y:walker.y } );
				walker = walker.next;
			}
			return result;
		}
		
		public function get usedCells():int {
			var result:int = 0;
			var walker:Cell = firstCell;
			while ( walker ) {
				if (walker.used) result++;
				walker = walker.next
			}
			return result;
		}
		
		public function get freeCells():int {
			var result:int = 0;
			var walker:Cell = firstCell;
			while ( walker ) {
				if (!walker.used) result++;
				walker = walker.next
			}
			return result;
		}
	}
}