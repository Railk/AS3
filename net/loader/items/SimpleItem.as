/**
* Simple Item
* 
* @author richard rodney
* @version 0.1
*/

package railk.as3.net.loader.items 
{	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import railk.as3.net.loader.MultiLoaderEvent;
	
	
	public class SimpleItem extends EventDispatcher
	{
		public var next:SimpleItem;
		public var prev:SimpleItem;
		public var url:URLRequest=new URLRequest();
		public var name:String;
		public var args:Object;
		public var priority:int;
		public var state:String="waiting";
		public var content:*;
		public var percentLoaded:Number=0;
		public var mode:String;
		
		public function SimpleItem( url:URLRequest, name:String, args:Object, priority:int, preventCache:Boolean, bufferSize:int, mode:String ):void {
			this.url.url = (preventCache)?url.url+='?nocache='+int(Math.random()*100000*getTimer()+getTimer()):url.url;
			this.name = name;
			this.mode = mode;
			this.args = args;
			this.priority = priority;
		}
		
		protected function initListeners(loader:*):void {
			loader.addEventListener( Event.COMPLETE, complete, false, 0, true );
			loader.addEventListener( ProgressEvent.PROGRESS, progress, false, 0, true );
			loader.addEventListener( Event.OPEN, begin, false, 0, true );
			loader.addEventListener( IOErrorEvent.IO_ERROR, IOerror, false, 0, true );
		}
		
		protected function delListeners(loader:*):void {
			loader.removeEventListener( Event.COMPLETE, complete );
			loader.removeEventListener( ProgressEvent.PROGRESS, progress );
			loader.removeEventListener( Event.OPEN, begin );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, IOerror );
		}
		
		public function start():void {}
		public function stop():void {}
		protected function end():void {};
		
		public function dispose():void { 
			end();
			content = null;
		}
		
		protected function begin( evt:Event ):void {	
			state = "loading";
			dispatchEvent( evt );
		}
		
		protected function progress( evt:ProgressEvent ):void {	
			percentLoaded = Math.round((evt.bytesLoaded*100)/evt.bytesTotal);
			dispatchEvent( evt );
		}
		
		protected function complete( evt:Event ):void {	
			percentLoaded = 100;
			state = "loaded";
			dispatchEvent( evt );
		}
		
		protected function IOerror( evt:IOErrorEvent ):void {	
			state = "failed";
			sendEvent(MultiLoaderEvent.ON_ITEM_ERROR,{info:'[ ITEM '+url.url+' ERROR ]',item:this })
		}
		
		protected function sendEvent( type:String, args:Object ):void { dispatchEvent( new MultiLoaderEvent(type, args) ); }
		
		override public function toString():String { return '[ ITEM > ' + url.url +' '+state.toUpperCase()+' ]'; }
	}
}