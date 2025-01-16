/**
 * Video Item
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.loader.items
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import railk.as3.net.loader.MultiLoaderEvent;
	
	public class VideoItem extends SimpleItem
	{
		private var loader:NetStream;
		private var nc:NetConnection;
		private var streamTriggerEvent:Shape=new Shape();
		private var streamMetadata:Object={};
		private var ready:Boolean;
		private var streamBufferState:Number=0;
		private var previousBytesLoaded:Number=0;
		private var previousBytesPLayed:Number=0;
		private var bytesPlayed:Number;
		private var bytesTotal:Number;
		private var startTime:Number;
		private var bufferSize:int;
		
		public function VideoItem( url:URLRequest, name:String, args:Object, priority:int,preventCache:Boolean, bufferSize:int, mode:String ):void {
			super(url,name,args,priority,preventCache,bufferSize,mode);
			this.bufferSize = bufferSize;
		}
		
		override public function start():void {
			nc = new NetConnection();
			nc.connect( null );
			loader = new NetStream( nc );
			initListeners(loader);
			streamTriggerEvent.addEventListener( Event.ENTER_FRAME, streamEvent, false, 0, true );
			
			var customClient:Object = new Object();
			customClient.onMetaData = metaData;
			loader.client = customClient;
			loader.play( url.url );
			loader.seek(0);
			loader.togglePause();
		}
		
		override protected function begin(evt:Event):void {
			startTime = getTimer();
			super.begin(evt);
		}
		
		override protected function progress(evt:ProgressEvent):void {
			super.progress(evt);
			var timeElapsed:Number = getTimer()-startTime;
			var currentSpeed:Number = evt.bytesLoaded / (timeElapsed*.001);
			var downloadTimeLeft:Number = (evt.bytesLoaded-evt.bytesLoaded)/(currentSpeed*.8);
			var remainingBuffer:Number = streamMetadata.duration - loader.bufferLength ;
			var buffer = ( bufferSize * evt.bytesTotal ) / streamMetadata.duration;
			bytesPlayed = Math.round(( Math.round(loader.time) * evt.bytesTotal )/Math.round(streamMetadata.duration));
			
			if ( !bufferSize ) if ( remainingBuffer > downloadTimeLeft && evt.bytesLoaded > 8 ) streamReady();
			else {
				if ( !ready ) {
					if ( streamBufferState <= buffer ) streamBufferState += evt.bytesLoaded-previousBytesLoaded;
					else streamReady();
				} else {
					if ( streamBufferState > buffer*.2 && (evt.bytesLoaded - bytesPlayed) >= loader.bufferLength ) streamBufferState = streamBufferState-(bytesPlayed-previousBytesPLayed);
					else streamBuffering();
				}
			}	
			previousBytesLoaded = evt.bytesLoaded;
			previousBytesPLayed = bytesPlayed;
			bytesTotal = evt.bytesTotal;
		}
		
		override protected function complete(evt:Event):void {
			content = loader;
			delListeners( loader );
			super.complete(evt);
		}
		
		override protected function initListeners(loader:*):void {
			super.initListeners(loader);
            loader.addEventListener( NetStatusEvent.NET_STATUS, netStatus, false, 0, true );
		}
		
		override protected function delListeners(loader:*):void {
			super.delListeners(loader);
			loader.removeEventListener( NetStatusEvent.NET_STATUS, netStatus );
		}
		
		private function streamEvent( evt:Event ):void {
			if ( !loader.bytesLoaded ) {
				loader.pause();
                begin( new Event( Event.OPEN ) );
			} 
			
			if ( Math.round(loader.time) == Math.round(streamMetadata.duration) ) {
				streamTriggerEvent.removeEventListener( Event.ENTER_FRAME, streamEvent );
				sendEvent( MultiLoaderEvent.ON_STREAM_PLAYED, { info:"stream finished", item:this } );
			} 
			else progress( new ProgressEvent( ProgressEvent.PROGRESS, false, false, loader.bytesLoaded, loader.bytesTotal ) );
		}
		
		private function streamReady():void {
			if ( !ready ) {
				complete( new Event( Event.COMPLETE ) );
				ready = true;
				sendEvent( MultiLoaderEvent.ON_STREAM_READY, { info:"stream ready", item:this } );
			}	
		}
		
		private function streamBuffering():void {
			if ( ready ){	
				ready = false;
				sendEvent( MultiLoaderEvent.ON_STREAM_BUFFERING, { info:"stream buffering", item:this } );
			}	
		}
		
		private function netStatus( evt:NetStatusEvent ):void {
			if(evt.info.code ==  "NetStream.Play.Start") {
					content = loader;
					begin( new Event( Event.OPEN ) );
			}
		}
		
		private  function metaData( metaData:Object ):void { streamMetadata = metaData; }
		public function get duration():Number { return streamMetadata.duration; }
		public function get played():Number { return bytesPlayed; }
	}
}