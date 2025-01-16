/**
 * senocular graphics copy class
 */

package railk.as3.display.graphicShape {
	
	import flash.display.Graphics;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public dynamic class GraphicCopy extends Proxy {
		
		private var _graphics:Graphics;
		private var history:Array = new Array();
		

		public function get graphics():Graphics {
			return _graphics;
		}
		public function set graphics(g:Graphics):void {
			_graphics = g;
			copy(this);
		}
		
		public function GraphicCopy(graphics:Graphics = null) {
			_graphics = graphics;
		}
		
		public function copy(graphicsCopy:GraphicCopy):void {
			var hist:Array = graphicsCopy.history;
			history = hist.slice();
			if (_graphics) {
				var i:int;
				var n:int = hist.length;
				_graphics.clear();
				for (i=0; i<n; i += 2) {
					_graphics[hist[i]].apply(_graphics, hist[i + 1]);
				}
			}
		}
		
		flash_proxy override function callProperty(methodName:*, ... args):* {
			methodName = String(methodName);
			switch(methodName) {
				case "clear":
					history.length = 0;
					break;
				default:
					history.push(methodName, args);
			}
			if (_graphics && methodName in _graphics) {
				return _graphics[methodName].apply(_graphics, args);
			}
		}
	}
}