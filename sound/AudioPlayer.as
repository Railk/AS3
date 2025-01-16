/**
* Mp3 Player Engine
* 
* @author Richard Rodney.
* @version 0.2
*/

package railk.as3.sound
{	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundLoaderContext;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.System;	
	import flash.utils.Timer;
	import railk.as3.display.UIShape;
	
	public class AudioPlayer extends UIShape
	{
		private var autoPlay:Boolean;
		private var nbPlay:int;
		private var loop:Boolean;
		private var sound:Sound;
		private var channel:SoundChannel;
		private var soundTransform:SoundTransform;
		private var isBuffering:Boolean;
		private var isPlaying:Boolean;
		private var timer:Timer;
		private var position:Number=0;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function AudioPlayer(autoPlay:Boolean=false,loop:Boolean=false,nbPlay:int=1,domain:String='') { setup(autoPlay,loop,nbPlay,domain); }
		
		/**
		 * SETUP
		 */
		public function setup(autoPlay:Boolean,loop:Boolean,nbPlay:int,domain:String):void {
			if (domain) {
				Security.allowDomain(domain);
				Security.loadPolicyFile("http://"+domain+"/crossdomain.xml");
			}
			
			this.autoPlay = autoPlay;
			this.nbPlay = nbPlay;
			this.loop = loop;
			sound = new Sound();
			channel = new SoundChannel();
			soundTransform = new SoundTransform();
			timer = new Timer(100);
			
			//////////////////////////
			initListeners();
			/////////////////////////
		}
		
		/**
		 * LISTENERS
		 */
		private function initListeners():void {
			timer.addEventListener(TimerEvent.TIMER, manageEvent, false, 0, true);
			sound.addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
			sound.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
			sound.addEventListener( Event.OPEN, manageEvent, false, 0, true );
			sound.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
		}
		private function delListeners():void {
			timer.removeEventListener(TimerEvent.TIMER, manageEvent );
			sound.removeEventListener( Event.COMPLETE, manageEvent );
			sound.removeEventListener( ProgressEvent.PROGRESS, manageEvent );
			sound.removeEventListener( Event.OPEN, manageEvent );
			sound.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
		}
		
		/**
		 * CHANNEL LISTENERS
		 * @param	soundUrl
		 */
		private function initChannelEvent(channel:SoundChannel):void {channel.addEventListener( Event.SOUND_COMPLETE, manageEvent, false, 0, true );}
		private function delChannelEvent(channel:SoundChannel):void {channel.removeEventListener( Event.SOUND_COMPLETE, manageEvent );}
		
		
		/**
		 * LOAD
		 */
		public function load(soundUrl:String):void {
			sound.load( new URLRequest(soundUrl), new SoundLoaderContext(3000,true) );
		}
		
		/**
		 * PLAY
		 */
		public function play():void {
			if (!isPlaying) {
				delChannelEvent(channel);
				channel = sound.play(position, nbPlay, soundTransform);
				initChannelEvent(channel);
				isPlaying = true; 
				timer.start();
			}
		}
		
		/**
		 * PAUSE
		 */
		public function pause():void { 
			if (isPlaying) {
				position = channel.position;
				channel.stop(); 
				isPlaying = false; 
				timer.stop();
			}	
		}
		
		/**
		 * STOP
		 */
		public function stop():void { 
			if (isPlaying) {
				channel.stop();
				position = 0;
				isPlaying = false; 
				timer.stop();
			}	
		}
		
		/**
		 * REPLAY
		 */
		public function replay():void {
			delChannelEvent(channel);
			channel = sound.play(0, nbPlay, soundTransform)
			initChannelEvent(channel);
			if (!isPlaying) {
				isPlaying = true;
				timer.start();
			}
		}
		
		/**
		 * SEEK
		 * @param	percent
		 */
		public function seek(percent:Number):void {
			channel.stop();
			delChannelEvent(channel);
			channel = sound.play( (sound.length * percent), nbPlay, soundTransform );
			initChannelEvent(channel);
		}
		
		/**
		 * VOLUME
		 */
		public function get volume():Number { return soundTransform.volume*100; }
		public function set volume(value:Number):void {
			soundTransform.volume = value;
			channel.soundTransform = soundTransform;
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			delListeners();
			channel.stop();
			sound.close();
			timer.stop();
			channel =  null;
			sound = null;
		}
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent(e:*):void {
			switch( e.type ) {
				case Event.OPEN :
					if (autoPlay) play();
					dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_LOAD_BEGIN));
					break;
				case ProgressEvent.PROGRESS :
					if ( sound.isBuffering ) {
						isBuffering = true;
						position = channel.position;
						channel.stop();
						timer.stop();
						dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_START_BUFFERING));
					} else {
						if (isBuffering) {
							isBuffering = false;
							if (isPlaying) {
								initChannelEvent(channel);
								channel = sound.play(position, nbPlay, soundTransform);
								delChannelEvent(channel);
								timer.start();
							}
							dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_STOP_BUFFERING));
						}
					}
					dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_LOAD_PROGRESS,(e.bytesLoaded/e.bytesTotal)*100));
					break;
				case Event.COMPLETE : dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_LOAD_COMPLETE,100)); break;
				case Event.SOUND_COMPLETE :
					stop();
					if (loop) replay();
					dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_COMPLETE, 100)); 
					break;
				case TimerEvent.TIMER : dispatchEvent(new AudioPlayerEvent(AudioPlayerEvent.SOUND_PROGRESS,(channel.position/sound.length)*100)); break;
				default : break;
			}
		}
	}	
}