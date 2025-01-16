/**
 * Regualar Tween (6.39k with all modules) (3,6k alone );
 * 		Strong typed with a module system including :
 * 			text / textColor /
 * 			color / 
 * 			tint / brightness / saturation / contrast / hue / treshold /
 * 			filters /
 * 			bezier /
 * 		Includes eventSystem + callbacks functions
 * 		Includes reflect and repeat
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.tweens
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import railk.as3.motion.utils.*;
	
	final public class Normal extends EventDispatcher
	{
		static private const ticker:Shape = new Shape();
		static private var tweens:Normal;
		static private var targets:Dictionary = new Dictionary(true);
		
		public var prev:Normal;		
		public var running:Boolean;
		public var target:Object;
		public var startTime:Number;
		public var position:Number=0;
		public var duration:Number;
		public var elapsedTime:Number=0;
		public var props:Prop;
		public var autoStart:Boolean=true;
		public var autoVisible:Boolean;
		
		protected var _repeat:int=0;
		protected var _reflect:Boolean;
		protected var _delay:Number=0;
		protected var _ease:Function=easeOut;
		protected var _rounded:Boolean;
		protected var _dispose:Boolean=true;
		protected var _onBegin:Function;
		protected var _onBeginA:Array=[];
		protected var _onUpdate:Function;
		protected var _onUpdateA:Array=[];
		protected var _onComplete:Function;
		protected var _onCompleteA:Array = [];
		
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	target
		 */
		public function Normal(target:Object = null, autoStart:Boolean = true) { 
			this.target = target; 
			this.autoStart = autoStart;
			if (targets[target] != undefined) targets[target].killTween(); 
			targets[target] = this;
		}
		
		/**
		 * TO
		 * 
		 * @param	duration
		 * @param	props
		 * @return
		 */
		public function to( duration:Number=0, props:Object=null ):Normal {
			this.duration = duration;
			stripProps( props );
			if (autoStart && this.target ) play();
			return this;
		}
		
		/**
		 * ACTIONS
		 */
		public function setPosition(pos:Number):Normal { position = pos; update(pos, true); return this; }
		public function setModule(...modules):Normal { return this; }
		public function delay( value:Number ):Normal { _delay = value; return this; }
		public function ease( value:Function ):Normal { _ease = value; return this; }
		public function repeat( value:int ):Normal { _repeat = value; return this; }
		public function reflect( value:Boolean ):Normal { _reflect = value; return this; }
		public function rounded( value:Boolean ):Normal { _rounded = value; return this; }
		public function dispose( value:Boolean ):Normal { _dispose = value; return this; }
		public function onBegin( value:Function, ...args ):Normal { _onBegin = value; _onBeginA = args; return this; }
		public function onUpdate( value:Function, ...args ):Normal { _onUpdate = value; _onUpdateA = args; return this; }
		public function onComplete( value:Function, ...args ):Normal { _onComplete = value; _onCompleteA = args; return this; }
		
		/**
		 * PLAY/PAUSE
		 */
		public function play():void { if (!running && target) add( this ); }
		
		public function pause():void {
			if(running && target){
				running = false;
				position += elapsedTime;
			}
		}
		
		/**
		 * KILL TWEEN
		 */
		public function killTween():void { 
			pause();
			target = null;
			_ease = _onBegin = _onComplete = _onUpdate = null;
			_onBeginA = _onCompleteA = _onUpdateA = null;
			while (props) {
				var p:Prop = props;
				props = props.prev;
				p.dispose();
				p = null;
			}
			delete targets[this.target];
		}
		
		/**
		 * MANAGE PROPERTIES
		 */
		public function setProps( os:Object ):void { for ( var o:String in os ) setProp( o, os[o] ); }
		public function setProp(name:String, value:*):void {
			var o:Object={}, p:Prop=props;
			if ( hasOwnProperty(name) ) this[name]=value;
			else {
				while(p){
					if (p.type == name) { 
						p.end = value; 
						p.start = p.current;
						return; 
					}
					p = p.prev;
				}
				o[name]=value; stripProps(o);
			}
			position = 0;
			reset(this);
		}
		
		public function getProp(name:String):* {
			if ( this.hasOwnProperty(name) ) return this[name];
			else {
				var p:Prop = props;
				while (p) {
					if (p.type == name) return p.current;
					p = p.prev;
				}
			}
		}
		
		public function delProp(name:String):void {
			var p:Prop = props, n:Prop;
			while (p) {
				if (p.type == name) {
					if (n) n.prev = p.prev;
					else props = p.prev;
					return;
				}
				n = p;
				p = p.prev;
			}
		}
		
		protected function stripProps( ps:Object ):void {
			var cf:Boolean=false, colorFilters:Object={};
			for ( var p:String in ps ) {
				switch( p ) {
					case 'volume': case 'pan': addProp( new Prop('sound',p,target.soundTransform[p],ps[p]) ); break;
					case 'text': case 'textColor': addProp( new Prop('text',p,target[p],ps[p]) ); break;
					case 'colorTransform': var c:ColorTransform = target.transform.colorTransform; addProp( new Prop(p, p, c, new ColorTransform(0 - c.redMultiplier, 0 - c.greenMultiplier, 0 - c.blueMultiplier, 0, ((ps[p] >> 16) & 0xff) - c.redOffset, ((ps[p] >> 8) & 0xff) - c.greenOffset, (ps[p] & 0xff) - c.blueOffset)) ); break;
					case 'color': case 'backgroundColor' : addProp( new Prop(p,p,target[p],ps[p]) ); break;
					case 'GlowFilter': case 'BlurFilter': case 'BevelFilter': case 'DropShadowFilter': addProp( new Prop('filter',p,getDefinitionByName('railk.as3.motion.modules::FilterModule').init(target,p,ps[p]),ps[p]) ); break;
					case 'tint': case 'brightness': case 'contrast': case 'hue': case 'saturation': case 'threshold': colorFilters[p] = [p,null,target.filters,ps[p]]; cf=true; break;
					default :
						if( p=='alphaVisible' ){ p='alpha'; autoVisible=true }
						addProp( new Prop(((ps[p] is Array)?'bezier':p), p, ((ps[p] is Array)?getDefinitionByName('railk.as3.motion.modules::BezierModule').init(target[p],ps[p]):target[p]), ps[p], (p.search('rotation') != -1)) ); 
						break;
				}
			}
			if (cf) addProp( new Prop('colorFilter','', null, colorFilters) );
		}
		
		protected function addProp(p:Prop):void {
			if (!props) props = p;
			else {
				p.prev = props;
				props = p;
			}
		}
		
		/**
		 * UPDATE
		 */
		public function update( time:Number, manual:Boolean=false ):void {
			if ( time >= 0 && _onBegin!=null) {
				_onBegin.apply(null, _onBeginA);
				_onBegin = null;
				if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
			}
			elapsedTime=time=(manual)?time:time-startTime;
			time -= _delay - ((manual)?0:position);
			if ( updateProps( ((time >= duration)?1:((time <= 0)?0:_ease(time,0,1,duration))) ) == 1 ) complete();
		}
		
		private function updateProps( ratio:Number ):Number {
			if ( target && ratio ) {
				var p:Prop = props;
				while( p ) {
					switch( p.type ) {
						case 'sound': case 'text': case 'colorTransform': case 'colorFilter': case 'filter': case 'bezier': 
							p = getDefinitionByName('railk.as3.motion.modules::'+cap(p.type)+'Module').update( target, p, ratio ); 
							break;
						case 'color': case 'backgroundColor': 
							p = getDefinitionByName('railk.as3.motion.modules::ColorModule').update( target, p, p.type, ratio );
							break;
						default :
							var value:Number = value = p.sNum+(p.eNum-p.sNum)*ratio+ 1e-18-1e-18;
							p.current = target[p.type] = (_rounded)?Math.round(value):value;
							if ( autoVisible && p.type == 'alpha' ) target.visible = value > 0;
							break;
					}
					p = p.prev;
				}
				if (_onUpdate != null) _onUpdate.apply(null, _onUpdateA);
				if( hasEventListener(Event.CHANGE) ) dispatchEvent(new Event(Event.CHANGE));
			}
			return ratio;
		}
		
		private function complete():void {
			if (_repeat>1 || _repeat==-1) {
				if (_reflect) {
					var p:Prop=props, start:*;
					while(p) {
						start = p.start;
						p.start = p.end;
						p.end = start;
						p = p.prev;
					}
				}
				position = 0;
				reset(this);
				if(_repeat!=-1) _repeat--;
			} else {
				running = false
				if (_onComplete != null) _onComplete.apply(null, _onCompleteA);
				if (hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE));
			}	
		}
		
		
		/**
		 * UTILITIES
		 */
		private function easeOut(t:Number, b:Number, c:Number, d:Number):Number { return -c * (t /= d) * (t - 2) + b; }
		public function cap(str:String):String { return str.substr(0, 1).toUpperCase() +  str.substr(1, str.length); }
		
		/**
		 * TICKER
		 */
		static private function add( tween:Normal ):void {
			tween.running = true;
			if (!tweens) tweens = tween;
			else {
				tween.prev = tweens;
				tweens = tween;
			}
			start( tween );
		}
		
		static private function reset(tween:Normal):void { tween.startTime = getTimer()*.001; }
		static private function stop():void { ticker.removeEventListener(Event.ENTER_FRAME, tick ); };
		static private function start( tween:Normal ):void {
			tween.startTime = getTimer()*.001;
			if (!ticker.hasEventListener(Event.ENTER_FRAME)) ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true ); 
		}
		
		static private function tick(evt:Event):void {
			if (tweens) {
				var t:Normal = tweens, n:Normal;
				while (t) {
					if (!t.running) {
						if (n) n.prev = t.prev;
						else  tweens = t.prev;
						if (t._dispose) t.killTween();
					}
					else t.update( getTimer()*.001 );
					n = t;
					t = t.prev;
				}
			}
			else stop();
		}
	}
}