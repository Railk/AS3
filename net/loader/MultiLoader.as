/**
* 
* MultiLoader class
* 
* @author richard rodney
* @version 0.3
* 
* Update //0.3 > 20/03/2009// reduced size, made the linked list directly with items and made the loader modular 
* 
*/

package railk.as3.net.loader 
{	
	import flash.display.Shape;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	public class MultiLoader extends EventDispatcher 
	{	
		static public var list:Object = { } ;
		
		public var name:String;
		public var role:String;
		public var mode:String;
		public var maxSlots:int=7;
		public var takenSlots:int=0;
		public var state:String="stop";
		public var length:int=0;
		
		private var ticker:Shape=new Shape();
		private var item:*;
		private var first:*;
		private var last:*;
		private var walker:*;
		private var types:Object = {
			'.jpg,.jpeg,.png,.gif,.swf':'railk.as3.net.loader.items::LoaderItem',
			'.drw,.flow,.zip,.txt,.js,.php,.css,.xml':'railk.as3.net.loader.items::URLLoaderItem',
			'.flv,.f4v,.mp4,.m4a,.mov,.mp4v,.3gp,.3g2':'railk.as3.net.loader.items::VideoItem',
			'.mp3,.f4a,.f4b,.ogg':'railk.as3.net.loader.items::SoundItem'
		}
		
		/**
		 * enable
		 */
		static public function enable( ...items):Boolean { return true; }
		
		/**
		 * @param	mode   'local'| 'server'
		 */
		public function MultiLoader( name:String, role:String='', mode:String='server' ):void {
			list[name] = this;
			this.name = name;
			this.role = role;
			this.mode = mode;
		}
		
		public function start( nbSlot:int = 7 ):void {
			initListener();
			maxSlots = nbSlot;
			walker = first;
			while ( takenSlots < maxSlots && walker ) {
				if( walker.state == "waiting" ){
					walker.state = "loading";
					walker.start();
					takenSlots++;
				}	
				walker = walker.next;
			}
		}
		
		public function stop():void {
			walker = first;
			while ( walker ) {
				if ( walker.state == "loading" ) {
					walker.stop();
					walker.state = "waiting";
				}
				walker = walker.next;
			}
			delListener();
		}
		
		public function dispose():void {
			stop();
			removeAll();
			delete list[name];
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   ITEM MANAGEMENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	mode 		'sameDomain' | 'externalDomain' for SWF file;
		 * @param	bufferSize  | 0=loading the whole before playing / XX=the number of second to buffer before playing
		 */
		public function add( url:String, name:String="", args:Object=null, priority:int=0, mode:String = 'sameDomain', preventCache:Boolean = false, bufferSize:int = 0 ):void {
			item = new (getItemClass( url.split('/')[url.split('/').length-1] ))( new URLRequest( url ),((name=='')?url:name),args, priority, preventCache, bufferSize, mode );
			length++;
			initItemListeners( item );
			sortList( item );
		}
		
		/**
		 * 
		 * @param	mode 'sameDomain' | 'externalDomain';
		 */
		public function forceLoad( url:String, name:String =  "", args:Object = null, mode:String = 'sameDomain', preventCache:Boolean = false, bufferSize:int=0 ):void {
			item = new (getItemClass( url ))( new URLRequest( url ),((name=='')?url:name),args, 2, preventCache, bufferSize, mode );
			initItemListeners( item );			
			item.load();
		}
		
		public function getItemByName( name:String ):* {
			walker = first;
			while ( walker ){
				if ( walker.name == name) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public function getItemByArgs( name:String, value:* ):* {
			walker = first;
			while ( walker ) {
				if ( walker.args && walker.args.hasOwnProperty(name) ) if ( walker.args[name] == value ) return walker;
				walker = walker.next;
			}
			return null;
		}
		
		public function getItemContent( name:String, args:Boolean=false, argsType:String="" ):* {
			if (args) return getItemByArgs( argsType,name ).content;
			else return getItemByName( name ).content;
			return null;
		}
		
		public function removeByName( name:String ):Boolean {
			var item:*= getItemByName(name);
			if ( item ) {
				delItemListeners( item );
				item.dispose();
				removeItem( item );
				item = null;
				return true;
			}
			return false;
		}
		
		public function removeByUrl( url:URLRequest ):Boolean {
			walker = first;
			while ( walker ) {
				if ( walker.url == url ) {
					delItemListeners( walker );
					walker.dispose();
					removeItem( walker );
					walker = null;
					return true;
				}
				walker = walker.next;
			}
			return false;
		}
		
		public function removeAll():void {
			var next:*;
			walker = first;
			while ( walker ) {
				delItemListeners( walker );
				walker.dispose();
				removeItem( walker );
				next = walker.next;
				walker.next = walker.prev = null;
				walker = next;
			}
			first=item=null;
		}
		
		private function insertItem( item:*, before:*=null ):void {
			if (!first) first = last = item;
			else {
				if (before) {
					item.next = before;
					item.prev = before.prev;
					if (before.prev) before.prev.next = item;
					else first = item;
					before.prev = item;
				} else {
					last.next = item;
					item.prev = last;
					last = item;
				}
			}
		}
		
		private function removeItem( item:* ):void {
			if (item.next) item.next.prev = item.prev;
			else if( last === item )  last = item.prev;
			if (item.prev) item.prev.next = item.next;
			else if ( first === item) first = item.next;
			length--;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		ITEM CLASS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function getItemClass( url:String ):Class {
			for ( var o:String in types) if (o.search( url.match(/\.[a-zA-Z0-9]{2,4}/)[url.match(/\.[a-zA-Z0-9]{2,4}/).length - 1].toLowerCase() )!=-1) return getDefinitionByName(types[o]) as Class;
			return null;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					LOADING MANAGEMENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function loadNext():void {
			sendEvent( MultiLoaderEvent.ON_MULTILOADER_LOADNEXT );	
			walker = first;
			loop:while ( walker ) {
				if ( walker.state == "waiting" ) {
					walker.start();
					walker.state = "loading";
					takenSlots++;
				}
				if ( takenSlots == maxSlots ) break loop;
				walker = walker.next;
			}
		}
		
		private function checkFile():void {
			var waiting:Boolean;
			var loading:Boolean;
			walker = last;
			while ( walker ) {
				if ( walker.state == "waiting" ){ waiting = true; break; }
				if ( walker.state == "loading" ){ loading = true; break; }
				walker = walker.prev;
			}
			
			if ( waiting ) loadNext();
			else if( !waiting && !loading && state != 'stop' ) delListener();
		}
		
		private function sortList( item:* ):void {
			walker = first;
			while ( walker ) {
				if ( item.priority > walker.priority ) { insertItem( item, walker ); return; }
				walker = walker.next;
			}
			insertItem( item );
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			      			 LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initItemListeners( item:* ):void {
			item.addEventListener( Event.OPEN, manageEvent, false, 0, true );
			item.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
			item.addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ON_ITEM_ERROR, manageEvent, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ON_STREAM_READY, manageEvent, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ON_STREAM_BUFFERING, manageEvent, false, 0, true );
			item.addEventListener( MultiLoaderEvent.ON_STREAM_PLAYED, manageEvent, false, 0, true );
		}
		
		private function delItemListeners( item:* ):void {
			item.removeEventListener( Event.OPEN, manageEvent );
			item.removeEventListener( ProgressEvent.PROGRESS, manageEvent );
			item.removeEventListener( Event.COMPLETE, manageEvent );
			item.removeEventListener( MultiLoaderEvent.ON_ITEM_ERROR, manageEvent );
			item.removeEventListener( MultiLoaderEvent.ON_STREAM_READY, manageEvent );
			item.removeEventListener( MultiLoaderEvent.ON_STREAM_BUFFERING, manageEvent );
			item.removeEventListener( MultiLoaderEvent.ON_STREAM_PLAYED, manageEvent );
		}
		
		private function initListener():void { 
			state="start";
			sendEvent( MultiLoaderEvent.ON_MULTILOADER_BEGIN, { info:"[ MULTILOADER > "+name+" BEGIN ]" } );
			ticker.addEventListener( Event.ENTER_FRAME, manageEvent ); 
		}
		
		private function delListener():void {
			state = "stop";
			sendEvent( MultiLoaderEvent.ON_MULTILOADER_COMPLETE, { info:"[ MULTILOADER > "+name+" COMPLETE ]" } );
			ticker.removeEventListener( Event.ENTER_FRAME, manageEvent ); 
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  		  MANAGE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void {
			switch(evt.type) {
				case Event.OPEN : sendEvent( MultiLoaderEvent.ON_ITEM_BEGIN, { info:"[ ITEM "+evt.currentTarget.url.url+ " BEGIN ]", item:evt.currentTarget } ); break;
				case ProgressEvent.PROGRESS : sendEvent( MultiLoaderEvent.ON_ITEM_PROGRESS, { item:evt.currentTarget, percent:evt.currentTarget.percentLoaded } ); break;
				case Event.COMPLETE :
					evt.currentTarget.state = "loaded";
					sendEvent( MultiLoaderEvent.ON_ITEM_COMPLETE, { info:"[ ITEM "+evt.currentTarget.url.url+ " COMPLETE ]", item:evt.currentTarget } );
					takenSlots--;
					checkFile();
					break;
				case Event.ENTER_FRAME :
					var percent:Number = 0;
					walker = first;
					while ( walker ) {
						percent += walker.percentLoaded;
						walker = walker.next;
					}
					sendEvent( MultiLoaderEvent.ON_MULTILOADER_PROGRESS, { percent:int( percent/length ) } );
					break;
				case MultiLoaderEvent.ON_ITEM_ERROR:
					evt.currentTarget.state = "failed";
					sendEvent( evt.type, { info:evt.info, item:evt.item } );
					takenSlots--;
					checkFile();
					break;
				case MultiLoaderEvent.ON_STREAM_READY : sendEvent( evt.type, { info:evt.info, item:evt.item } ); break;
				case MultiLoaderEvent.ON_STREAM_BUFFERING : sendEvent( evt.type, { info:evt.info, item:evt.item } ); break;
				case MultiLoaderEvent.ON_STREAM_PLAYED :sendEvent( evt.type, { info:evt.info, item:evt.item } ); break;
				default : break;
			}
		}

		private function sendEvent( type:String, args:Object=null ):void { dispatchEvent( new MultiLoaderEvent(type, args) ); }
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   		 TO STRING 
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		override public function toString():String { 
			var result:String = '';
			walker = first;
			while ( walker ) {
				result+=walker.toString()+'\n';
				walker = walker.next;
			}
			return result;
		}
	}
}