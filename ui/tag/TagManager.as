/**
* 
* Static class TagManager
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.ui.tag 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
	import railk.as3.data.grid.Grid;
	import railk.as3.data.grid.Cell;	
	
	public class TagManager 
	{
		private static var tag:Tag;
		private static var firstTag:Tag;
		private static var lastTag:Tag;

		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  			  ADD TAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function add( name:String, displayObjectName:String ):void {	
			if ( getTag(name) ) { getTag(name).addFile( displayObjectName ); }
			else {
				tag = new Tag( name, displayObjectName );
				if (!firstTag)  firstTag = lastTag = tag;
				else {
					lastTag.next = tag;
					tag.prev = lastTag;
					lastTag = tag;
				}
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   MANAGE TAG
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function remove( name:String ):Boolean {
			var t:Tag = getTag( name );
			if ( t ) {
				if (t.next) t.next.prev = t.prev;
				if (t.prev) t.prev.next = t.next;
				else if (firstTag == t) firstTag = t.next;
				t.dispose();
				t = null;
				return true;
			}
			return false;
		}
		
		public static function getTag( name:String ):Tag {
			var walker:Tag = firstTag;
			while (walker) {
				if ( walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public static function getTagByValue( value:Number ):Tag {
			var walker:Tag = firstTag;
			while ( walker ) {
				if ( walker.value == value ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	TAG CLOUD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	fontClassName   Nom de la typo
		 * @param	H
		 * @param	W
		 * @param	gridPrecision   DE 5 minimum  20 maximum
		 * @param	debug
		 * @param	debugContainer
		 * @return
		 */
		public static function tagCloud( fontClassName:String, H:Number, W:Number, gridPrecision:int = 5, upperCase:Boolean = true ):Array {
			var i:int, result:Array =[], minH:Number = gridPrecision, minW:Number = gridPrecision, cell:Cell, format:TextFormat, txt:TextField, blocs:Array = [];
			var tagSort:Array = toArray().sortOn('value', Array.DESCENDING | Array.NUMERIC);
			var grid:Grid = new Grid( "tag", H, W, minH, minW, 0, 0 );
			var multiplier:Number = computeSpace( grid, minH, minW, tagSort, blocs, fontClassName );
			
			//--compute blocs
			i = tagSort.length;
			while ( --i > -1 ) {
				var texte:String = tagSort[i].name;
				texte=(upperCase)?texte.toUpperCase():texte.toLowerCase();
				
				format = new TextFormat();
				format.font = fontClassName;
				format.align = "left";
				format.size = tagSort[i].value*multiplier;
				
				txt = new TextField();
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = texte;
				txt.setTextFormat( format );
				
				var tagWidth:Number = txt.width;
				var tagHeight:Number = txt.height;
				blocs.push( { height:toCellLength(tagHeight, gridPrecision), width:toCellLength(tagWidth, gridPrecision), extra:{texte:texte, size:tagSort[i].value*multiplier} } );
			}
			result = grid.getBlocsPlace( blocs );			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						COMPUTE SPACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function computeSpace( grid:Grid,  cellH:int, cellW:int, list:Array, blocs:Array, fontClassName:String ):Number {
			var result:Number = 1, nbCells:int = 0, tagWidth:Number, tagHeight:Number, format:TextFormat, txt:TextField, largest:int=0, highest:int=0;
				
			var i:int = list.length;
			while ( --i > -1 ) {
				format = new TextFormat();
				format.font = fontClassName;
				format.align = "left";
				format.size = list[i].value;
				
				txt = new TextField();
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = list[i].name;
				txt.setTextFormat( format );
				
				tagWidth = txt.width;
				tagHeight = txt.height;
				
				if ( tagWidth > largest ) largest = tagWidth;
				if ( tagHeight > highest ) highest = tagHeight;
				nbCells += int( (tagWidth / cellW )*(tagHeight / cellH ) ) + 1;				
			}
			
			if ( nbCells != grid.freeCells ) {
				result =  int(grid.freeCells / nbCells); 
				if ( largest * result > grid.width ) result = 1;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   TO CELL LENGTH
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function toCellLength(size:int,cellSize:int):int { return Math.ceil(size / 5) * cellSize; }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	 TAG LIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function toArray():Array {
			var result:Array = [], walker:Tag = firstTag;
			while (walker ) {
				result[result.length] = walker;
				walker = walker.next;
			}
			return result;
		}
	}
}