/**
 * DIV STATE
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.div
{
	public class DivState
	{
		public var margin:DivRect;
		public var padding:DivRect;
		public var x:Number=0;
		public var y:Number = 0;
		public var maxWidth:Number=NaN;
		public var minWidth:Number = 0;
		public var maxHeight:Number=NaN;
		public var minHeight:Number=0;
		private var _stageWidth:Number=NaN;
		private var _stageHeight:Number = NaN;
		private var _width:Number=NaN;
		private var _height:Number=NaN;
		
		public function DivState() {
			margin = new DivRect();
			padding = new DivRect();
		}
		
		public function setWidth(value:*,max:Boolean=true):DivState { 
			_width = (!value)?NaN:(width is Number)?value:NaN;
			if (value && value is String) _stageWidth = (value.search('%') != -1)?Number(value.replace('%', '')) * .01:NaN;
			return this;
		}
		
		
		public function setHeight(value:*,max:Boolean=true):DivState {
			_height = (!value)?NaN:(value is Number)?value:NaN;
			if (value && value is String) _stageHeight = (value.search('%') != -1)?Number(value.replace('%', '')) * .01:NaN;
			return this;
		}
		
		public function get top():Number { return margin.top + padding.top; }
		public function get right():Number { return margin.right + padding.right; }
		public function get bottom():Number { return margin.bottom + padding.bottom; }
		public function get left():Number { return margin.left + padding.left; }
		
		public function reset():void { 
			x = y = 0;
			margin.reset();
			padding.reset();
		}
		
		public function get stageHeight():Number { return _stageHeight; }
		public function get stageWidth():Number { return _stageWidth; }
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
	}
}