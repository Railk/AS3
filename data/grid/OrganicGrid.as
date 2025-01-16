/**
 * OrganicGrid
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * TO ADD A BUNCH OF OPTIONS its just a first test
 * 
 */

package railk.as3.data.grid
{	
	import flash.events.Event;
	public class OrganicGrid
	{
		public const ASC_Data:String='ASC';
		public const DESC_Data:String='DESC';
		
		public var cells:Array=[];
		private var columns:int;
		private var rows:int;
		
		public var width:Number;
		public var height:Number;
		public var Wsep:Number;
		public var Hsep:Number;
		
		
		public function OrganicGrid( width:Number=NaN, height:Number=NaN, Wsep:Number=0, Hsep:Number=0 ) {
			this.width = width;
			this.height = height;
			this.Wsep = Wsep;
			this.Hsep = Hsep;
		}
		
		public function populate(parent:*, data:Array,type:String=ASC_Data):void {
			if (isNaN(width) && isNaN(height)) throw new Error('width and height cannot be both undefined');
			if (type == ASC_Data) data = data.reverse();
			
			var i:int = data.length, X:Number=0, Y:Number=0, first:Boolean=true;
			if(!isNaN(width) && isNaN(height)) {
				rows++;
				while ( --i > -1 ) {
					if ( first ) first = false;
					else {
						if (width < X+data[i].width+data[i+1].width+Wsep*2) {
							X = 0;
							Y += data[i].height + Wsep;
							++rows;
						} else {
							X += data[i].width+Wsep;
							if (rows == 1) columns++;
						}
					}	
					data[i].x = X;
					data[i].y = Y;
					parent.addChild(data[i]);
					cells[cells.length] = new OrganicGridCell(String(i),data[i]);
				}
			}
			setup(data.length);
		}
		
		public function getCell(content:*):OrganicGridCell {
			var i:int = 0;
			if (content is String) {
				for (i; i < cells.length ; ++i) if (cells[i].name == content) return cells[i];
				return null;
			} else {
				for (i; i < cells.length ; ++i) if (cells[i].content == content) return cells[i];
				return null;
			}
		}
		
		private function setup(length:int):void {
			var count:int=0;
			for (var i:int = 0; i < length; ++i) {
				if ( count == columns ) {
					if (cells[i + 1 + columns]) cells[i].addArc( cells[i + 1 + columns],'B' );
					count=-1;
				}
				else {
					if(cells[i+1] ) cells[i].addArc( cells[i + 1],'R' );
					if (cells[i + 1 + columns]) cells[i].addArc( cells[i + 1 + columns],'B' );
					if (cells[i + 1 + columns + 1]) cells[i].addArc( cells[i + 1 + columns + 1], 'BR' );
				}
				cells[i].bind();
				count++;
			}
		}
	}
}

import flash.events.Event;
internal class OrganicGridCell {
	
	public var name:String = 'undefined';
	public var arcs:Array = [];
	public var numArcs:int = 0;
	
	public var content:*;
	public var x:Number;
	public var y:Number;
	public var width:Number;
	public var height:Number;
		
	public function OrganicGridCell(name:String,content:*) {
		this.name = name;
		this.content = content;
		this.x = content.x;
		this.y= content.y;
		this.width = content.width;
		this.height = content.height;
	}
	
	public function bind():void { content.addEventListener(Event.CHANGE, check); }
	public function unbind():void { content.removeEventListener(Event.CHANGE, check); }	
	
	private function check(evt:Event):void { 
		for (var i:int = 0; i < arcs.length ; ++i) arcs[i].cell.update(this,arcs[i].pos);
	}
	
	public function update(from:OrganicGridCell,pos:String):void {
		if(content.y >= from.y && content.y < from.y+from.height ) content.x = int(x+(from.content.x-from.x)+(from.content.width-from.width));
		if(content.x >= from.x && content.x < from.x+from.width ) content.y = int(y+(from.content.y-from.y)+(from.content.height-from.height));
		if( pos == 'BR' && content.x < from.content.x+from.content.width) content.y = int(y+(from.content.y-from.y)+(from.content.height-from.height));
	}
	
	public function addArc(cell:OrganicGridCell,pos:String):void { arcs[numArcs++] = new OrganicGridArc(cell,pos); }
	public function removeArc(cell:OrganicGridCell):Boolean {
		var i:int = numArcs;
		while( --i > -1 ) {
			if (arcs[i] == cell) {
				arcs.splice(i, 1);
				numArcs--;
				return true;
			}
		}
		return false;
	}
}

internal class OrganicGridArc {
	public var cell:OrganicGridCell;
	public var pos:String;
	public function OrganicGridArc(cell:OrganicGridCell, pos:String) {
		this.cell = cell;
		this.pos = pos;
	}
}