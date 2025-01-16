/**
 * Sound item
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.loader.items
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import railk.as3.net.loader.MultiLoaderEvent;
	
	public class SoundItem extends SimpleItem
	{
		private var ch:SoundChannel;
		private var loader:Sound;
		private var ready:Boolean;
		public function SoundItem( url:URLRequest, name:String, args:Object,priority:int, preventCache:Boolean, bufferSize:int, mode:String ):void {			
			super(url,name,args,priority,preventCache,bufferSize,mode);
		}
		
		override public function start():void {
			loader = new Sound();
			initListeners(loader);
            loader.load( url, new SoundLoaderContext(3000,true) );
		}
		
		override public function stop():void { 
			try { loader.close(); }
			catch (e:Error) { /*throw e;*/ }
			end();
		}
		
		override protected function end():void {
			delListeners( loader );
		}
		
		override public function dispose():void {
			super.dispose();
			loader = null;
		}
		
		override protected function begin(evt:Event):void {
			content = loader;
			ch = loader.play();
			ch.stop();
			super.begin(evt);
		}
		
		override protected function progress(evt:ProgressEvent):void {
			if ( loader.isBuffering ) streamBuffering();
			else streamReady();
			super.progress(evt);
		}
		
		override protected function complete(evt:Event):void {
			content = loader;
			end();
			super.complete(evt);
		}
		
		override protected function initListeners(loader:*):void {
			super.initListeners(loader);
			loader.addEventListener( Event.ID3, ID3, false, 0, true );
			loader.addEventListener( Event.SOUND_COMPLETE, soundComplete, false, 0, true );
		}
		
		override protected function delListeners(loader:*):void {
			super.delListeners(loader);
			loader.removeEventListener( Event.ID3, ID3 );
			loader.removeEventListener( Event.SOUND_COMPLETE, soundComplete );
		}
		
		private function streamReady():void {
			if ( !ready ){	
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
		
		private function soundComplete( evt:Event ):void {			
			sendEvent( MultiLoaderEvent.ON_STREAM_PLAYED, { info:"stream finished", item:this } );
			ch.removeEventListener( Event.SOUND_COMPLETE, soundComplete );
		}
		
		private function ID3( evt:Event ):void { dispatchEvent( evt ); }
		
		public function get channel():SoundChannel { return ch; }
		public function set channel( channel:SoundChannel ):void {
			ch = channel;
			ch.addEventListener( Event.SOUND_COMPLETE, soundComplete, false, 0, true );
		}
	}
	
}