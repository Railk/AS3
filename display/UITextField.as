/**
 * Ui bitmap with set registration and change events
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.display
{	
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class UITextField extends TextField
	{
		private var rp:Point;
		private var _x2:Number = 0;
		private var _y2:Number = 0;
		private var _scaleX2:Number = 1;
		private var _scaleY2:Number = 1;
		private var _scaleXY:Number = 1;
		private var _rotation2:Number = 0;
		public var dispatch:Boolean = true;
		
		public function UITextField() {
			super();
			setRegistration(0,0);
		}
		
		public function setRegistration(x:Number, y:Number):void { rp = new Point(x, y); }
		public function getRegistration():Point { return rp; }
		
		/**
		 * X2
		 */
		public function get x2():Number { return global.x; }
		public function set x2(value:Number):void {
			x += value - global.x;
			_x2 = value;
		}

		/**
		 * Y2
		 */
		public function get y2():Number { return global.y; }
		public function set y2(value:Number):void {
			y += value - global.y;
			_y2 = value;
		}
		
		/**
		 * SCALEX2
		 */
		public function get scaleX2():Number { return _scaleX2; }
		public function set scaleX2(value:Number):void {
			setProperty( value, 'scaleX' );
			_scaleX2 = value;
		}
		
		/**
		 * SCALEY2
		 */
		public function get scaleY2():Number { return _scaleY2; }
		public function set scaleY2(value:Number):void {
			setProperty( value, 'scaleY' );
			_scaleY2 = value;
		}
		
		/**
		 * SCALEXY
		 */
		public function get scaleXY():Number { return _scaleXY; }
		public function set scaleXY(value:Number):void {
			setProperty( value, 'scaleX', 'scaleY' );
			_scaleXY = value;
		}
		
		/**
		 * ROTATION2
		 */
		public function get rotation2():Number { return _rotation2; }
		public function set rotation2(value:Number):void {
			setProperty( value, 'rotation' );
			_rotation2 = value;
		}
		
		/**
		 * MOUSE
		 */
		public function get mouseX2():Number { return mouseX - global.x; }
		public function get mouseY2():Number { return mouseY - global.y; }
		
		/**
		 * UTILITIES
		 */
		private function get global():Point {
			if (!parent) return localToGlobal(rp);
			return parent.globalToLocal(localToGlobal(rp));
		}
		
		private function setProperty(value:Number, ...props):void {
			var a:Point = global;
			for (var i:int = 0; i < props.length; ++i) this[props[i]] = value;
			var b:Point = global;
			x -= b.x -a.x;
			y -= b.y -a.y;
		}

	}
}