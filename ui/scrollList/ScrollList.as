/**
* 
* ScrollList class
* 
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.ui.scrollList 
{	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import railk.as3.display.graphicShape.RectangleShape;
	import railk.as3.event.CustomEvent;
	import railk.as3.utils.Clone;
	
	public class ScrollList extends Sprite 
	{	
		public var next			:ScrollList;
		public var prev			:ScrollList;
		
		public var vertical		:Boolean;
		public var size	     	:Number;
		public var oldSize	  	:Number=0;
		public var espacement 	:int;
		public var full       	:Boolean = false;
		
		public var content    	:Sprite;
		private var fond   		:RectangleShape;
		public var objectsSize	:Number;
		private var rectSize  	:Number = 1;
		private var delta     	:Number = 70;
		private var oldX		:Number;
		private var oldY		:Number;
		private var bound     	:Boolean = false;
		private var linked    	:Boolean = false;
		private var oldStageH 	:Number;
		private var oldStageW 	:Number;
		private var lastTail  	:Object;
		private var lastHead  	:Object;
		private var headClone 	:*;
		private var tailClone 	:*;
		
		public var firstItem    :ScrollListItem;
		public var lastItem     :ScrollListItem;
		public var walker	    :ScrollListItem;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function ScrollList( name:String='', vertical:Boolean=true, size:Number=1, espacement:int=1, linked=false, bound=true ):void {	
			this.name = name;
			this.orientation = orientation;
			this.espacement = espacement;
			this.size = this.oldSize = size;
			this.bound = bound;
			this.linked = linked;
			this.engine = engine;
			
			content = new Sprite();
			addChild( content );
			
			if ( vertical ) content.scrollRect = new Rectangle( 0,0,rectSize,size );
			else content.scrollRect = new Rectangle( 0, 0, size, rectSize );
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     ADD OBJECT TO THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function add( name:String,  o:* ):void {
			var item:ScrollListItem = new ScrollListItem( name, o, this.name );
			if (!firstItem) firstItem = lastItem = item;
			else {
				lastItem.next = item;
				item.prev = lastItem;
				lastItem = item;
			}
			item.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
			lastTail = { x:lastItem.x + lastItem.width + espacement, y:lastItem.y + lastItem.height + espacement };
		}
		
		public function insertBefore( name:String, o:*):void {
			var item:ScrollListItem = new ScrollListItem( name, o, this.name );
			firstItem.prev = item;
			item.next = firstItem;
			firstItem = item;
			item.data.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
			lastTail = { x:lastItem.x + lastItem.width + espacement, y:lastItem.y + lastItem.height + espacement };
		}
		
		public function remove( name:String):void { 
			var item:ScrollListItem = getItem(name);
			objectsSize -= item.height + espacement;
			item.removeEventListener( 'onScrollItemChange', manageEvent);
			if (item.next) item.next.prev = item.prev;
			if (item.prev) item.prev.next = item.next;
			else if (firstItem == item) firstItem = item.next;
			item = null;
		}
		
		private function getItem( name:String ):ScrollListItem {
			walker = firstItem;
			while ( walker ) {
				if (walker.name == name ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		CREATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void {
			var place = 0;
			walker = firstItem;
			while ( walker ) {
				var obj:* = walker.o;
				content.addChild( obj );
				if ( vertical ){
					if ( obj.width > rectSize ) {
						rectSize = obj.width;
						content.scrollRect = new Rectangle( 0,0,rectSize,size );
					}
					obj.y = place;
					place += obj.height + espacement;
				} else {
					if ( obj.height > rectSize ) {
						rectSize = obj.height;
						content.scrollRect = new Rectangle( 0,0,size,rectSize );
					}
					obj.x = place;
					place += obj.width + espacement;
				}
				walker = walker.next;
			}
			objectsSize = place;
			
			fond = new RectangleShape();
			if ( vertical ) fond.rectangle(0xff0000, 0, 0, rectSize, size );
			else fond.rectangle(0xffffff, 0, 0, size , rectSize);
			fond.alpha = 0;
			addChildAt(fond, 0);
			
			this.oldStageH = stage.stageHeight;
			this.oldStageW = stage.stageWidth;
			this.oldX = content.scrollRect.x;
			this.oldY = content.scrollRect.y;
			if ( lastItem.y >= size - lastItem.height - espacement ) full = true;
			lastHead = { x:firstItem.x - (firstItem.width + espacement), y:firstItem.y - (firstItem.height + espacement) };
			initListeners();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		   GESTION DES CLONES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function enableClones( head:*, tail:*, first:Boolean=false):void {
			if ( head ){
				headClone = Clone.deep( head );
				addClone( 'headclone', headClone, first );
			}
			if ( tail ) {
				tailClone = Clone.deep( tail );
				addClone( 'tailclone', tailClone, first );
			}	
		}
		
		private function addClone( name:String, clone:*, first:Boolean ):void {
			if ( name == 'headclone' ) {
				var h:Number = ((first)? clone.height+espacement : 0);
				clone.y =  firstItem.y -( h );
			}
			else if ( name == 'tailclone' ) clone.y = lastItem.y + (lastItem.height + espacement);
			clone.name = name;
			content.addChild( clone );
		}
		
		public function removeClones():void {
			if (headClone != null) {
				content.removeChild( headClone );
				headClone = null;
			}
			if (tailClone != null) {
				content.removeChild( tailClone );
				tailClone = null;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     		UPDATE THE SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function update( name:String, o:*, headClone:*=null, tailClone:*=null, head:Boolean = false ):void {				
			if ( linked ) removeClones();			
			if (head) {
				this.content.addChild( o );
				if ( objects.head ) {
					o.y = firstItem.y - espacement - firstItem.height;
					insertBefore( name, o );
				} else {
					o.y = lastHead.y;
					add( name, o );
				}
			} else {
				this.content.addChild( o );
				if ( lastItem ) o.y = lastItem.y + lastItem.height + espacement;
				else o.y =  lastTail.y;
				add( name, o );
			}
			objectsSize += o.height + espacement;			
			if ( linked ) enableClones( headClone, tailClone, head );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				   GESTION LISTERNERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void {
			this.buttonMode = true;
			this.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			this.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
			this.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
			if(!linked) stage.addEventListener( Event.RESIZE, manageEvent, false, 0 , true );
		}
		
		public function delListeners():void {
			this.buttonMode = false;
			this.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
			this.removeEventListener( MouseEvent.ROLL_OUT, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			this.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
			this.removeEventListener( Event.ENTER_FRAME, manageEvent );
			if(!linked) stage.removeEventListener( Event.RESIZE, manageEvent );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function resize():void {
			if ( vertical ) {
				size = (size * stage.stageHeight) / oldStageH;
				oldStageH = stage.stageHeight;
				fond.rectangle(0xff0000, 0, 0, rectSize, size );
				content.scrollRect = new Rectangle( 0, 0, rectSize, size );
			}
			else {
				size = (size * stage.stageWidth) / oldStageW;
				oldStageW = stage.stageWidth;
				fond.rectangle(0xffffff, 0, 0, size , rectSize);
				content.scrollRect = new Rectangle( 0, 0, size, rectSize );
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			delListeners();
			this.removeChild( content );
			this.removeChild( fond );
			
			walker = firstItem;
			while ( walker ) {
				walker.data.dispose();
				walker = walker.next;
			}
			objects = null;
			content = null;
			fond = null;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String {
			return '[ SCROLL_LIST > ' + name + ', ( orientation : ' + orientation + ' ), ( size : ' + size + ' ), ( espacement : ' + espacement + ' ) ]';
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     				 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			var rect:Rectangle = content.scrollRect, value:Number;
			switch( evt.type ) {
				case 'onScrollItemChange' : dispatchEvent( new CustomEvent( evt.type, { item:evt.item}) ); break;
				case Event.ENTER_FRAME :
					if ( vertical ) if ( oldY != rect.y ) dispatchEvent( new CustomEvent( 'onScrollListMove', { item:this, x:rect.x, y:rect.y  } ) );
					else {
						if ( oldX != rect.x ) dispatchEvent( new CustomEvent( 'onScrollListMove', { item:this, x:rect.x, y:rect.y } ) );
					}
					break;
				case Event.RESIZE : if(!linked) resize(); break;
				case MouseEvent.ROLL_OVER :
					stage.addEventListener( MouseEvent.MOUSE_WHEEL, manageEvent, false, 0, true );
					dispatchEvent( new CustomEvent( 'onScrollListOver', { info:name+' height change', name:this.name } ) );
					break;
				case MouseEvent.ROLL_OUT :
					stage.removeEventListener( MouseEvent.MOUSE_WHEEL, manageEvent );
					dispatchEvent( new CustomEvent( 'onScrollListOut', { info:name+' height change', name:this.name } );
					break;
				case MouseEvent.MOUSE_WHEEL :
					if ( !bound ) {
						if ( vertical ) if ( evt.delta != 0) { engine.to( rect, 1, { y:rect.y + evt.delta * delta }, { onUpdate:function(){ content.scrollRect = rect; } } ); }
						else {
							if ( evt.delta != 0) { engine.to( rect, 1, { x:rect.x + evt.delta * delta }, { onUpdate:function(){ content.scrollRect = rect; } } ); }
						}
					} else {
						if (vertical ) {
							if ( rect.y >= 0 + evt.delta * delta  && rect.y <= rect.height + evt.delta * delta  ) Engine.to( rect,.4,NaN,rect.y-(evt.delta * delta),function(){ content.scrollRect = rect; });
							else if ( rect.y < 0 + evt.delta * delta ) Engine.to( rect,.4,NaN,0,function(){ content.scrollRect = rect; });
							else if ( rect.y > rect.height + evt.delta * delta ) Engine.to( rect,.4,NaN,rect.height,function(){ content.scrollRect = rect; });
						} else {
							if ( rect.x >= 0 + evt.delta*delta && rect.x <= rect.width + evt.delta*delta ) Engine.to( rect,.4,rect.x-(evt.delta * delta),NaN,function(){ content.scrollRect = rect; });
							else if( rect.x < 0 + evt.delta*delta ) Engine.to( rect,.4,0,NaN,function(){ content.scrollRect = rect; });
							else if ( rect.x > rect.height+evt.delta*delta ) Engine.to( rect,.4,rect.width,NaN,function(){ content.scrollRect = rect; });
						}
					}
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
	private var props:Array=[];
	private var update:Function;
	
	public static function to(t:Object,dr:Number, x:Number=NaN, y:Number=NaN, update:Function=null):Engine {
		return new Engine(t,dr,x,y,update);
	}
	
	public function Engine(t:Object,dr:Number,x:Number,y:Number,update:Function){
		this.stm = getTimer()*.001;
		this.t = t;
		this.dr = dr;
		this.update = update;
		this.complete = complete;
		if(!isNaN(x)) props.push( {p:'x',s:t.x,c:x-t.x} );
		if(!isNaN(y)) props.push( {p:'y',s:t.y,c:y-t.y} );
		t.addEventListener('enterFrame', u );
	}

	private function u(evt:*):void {
		var tm:Number = (getTimer()*.001-stm);
		if ( up(((tm>=dr)?1:((tm<=0)?0:e(tm,0,1,dr))))==1 ){
			t.removeEventListener('enterFrame', u );
			props = null;
		}
	}
	
	private function up(r:Number):int{
		var i:int=props.length;
		while( --i > -1 ) t[props[i].p] = props[i].s+props[i].c*r+1e-18-1e-18;
		if (update!=null) update.apply();
		return r;
	}
	
	private function e(t:Number,b:Number,c:Number,d:Number):Number { return c*t/d+b; }
}