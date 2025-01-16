/**
* 
* ScrollList class
* 
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.ui.scrollList 
{	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;	
	import railk.as3.ui.drag.DragAndThrow;
	import railk.as3.event.CustomEvent;
	
	public class LinkedScrollList extends Sprite 
	{	
		private var vertical           	:Boolean;
		private var size               	:Number
		private var espacement         	:int;
		private var currentScrollList  	:int = 0;
		private var currentSize        	:Number = 0;
		private var activeScrollList   	:String;
		private var oldStageH          	:Number;
		private var oldStageW          	:Number;
		
		private var firstScroll     	:ScrollList;
		private var lastScroll      	:ScrollList;
		private var walker              :ScrollList;
		private var objects				:Array=[];
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function LinkedScrollList( size:Number, espacement:int, vertical:Boolean=true ) {
			this.vertical = vertical;
			this.espacement = espacement;
			this.size = size;
			this.addEventListener( Event.ADDED_TO_STAGE, setup, false, 0, true );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 CONSTRUCTEUR
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function setup( evt:Event ):void {	
			oldStageH = stage.stageHeight;
			oldStageW = stage.stageWidth;
			DragAndThrow.init( stage );
			DragAndThrow.addEventListener( 'onScrollListDrag', manageEvent, false, 0, true );
			this.removeEventListener( Event.ADDED_TO_STAGE, setup );
			stage.addEventListener( Event.RESIZE, manageEvent, false, 0, true );			
			newScroll();
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																  ADD OBJECT TO THE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	name
		 * @param	o
		 */
		public function add( o:* ):void { 
			if (vertical) currentSize += o.height+espacement;
			else currentSize += o.width+espacement;
			if ( currentSize >= size + o.height ) {
				objects.push(o);
				newScroll().add( o.name, o );
				currentSize = o.height+espacement;
			} else {
				objects.push(o);
				lastScroll.add( o.name, o );
			}	
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 					   MANAGE SCROLLS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function newScroll():ScrollList { return addScroll( new ScrollList( String(currentScrollList), engine, vertical, size, espacement, true, false )); }
		
		private function addScroll( scroll:ScrollList ):ScrollList {
			if (!firstScroll) firstScroll = lastScroll = scroll
			else {
				lastScroll.next = scroll;
				scroll.prev = lastScroll;
				lastScroll = scroll;
			}
			initScrollListeners( scroll );
			DragAndThrow.enable( scroll.name, scroll, vertical, true );
			currentScrollList++;
			return scroll;
		}
		
		private function getScroll( name:String ):ScrollList {
			walker = firstScroll;
			while ( walker ) {
				if ( walker.name = name) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 	   CREATE THE LINKED SCROLL LISTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function create():void {
			var place:Number = 0;
			walker = firstScroll;
			while ( walker ) {
				if (vertical) {
					walker.x = place;
					addChild( walker );
					walker.create();
					place += walker.width + espacement;
				} else {
					walker.y = place;
					addChild( walker );
					walker.create();
					place += walker.height + espacement;
				}
				walker = walker.next;
			}
			
			walker = firstScroll;
			while ( walker ) {
				if ( walker == firstScroll && walker == lastScroll )
				{
					if ( !walker.full ) {
						DragAndThrow.disable( walker.name );
						walker.delListeners();
					} else {
						walker.enableClones( walker.lastItem.o, walker.firstItem.o, true );
					}
				} else if ( walker == firstScroll ) { 
					if (lastScroll.full) walker.enableClones( lastScroll.lastItem.o, walker.next.firstItem.o, true );
					else walker.enableClones( null, walker.next.firstItem.o, true );
				} else if (walker == lastScroll) {   
					if (lastScroll.full) walker.enableClones( walker.prev.lastItem.o, firstScroll.firstItem.o, true );
					else walker.enableClones( walker.prev.lastItem.o, null, true );
				}
				else  walker.enableClones( walker.prev.lastItem.o, walker.next.firstItem.o, true );
				walker = walker.next;
			}
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																 	   CREATE THE LINKED SCROLL LISTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function initScrollListeners(scroll:ScrollList ):void {
			scroll.addEventListener( 'onScrollItemChange', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollListMove', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollListOver', manageEvent, false, 0, true );
			scroll.addEventListener( 'onScrollListOut', manageEvent, false, 0, true );
		}
		
		public function delScrollListeners( scroll:ScrollList ):void {
			scroll.removeEventListener( 'onScrollItemChange', manageEvent );
			scroll.removeEventListener( 'onScrollListMove', manageEvent );
			scroll.removeEventListener( 'onScrollListOver', manageEvent );
			scroll.removeEventListener( 'onScrollListOut', manageEvent );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															   MOVE ITEMS TO MANAGE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function crossScrollItems( item:ScrollListItem ):void {
			var x:Number = item.oldX, y:Number = item.oldY, height:Number = item.height, width:Number = item.width, name:String = item.name, scroll:ScrollList = getScroll(name);
			var head:Number = (vertical)? y+height : x+width;
			var tail:Number = (vertical)? y : x;
			
			if ( head  <= 0  ) {
				if ( scroll ==  firstScroll && scroll == lastScroll ) {
					if ( scroll.remove( item.name ) ) {
						scroll.update( item.name, item.o);
						scroll.enableClones( item.o,scroll.objects.head.data.o,true)
					}
				} else if ( scroll == firstScroll ) {
					if ( scroll.remove( item.name ) ) {
						if ( lastScroll.full ) lastScroll.update( item.name, item.o, lastScroll.firstItem.o,  scroll.firstItem.o );
						else lastScroll.update( item.name, item.o, lastScroll.firstItem.o, null );
					}	
				} else if (scroll == lastScroll ) {
					if ( scroll.remove( item.name ) )  {
						if ( scroll.prev == firstScroll ) {	
							if ( scroll.prev.full ) {
								scroll.prev.update( item.name, item.o );
								if( scroll.full ) scroll.prev.enableClones( scroll.lastItem.o, scroll.firstItem.o, true );
								else scroll.prev.enableClones( null, scroll.firstItem.o, true );
							}
							else scroll.prev.update( item.name, item.o , null, scroll.objects.head.data.o);
						} else {
							scroll.prev.update( item.name, item.o );
							scroll.prev.enableClones( scroll.prev.prev.lastItem.o, scroll.firstItem.o, true );
						}
					}
				} else  {
					if ( scroll.remove( item.name ) ) {
						scroll.prev.update( item.name, item.o);
						if ( scroll.prev == firstScroll ) {
							if ( lastScroll.full ) scroll.prev.enableClones( lastScroll.lastItem.o, scroll.firstItem.o );
							else scroll.prev.enableClones(null, scroll.firstItem.o );
						} 
						else scroll.prev.enableClones( scroll.prev.prev.lastItem.o, scroll.firstItem.o );
					}
				}
			} else if ( tail > size ) {
				if ( scroll == firstScroll && scroll == lastScroll ) {
					if ( scroll.remove( item.name ) ) {
						firstScroll.update( item.name, item.o, null, null, true );
						firstScroll.enableClones( scroll.lastItem.o, item.o,true );
					}
				} else if ( scroll == firstScroll ) {
					if ( scroll.remove( item.name ) ) {
						if ( scroll.next.full ) {
							if ( scroll.next == lastScroll ) { 
								scroll.next.update( item.name, item.o, null, null, true );
								scroll.next.enableClones( scroll.lastItem.o, scroll.next.lastItem.o, true );
							} else {
								scroll.next.update( item.name, item.o, null, null, true );
								scroll.next.enableClones( scroll.lastItem.o, scroll.next.next.firstItem.o, true );
								scroll.removeClones();
								if ( scroll.full && lastScroll.full ) scroll.enableClones(lastScroll.lastItem.o, scroll.next.firstItem.o, true );
								else scroll.enableClones(null, scroll.next.firstItem.o );
							}
						} else {
							scroll.next.update( item.name, item.o, null, null, true );
							scroll.next.enableClones( scroll.lastItem.o, null, true );
						}	
					}
				} else if ( scroll == lastScroll ) {
					if ( scroll.remove(item.name) ) {
						if ( lastScroll.full ) {
							firstScroll.update( item.name, item.o, null, null, true );
							firstScroll.enableClones( scroll.lastItem.o, firstScroll.next.firstItem.o, true );
							scroll.removeClones();
							if ( scroll.full ) scroll.enableClones(scroll.prev.lastItem.o, firstScroll.firstItem.o, true );
							else scroll.enableClones(scroll.prev.lastItem.o, null, true );
						} else {
							firstScroll.update( item.name, item.o, null, null, true );
							firstScroll.enableClones(null,firstScroll.next.firstItem.o,true);
							scroll.removeClones();
							scroll.enableClones(scroll.prev.lastItem.o, null,true );
						}
					}	
				} else {
					if ( scroll.remove( item.name ) ) {
						if ( scroll.next.full ) scroll.next.update( item.name, item.o, scroll.lastItem.o, scroll.next.firstItem.o, true );
						else scroll.next.update( item.name, item.o, scroll.lastItem.o, null, true );
						scroll.removeClones();
						scroll.enableClones( scroll.prev.lastItem.o, item.o,true );
					}
				}
			}
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															  				   MOVE LINKED SCROLLLIST
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function moveLinkedScrollLists( item:ScrollList, x:Number, y:Number ):void {
			DragAndThrow.drag( item.name, x, y );
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 															  				   				   RESIZE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function resize():void {	
			if(firstScroll) {
				walker = firstScroll;
				while ( walker ) {
					DragAndThrow.disable( walker.name );
					delScrollListeners( walker );
					this.removeChild( walker );
					walker.dispose();
					walker = walker.next;
				}
				lastScroll = firstScroll = null;
			}
			
			size = (size * stage.stageHeight) / oldStageH;
			currentScrollList = currentSize = 0;
			newScroll();
			
			for (var i:int = 0; i < objects.length; i++) {
				var o:* = objects[i];
				if ( vertical ) currentSize += o.height+espacement;
				else currentSize += o.width+espacement;
				if ( currentSize >= size+o.height ) {
					newScroll().add( o.name, o );
					DragAndThrow.enable( String(currentScrollList), lastScroll, vertical,true );
					currentSize = o.height+espacement;
				} 
				else lastScroll.add( o.name, o );
				walker = walker.next;
			}
			create();
			oldStageH = stage.stageHeight;
			oldStageW = stage.stageWidth;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	    			    	  DISPOSE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function dispose():void {
			objects=[];
			walker = firstScroll;
			while ( walker ) {
				DragAndThrow.disable( walker.name );
				delScrollListeners( walker );
				walker.dispose();
				walker = walker.next;
			}
			lastScroll = firstScroll = null;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																	     				 MANAGE EVENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch( evt.type ) {
				case Event.RESIZE : resize(); break;
				case 'onScrollItemChange' : crossScrollItems( evt.item ); break;
				case 'onScrollListMove' : if( activeScrollList == evt.item.name ) moveLinkedScrollLists( evt.item, evt.x, evt.y ); break;
				case 'onScrollListDrag' : activeScrollList = evt.name; break;
				case 'onScrollListOver' : break;
				case 'onScrollListOut' : break;
				default : break;
			}
		}
	}
}