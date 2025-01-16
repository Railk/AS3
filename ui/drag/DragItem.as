/**
 * 
 * drag and trown object with bounds or not
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.drag
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import railk.as3.event.CustomEvent;
	
	public class DragItem extends EventDispatcher
	{
		public var next:DragItem;
		public var prev:DragItem;
		
		public var name:String;
		public var o:Object;
		private var bounds:Rectangle;
		private var orientation:String;
		private var stage:Stage;
		
		public var useRect:Boolean = false;
		private var hasBound:Boolean = false;
		private var isDragging:Boolean = false;
		private var current:Number = 0;
		private var last:Number = 0;
		private var v:Number = 0;
		private var offset:Number;
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	   	 INIT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function DragItem( stage:Stage, name:String, o:Object, orientation:String, useRect:Boolean=false, bounds:Rectangle=null )
		{
			this.stage = stage;
			this.name = name;
			this.orientation = orientation;
			this.o = o;
			if (bounds) 
			{
				hasBound = true;
				this.bounds = bounds;
			}
			if ( orientation == 'V' ) current = last = o.y;
			else if ( orientation == 'H' ) current = last = o.x;
			this.useRect = useRect;
			
			////////////////////////////////////
			initListeners();
			////////////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				GESTION DES LISTENERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initListeners():void 
		{
			if( !useRect ) o.buttonMode = true;
			o.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
		}
		
		public function delListeners():void 
		{
			if( !useRect ) o.buttonMode = false;
			o.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void {
			delListeners();
			o = null;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							TO STRING
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String
		{
			return '[ DRAGITEM > ' + name + ', ( containing : ' + o + ' ) ]';
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:*):void 
		{
			var o:*;
			if ( useRect ) o = this.o.content.scrollRect;
			else o = this.o;
			
			switch( evt.type )
			{
				case MouseEvent.MOUSE_UP :
					isDragging = false;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, manageEvent );
					break;
					
				case MouseEvent.MOUSE_DOWN :
					isDragging = true;
					if( useRect ) offset = (orientation == 'V')? this.o.content.mouseY : this.o.content.mouseX;
					else offset = (orientation == 'V')? this.o.mouseY : this.o.mouseX;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, manageEvent );
					stage.addEventListener( Event.ENTER_FRAME, manageEvent, false, 0, true );
					dispatchEvent( new CustomEvent( 'onScrollListDrag', { info:name+' is being dragged', name:this.o.name} ) );
					break;
				
				case MouseEvent.MOUSE_MOVE :
					if ( orientation == 'V' )
					{
						if ( useRect )
						{ 
							o.y = -( stage.mouseY - offset );
							this.o.content.scrollRect = o;
						}
						else o.y = stage.mouseY - offset;
						if ( hasBound)
						{
							if(o.y <= bounds.top) o.x = bounds.top;
							else if (o.y >= bounds.bottom) o.x = bounds.bottom;
						}	
					}
					else if ( orientation == 'H' )
					{
						if ( useRect )
						{ 
							o.x = -( stage.mouseX - offset );
							this.o.content.scrollRect = o;
						}
						else o.x = stage.mouseX - offset;
						if ( hasBound)
						{
							if(o.x <= bounds.left) o.x = bounds.left;
							else if (o.x >= bounds.right) o.x = bounds.right;
						}	
					}
					evt.updateAfterEvent();
					break;
					
				case Event.ENTER_FRAME :
					if(isDragging)
					{
						last = current;
						current = (orientation == 'V')? stage.mouseY : stage.mouseX;
						v = current - last;
						
					}	
					else
					{
						if( orientation == 'V') (useRect) ? o.y -= v : o.y += v;
						else if ( orientation == 'H') (useRect) ? o.x -= v : o.x += v;
						if ( useRect ) this.o.content.scrollRect = o;
						if (v == 0) stage.removeEventListener( Event.ENTER_FRAME, manageEvent );
					}
					
					if ( hasBound)
					{
						if ( orientation == 'V' )
						{
							if(o.y <= bounds.top)
							{
								o.y  = bounds.top;
								v *= -1;
							}
							else if(o.y >= bounds.bottom-o.height)
							{
								o.y = bounds.bottom-o.height;
								v *= -1;
							}
						}
						else if ( orientation == 'H' )
						{
							if(o.x <= bounds.left)
							{
								o.x  = bounds.left;
								v *= -1;
							}
							else if(o.x >= bounds.right-o.width)
							{
								o.x = bounds.right-o.width;
								v *= -1;
							}
						}
					}	
					
					v *= .9;
					
					var absv:Number;
					if (v < 0)  absv = -v;
					else absv = v;
					if ( absv < 0.5 ) v = 0;
					break;
					
				default : break;
			}
		}
	}
}