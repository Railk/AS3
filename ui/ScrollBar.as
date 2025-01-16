/**
* 
* SCROLLBAR
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui 
{	
	import flash.display.Stage
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import railk.as3.display.UISprite;
	
	
	public class ScrollBar extends UISprite 
	{	
		private var toScroll        :Object;		
		private var size            :Object;
		public var slider           :*;
		public var bg               :*;
		
		private var vertical		:Boolean;
		private var wheel	        :Boolean;
		private var resize		    :Boolean;
		private var autoCheck		:Boolean;
		private var smooth			:Boolean;
		private var listeners       :Boolean;
		
		private var baseDelta		:Number=14;
		private var multiplier      :Number;
		private var delta			:Number;
		private var distance        :Number;
		private var rect 			:Rectangle;
		
		private var rollOver		:Function;
		private var rollOverArgs	:Array;
		private var rollOut			:Function;
		private var rollOutArgs		:Array;
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function ScrollBar( toScroll:Object,slider:*,bg:*=null,wheel:Boolean=false,resize:Boolean=false,autoCheck:Boolean=false, smooth:Boolean=false ) {
			super();
			this.name = 'scrollbar';
			this.toScroll = toScroll;
			this.bg = bg;
			this.slider = slider;
			this.wheel = wheel;
			this.resize = resize;
			this.autoCheck = autoCheck;
			this.smooth = smooth;
			this.vertical = (bg.height > bg.width);
			addEventListener( Event.ADDED_TO_STAGE, setup, false, 0, true );
		}
		
		public function onRollOver(f:Function, ...args):ScrollBar {
			rollOver = f;
			rollOverArgs = args;
			return this;
		}
		
		public function onRollOut(f:Function, ...args):ScrollBar {
			rollOut = f;
			rollOutArgs = args;
			return this;
		}
		
		/**
		 * SETUP
		 * @param	e
		 */
		private function setup(e:Event=null):void {
			removeEventListener( Event.ADDED_TO_STAGE, setup );
			
			//SIZE
			size = {	
				bg:(vertical?bg.height:bg.width), 
				slider:(vertical?slider.height:slider.width), 
				stage:(vertical?stage.stageHeight:stage.stageWidth),
				toScrollSize:(vertical?toScroll.height:toScroll.width),
				toScrollPlace:(vertical?toScroll.y:toScroll.x)
			}
			
			//BG
			bg.mouseEnabled = false;
			bg.name = 'bg';
			addChild( bg );
			
			//SLIDER
			slider.name = "slider";
			slider.buttonMode = true;
			addChild( slider ); 
			
			//LISTENERS
			if (resize) stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );
			if (autoCheck) this.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
				
			//INIT
			if ( size.toScrollPlace+size.toScrollSize > size.bg ) {
				distance = size.toScrollSize-size.toScrollPlace-size.bg;
				multiplier = distance/(size.bg-size.slider);
				delta = baseDelta/(multiplier*.5);
				delta = (delta>6)?delta:6;
				rect = (vertical?new Rectangle(0,0,0,size.bg-size.slider):new Rectangle(0,0,size.bg-size.slider,0));
				////////////////////////////////////
				initListeners();
				listeners = true;
				////////////////////////////////////
			} 
			else showHide(0,false);
		}
		
		/**
		 * CHANGE BG
		 * @param	bg
		 */
		public function changeBg(bg:*):void {
			if (bg) removeChild(getChildByName('bg'));
			this.bg = bg;
			setup();
		}
		
		/**
		 * CHNAGE SLIDER
		 * @param	slider
		 */
		public function changeSlider(slider:*):void {
			if(slider) removeChild(getChildByName('slider'));
			this.slider = slider;
			setup();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			this.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			slider.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			if ( wheel ) { stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true ); }
			stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
		}
		
		public function delListeners():void {
			this.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			this.removeEventListener( MouseEvent.CLICK, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			slider.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			if ( wheel ) { stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent ); }
			stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function _resize():void {
			var p:String = vertical?'y':'x';
			if ( size.toScrollPlace+size.toScrollSize > size.bg ) {
				showHide(1, true);
				distance = size.toScrollSize-size.toScrollPlace-size.bg;
				multiplier = distance/(size.bg-size.slider);
				delta = baseDelta/(multiplier*.5);
				delta = (delta>6)?delta:6;
				rect = (vertical?new Rectangle(0,0,0,size.bg-size.slider):new Rectangle(0,0,size.bg-size.slider,0));
				
				Engine.to( slider,.5,(vertical?NaN:0),(vertical?0:NaN),NaN,null,function():void { toScroll[p] = size.toScrollPlace-(slider[p]*multiplier); } );
				
				if(!listeners){
					////////////////////////////////////
					initListeners();
					listeners = true;
					////////////////////////////////////
				}	
			} else {
				Engine.to( slider,.4,(vertical?NaN:x),(vertical?y:NaN),NaN,null,function():void { toScroll[p]= size.toScrollPlace-(slider[p]*((multiplier)?multiplier:0)); } );
				showHide(0, false);
				////////////////////////////////////
				delListeners();
				listeners = false;
				////////////////////////////////////
			}			
		}
		
		/**
		 * VISIBILITY
		 * 
		 * @param	alpha
		 * @param	visibility
		 */
		public function showHide( alpha:Number, visibility:Boolean ):void {
			if(alpha) Engine.to( this, .4,NaN,NaN,alpha,function():void { this.visible = visibility; } );
			else Engine.to( this,.4,NaN,NaN,alpha,null,null,function():void { this.visible = visibility; } );
		}		
		
		/**
		 * MANAGE EVENT
		 * 
		 * @param	evt
		 */
		private function manageEvent( evt:* ):void  {
			var e:Engine, value:Number, p:String = (vertical)?'y':'x', s:String=(vertical)?'height':'width', ts:String = 'toScrollPlace',  m:String = (vertical)?'mouseY':'mouseX';
			switch( evt.type ) {
				case Event.ENTER_FRAME:
					if ( toScroll[s] != size.toScrollSize ) {
						size.toScrollSize = vertical?toScroll.height:toScroll.width;
						_resize();
					}
					break;
				case Event.RESIZE : _resize(); break;
				case MouseEvent.CLICK :
					if ( this[m] >= rect[s] ) value = rect[s];
					else if ( this[m] <= slider[s] ) value = 0;
					else value = this[m]-slider[s]*.5;
					e=Engine.to( slider,.2,(vertical?NaN:value),(vertical?value:NaN));
					e=Engine.to( toScroll,.2,((vertical)?NaN:size[ts]-(value*multiplier)),((vertical)?size[ts]-(value*multiplier):NaN));
					evt.updateAfterEvent();
					break;
				case MouseEvent.ROLL_OVER : if(rollOver!=null) rollOver.apply(); break;
				case MouseEvent.ROLL_OUT : if(rollOut!=null) rollOut.apply(); break;
				case MouseEvent.MOUSE_DOWN :
					if ( evt.currentTarget.name == "slider" ) {
						evt.currentTarget.startDrag( false, rect );
						stage.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
						this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
					}	
					else stage.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
					break;
				case MouseEvent.MOUSE_UP :
					if( evt.currentTarget.name == "slider" ){
						evt.currentTarget.stopDrag();
						stage.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
						this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
					} else {
						stage.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
						this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
						manageEvent( new MouseEvent( MouseEvent.ROLL_OUT, true,false, this.x, this.y, this ) );
						stopDrag();
					}
					break;
				case MouseEvent.MOUSE_MOVE :
					if ( evt.currentTarget.name == "scrollBar" ) {
						if ( this[m] >= rect[s] ) value = rect[s];
						else if ( this[m] <= slider[s] ) value = 0;
						else value = this[m] - slider[s]*.5;
						e=Engine.to(slider,0,((vertical)?NaN:value),((vertical)?value:NaN),NaN,null,function():void { toScroll[p]= size[ts]-(slider[p]*multiplier); } );
					} 
					else {
						e=Engine.to( toScroll,0,((vertical)?NaN:size[ts]-(slider[p]*multiplier)),((vertical)?size[ts]-(slider[p]*multiplier):NaN));
					}
					break;
				case MouseEvent.MOUSE_WHEEL :
					if ( slider[p] >= 0+evt.delta*delta  && slider[p] <= rect[s]+evt.delta*delta  ) e=Engine.to( slider,.4,(vertical?NaN:slider[p]-(evt.delta*delta)),(vertical?slider[p]-(evt.delta*delta):NaN),NaN,null,function():void  { toScroll[p] =size[ts]-(slider[p]*multiplier); });
					else if( slider[p] < 0 + evt.delta*delta ) e=Engine.to( slider,.2,(vertical?NaN:0),(vertical?0:NaN),NaN,null,function():void { toScroll[p] =size[ts]-(slider[p] * multiplier); });
					else if ( slider[p] > rect[s] + evt.delta*delta ) e=Engine.to( slider,.2,(vertical?NaN:rect[s]),(vertical?rect[s]:NaN),NaN,null,function():void { toScroll[p] =size[ts]-(slider[p]*multiplier); });
					break;
				default : break;
			}
		}
	}
}

import flash.utils.getTimer;
internal class Engine {
	private var t:Object;
	private var stm:Number;
	private var dr:Number
	private var dl:Number;
	private var props:Array=[];
	private var update:Function;
	private var complete:Function;
	
	public static function to(t:Object, dr:Number, x:Number = NaN, y:Number = NaN, a:Number = NaN, start:Function = null, update:Function = null, complete:Function = null, dl:Number=0 ):Engine {
		return new Engine(t,dr,x,y,a,start,update,complete,dl);
	}
	
	public function Engine(t:Object,dr:Number,x:Number,y:Number,a:Number,start:Function,update:Function,complete:Function,dl:Number=0){
		this.stm = getTimer()*.001;
		this.t = t;
		this.dr = dr;
		this.dl = dl;
		this.update = update;
		this.complete = complete;
		if(!isNaN(x)) props.push( {p:'x',s:t.x,c:x-t.x} );
		if(!isNaN(y)) props.push( {p:'y',s:t.y,c:y-t.y} );
		if(!isNaN(a)) props.push( {p:'alpha',s:t.alpha,c:a-t.alpha} );
		if (start!=null) start.apply();
		t.addEventListener('enterFrame', u );
	}

	private function u(evt:*):void {
		var tm:Number = (getTimer()*.001-stm)-dl;
		if ( up(((tm>=dr)?1:((tm<=0)?0:e(tm,0,1,dr))))==1 ){
			t.removeEventListener('enterFrame', u );
			if (complete != null) complete.apply();
			props = null;
		}
	}
	
	private function up(r:Number):int{
		var i:int=props.length;
		while( --i > -1 ) t[props[i].p] = Math.round(props[i].s+props[i].c*r+1e-18-1e-18);
		if (update!=null) update.apply();
		return r;
	}
	
	private function e(t:Number,b:Number,c:Number,d:Number):Number { return c*t/d+b; }
}