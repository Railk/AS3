/**
* Display graphishapes
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.display.graphicShape {
	
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import railk.as3.display.UISprite;
	
	public class GraphicShape extends UISprite 
	{	
		public var graphicsCopy:*;
		protected var copy:Boolean;
		protected var _type:String;
		protected var c:ColorTransform;
		
		public function GraphicShape(copy:Boolean=false) {
			super();
			this.copy = copy;
			if ( copy ) graphicsCopy = new GraphicCopy(graphics);
			else graphicsCopy = graphics;
		}
		
		public function execute(method:String,params:Array):void {
			this.graphicsCopy[method].apply(null, params);
		}
		
		/**
		 * UTLITIES
		 */
		public function setScaleGrid( offset:uint ):void {
			this.scale9Grid = new Rectangle( offset, offset, this.width - ( offset << 1 ), this.height - ( offset << 1 ) );
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { graphicsCopy.clear(); }
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '[ GRAPHICSHAPE > ' + this.name.toUpperCase() + ', (type:' + this._type + ') ]';
		}
		
		/**
		 * GETTER/STTER
		 */
		public function get type():String { return _type; }
		public function get color():uint { return this.transform.colorTransform.color; }
		public function set color(value:uint):void {
			c = this.transform.colorTransform;
			this.transform.colorTransform = new ColorTransform(0,0,0,1,((value >> 16) & 0xff),((value >> 8) & 0xff),(value & 0xff));
		}
	}
}