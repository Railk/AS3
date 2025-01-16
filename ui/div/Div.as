/**
 * DIV
 * 
 * @author Richard Rodney
 * @version 0.3
 */

package railk.as3.ui.div
{	
	import flash.events.Event;
	import flash.display.DisplayObject;
	import railk.as3.display.UISprite;

	public class Div extends UISprite implements IDiv
	{	
		static protected var bubbleChange:Boolean;
		static protected var instance:Number = 0;
		
		protected var _state:DivState;
		protected var _position:String = 'RELATIVE';
		protected var _constraint:String = 'NONE';
		protected var _float:String = 'NONE';
		protected var _align:String = 'NONE';
		protected var _backgroundColor:uint = 0x00000000;
		protected var _master:IDiv;
		protected var _numDiv:int=0;
		protected var _prev:IDiv;
		protected var _next:IDiv;
		protected var _stageBound:Boolean;
		
		protected var firstDiv:IDiv;
		protected var lastDiv:IDiv;
		protected var stageAlign:Boolean;
		protected var notifyChange:Boolean;
		protected var hasStageEvent:Boolean;
		
		/**
		 * CONSTRUCTEUR
		 * @param	name
		 */
		public function Div(name:String='') {
			super();
			this.name = (!name)?'DIV_Instance_'+(instance++):name;
			_state = new DivState();
			addEventListener(Event.ADDED_TO_STAGE, added );
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		/**
		 * ADDED TO STAGE
		 */
		protected function added(evt:Event):void {
			_stageBound = (!isNaN(_state.stageWidth) || !isNaN(_state.stageHeight));
			_state.setWidth( (!isNaN(_state.stageWidth))?stage.stageWidth * _state.stageWidth:_state.width );
			_state.setHeight( (!isNaN(_state.stageHeight))?stage.stageHeight * _state.stageHeight:_state.height );
			bind();
		}
		
		protected function removed(evt:Event):void {
			unbind();
		}
		
		/**
		 * MANAGE DIVS
		 */
		public function addDiv(div:IDiv):IDiv {
			if (!firstDiv) firstDiv = lastDiv = div;
			else {
				lastDiv.next = div;
				div.prev = lastDiv;
				lastDiv = div;
			}
			return insertDiv(div);
		}
		
		public function insertDivBefore(div:IDiv,next:IDiv):IDiv {
			if (!next.prev) firstDiv = div;
			div.prev = next.prev;
			div.next = next;
			if (next.prev) next.prev.next = div;
			next.prev = div;
			return insertDiv(div);
		}
		
		public function insertDivAfter(div:IDiv,prev:IDiv):IDiv {
			if (!prev.next) lastDiv = div;
			div.prev = prev;
			div.next = prev.next;
			if (prev.next) prev.next.prev = div;
			prev.next = div;
			return insertDiv(div);
		}
			
		public function getDiv(name:String):IDiv {
			var d:IDiv = firstDiv;
			while (d) {
				if (d.name == name ) return d;
				d = d.next;
			}
			return null;
		}
		
		public function delDiv(div:IDiv):void {
			if (!div) return;
			div.unbind();
			if(div.next) placeDiv(div.next, div.prev);
			removeChild(div as Div);
			
			if (div.prev) div.prev.next = div.next;
			else firstDiv = div.next;
			if (div.next) div.next.prev = div.prev;
			else lastDiv = div.prev;
			
			div.reset();
			_numDiv--;
		}
		
		public function delAllDiv():void {
			var d:IDiv = lastDiv, p:IDiv;
			while (d) {
				p = d.prev;
				d.dispose();
				delDiv(d)
				d = p;
			}
		}
		
		/**
		 * RESET
		 */
		public function reset():void {
			next = null; 
			prev = null;
			_state = new DivState();
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			delAllDiv();
			removeEventListener(Event.ADDED_TO_STAGE, added );
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		/**
		 * DIV UTILITIES
		 */
		protected function insertDiv(div:IDiv):IDiv {
			div.master = this;
			addChild(div as Div);
			if (div.position == 'RELATIVE') {
				placeDiv(div, div.prev);
				alignDiv(div);
			}
			_numDiv++;
			return div;
		}
		
		protected function placeDiv(div:IDiv, prev:IDiv):void {
			var X:Number = ((prev && (div.constraint == 'NONE' || div.constraint == 'X') && div.float == 'LEFT' )?prev.x:0);
			var Y:Number = ((prev && (div.constraint == 'NONE' || div.constraint == 'Y') && div.float == 'NONE')?prev.y:0);
			if (div.float == 'NONE') Y = Y+((prev)?prev.height+prev.margin.bottom+prev.padding.bottom:0);
			else if (div.float == 'LEFT') X = X+((prev)?prev.width+prev.margin.right+prev.padding.right:0);
			div.setCoordinate(X,Y);
		}
		
		public function setCoordinate(x:Number, y:Number):void { 
			super.x = x+_state.left+_state.x; 
			super.y = y+_state.top+_state.y;
			if (!master) return;
			var w:Number = super.x - _state.padding.left + width + _state.left + _state.right;
			var h:Number = super.y - _state.padding.top + height + _state.top + _state.bottom;
			if (super.y > _master.width) {
				super.y 
			}
		}
		
		protected function alignDiv(div:IDiv):void {
			var d:IDiv = div.prev;
			while (d) {
				if(d.align!='NONE' || d.stageBound) d.resizeDiv();
				if (!d.prev) if (d.master) alignDiv(d.master);
				d = d.prev;
			}
		}
		
		/**
		 * MONITOR CHANGES
		 */
		public function bind():void {
			if (_position != 'ABSOLUTE') notifyChange = true;
			if (_align != 'NONE' || _stageBound) {
				stage.addEventListener(Event.RESIZE, change, false , 0, true );
				hasStageEvent = true;
				resizeDiv();
			}
		}
		
		public function unbind():void {
			if (_position != 'ABSOLUTE') notifyChange = false;
			if(_align!='NONE' || _stageBound) stage.removeEventListener(Event.RESIZE, change );
		}
		
		protected function change(e:Event=null):void {
			if (!notifyChange) return;
			bubbleChange = false;
			updateDiv();
			bubbleChange = true;
		}
		
		public function updateDiv():void {
			var d:IDiv = this;
			while (d) {
				if (_position != 'ABSOLUTE') placeDiv(d, d.prev);
				if (!d.next) if (_master) _master.updateDiv();
				d = d.next;
			}
			if (_align != 'NONE' || _stageBound) resizeDiv();
		}
		
		/**
		 * RESIZE
		 */
		public function resizeDiv():void {
			if (!isNaN(_state.stageHeight)) _state.setHeight( stage.stageHeight*_state.stageHeight );
			if (!isNaN(_state.stageWidth)) _state.setWidth( stage.stageWidth * _state.stageWidth );
			var W:Number = (!master)?stage.stageWidth:(stageAlign?stage.stageWidth:parent.width), H:Number = (!master)?stage.stageHeight:(stageAlign?stage.stageHeight:parent.height), a:String = _align;
			var w:Number = (isNaN(_state.width)?super.width:_state.width),  h:Number = (isNaN(_state.height)?height:_state.height);
			super.x = (a=='TL' || a=='L' || a=='CENTERY' )?((_float=='left')?x:_state.x):(a=='TR' || a=='BR' || a=='R')?(W-w)+_state.left+_state.x:(a=='BL')?0:(a=='T' || a=='B' || a=='CENTER' || a=='CENTERX')?W*.5-w*.5+_state.left+_state.x:_state.x;
			super.y = (a == 'TL' || a == 'TR' || a == 'T' || a == 'CENTERX')?_state.y:(a == 'BR' || a == 'BL' || a == 'B')?(H-h)+_state.top+_state.y:(a == 'L' || a == 'R' || a == 'CENTER' || a == 'CENTERY')?(H * .5 - h * .5) + _state.top + _state.y:_state.y;
		}
		
		/**
		 * FASTER ISNAN
		 */
		protected function isNaN(val:Number): Boolean { return val != val; }
		
		/**
		* GETTER/SETTER
		*/
		public function get stageBound():Boolean { return _stageBound; }
		public function get numDiv():int { return _numDiv; }
		public function get prev():IDiv { return _prev; }
		public function set prev(value:IDiv):void { _prev = value; }
		public function get next():IDiv { return _next; }
		public function set next(value:IDiv):void { _next = value; }
		public function get master():IDiv { return _master; }
		public function set master(value:IDiv):void { _master = value; }
		public function get float():String { return _float; }
		public function set float(value:String):void { _float=value.toUpperCase(); }
		public function get align():String { return _align; }
		public function set align(value:String):void { 
			stageAlign = (value.toUpperCase().search('STAGE') != -1);
			_align = value.toUpperCase().replace('STAGE', "");
			if (!stage) return;
			if (value != "NONE" && !hasStageEvent) stage.addEventListener(Event.RESIZE, change);
			else stage.removeEventListener(Event.RESIZE, change);
		}
		public function get position():String { return _position; }
		public function set position(value:String):void { 
			_position = value.toUpperCase(); 
			notifyChange = (value.toUpperCase()!= "ABSOLUTE");
		}
		public function get constraint():String { return _constraint; }
		public function set constraint(value:String):void { _constraint = value.toUpperCase(); }
		public function get margin():DivRect { return _state.margin; }
		public function get padding():DivRect { return _state.padding; }

		
		/**
		 * OVERRIDES
		 */
		override public function addChild(child:DisplayObject):DisplayObject { super.addChild(child); change(); return child; }
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject { super.addChildAt(child, index); change(); return child; }
		override public function removeChild(child:DisplayObject):DisplayObject { super.removeChild(child); change(); return child; }
		override public function removeChildAt(index:int):DisplayObject { var child:DisplayObject = super.removeChildAt(index); change(); return child; }
		override public function get height():Number { return (isNaN(_state.height)?super.height:_state.height); }
		override public function set height(value:Number):void { _state.setHeight(value); backgroundColor = _backgroundColor; change(); }
		override public function get width():Number { return (isNaN(_state.width)?super.width:_state.width); }
		override public function set width(value:Number):void { _state.setWidth(value); backgroundColor = _backgroundColor; change(); }
		override public function set x(value:Number):void { _state.x = value; change(); }
		override public function set y(value:Number):void { _state.y = value;  change(); }
		override public function set scaleX(value:Number):void { super.scaleX = value; backgroundColor = _backgroundColor; change(); }
		override public function set scaleY(value:Number):void { super.scaleY = value; backgroundColor = _backgroundColor; change(); }
		
		/**
		 * BACKGROUND COLOR
		 */
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			graphics.clear();
			if ((value >> 24 & 0xff) === 0 && value === 0) return;
			graphics.beginFill(value);
			graphics.drawRect(-_state.padding.left, -_state.padding.top, width+_state.padding.left+_state.padding.right, height+_state.padding.top+_state.padding.bottom);
			graphics.endFill();
		}
		
		
		/**
		 * TO STRING
		 */
		override public function toString():String {
			return '['+super.toString().split(' ')[1].split(']')[0].toUpperCase()+'::'+name+']'
		}
	}
}