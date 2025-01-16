/**
 * Font path
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.font.line
{
	import flash.geom.Point;
	public class Line implements ILine
	{
		private var _next:ILine;
		private var _prev:ILine;
		
		protected var _begin:Point;
		protected var _end:Point;
		protected var _length:Number;
		protected var _rad:Number;
		protected var _first:Boolean;
		public var dx:Number;
		public var dy:Number;
		
		public function Line(begin:Point, end:Point, first:Boolean=false) {
			dx = end.x - begin.x;
			dy = end.y - begin.y;
			_rad = Math.atan2(dy, dx);
			_begin = begin;
			_end = end;
			_first = first;
			_length = getLength();
		}
		
		protected function getLength():Number { return Math.sqrt(dx*dx+dy*dy); }
		
		public function getPoint(value:Number):Point {
			value = value/length;
			return new Point(begin.x+dx*value,begin.y+dy*value);
		}
		
		public function get first():Boolean { return _first; }
		public function get begin():Point { return _begin; }
		public function get end():Point { return _end; }
		public function get length():Number { return _length; }
		public function get rad():Number { return _rad; }
		
		public function get next():ILine { return _next; }
		public function set next(value:ILine):void {
			_next = value;
		}
		
		public function get prev():ILine { return _prev; }
		public function set prev(value:ILine):void {
			_prev = value;
		}
	}
}