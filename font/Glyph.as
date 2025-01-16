/**
 * Font Glyph
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.font
{
	import flash.geom.Point;
	import railk.as3.font.line.*;
	public class Glyph
	{
		public var id:String;
		public var width:Number=0;
		public var height:Number=0;
		public var precision:int;
		public var firstLine:ILine;
		public var lastLine:ILine;
		public var path:Array=[];
		
		private var prevPoint:Point;
		private var prevRad:Number = 0;
		
		public function Glyph(id:String,precision:int) { 
			this.id = id;
			this.precision = precision;
		}
		
		/**
		 * ADDLINE
		 * @param	line
		 */
		public function addLine(line:ILine):void {
			if (!firstLine) firstLine = lastLine = line;
			else {
				lastLine.next = line;
				line.prev = lastLine;
				lastLine = line
			}
		}
		
		/**
		 * SETUP
		 * @return
		 */
		public function setup():Glyph {
			var l:ILine = firstLine;
			while (l) {
				if (l is Curve) {
					(l as Curve).startRad = prevRad;
					var j:int=0, segs:Number=l.length/precision;
					while (j < precision+1) {
						var p:Point = S(l.getPoint(j * segs));
						if ( prevPoint.toString() != p.toString()) path[path.length] = prevPoint = p;
						j++
					}
				} else {
					if (!prevPoint) path[path.length] = S(l.begin);
					path[path.length] = prevPoint = S(l.end);
					prevRad = l.rad;
				}
				l = l.next;
			}
			return this;
		}
		
		private function S(p:Point):Point {
			width += p.x-((prevPoint)?prevPoint.x:0);
			height += p.y-((prevPoint)?prevPoint.y:0);
			return p;
		}
	}
}