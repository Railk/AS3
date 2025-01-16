/**
*  STAGE VIDEO PLAYER rtmp/stream
* 
* @author Richard Rodney.
* @version 0.2
* 
*/

package railk.as3.video
{
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.TimerEvent;
	import flash.events.VideoEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.utils.Timer;
	import railk.as3.display.UISprite;
	import railk.as3.TopLevel;
	import railk.as3.utils.Logger;
	import railk.as3.utils.StringUtils;
	

	public class StageVideoPlayer extends UISprite
	{
		public static const EMPTY:String = "empty";
		public static const PLAYING:String = "playing";
		public static const PAUSED:String = "paused";
		public static const STOPPED:String = "stopped";
		
		private var video:Video;
		private var stageVideo:StageVideo;
		private var videoUrl:String;
		private var videoRect:Rectangle = new Rectangle();
		private var _videoWidth:int;
		private var _videoHeight:int;
		private var _videoMetaData:VideoMetadatas;
		private var rtmp:String;
		private var bufferLength:int;
		private var inside:Boolean;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var sound:SoundTransform;
		private var loadTimer:Timer;
		private var playTimer:Timer;
		private var scrubbingIndex:int;
		private var stateBeforeScrubbing:String;
		private var videoAvailable:Boolean;
		private var activated:Boolean;
		private var loadBeforePlay:Boolean;
		private var autoPlay:Boolean;
		private var isBandwidthChecked:Boolean;
		
		private var _launched:Boolean;
		private var _connected:Boolean;
		private var _hasStageVideo:Boolean;
		private var _videoState:String;
		private var _loaded:Number;
		private var _played:Number;
		private var _buffering:Boolean;
		private var _bandwidth:String = "-2800";

		
		/**
		 * CONSTRUCTEUR 
		 * 
		 * @param	width
		 * @param	height
		 * @param	autoPlay
		 * @param	type
		 * @param	domain
		 */
		public function StageVideoPlayer(width:int, height:int, autoPlay:Boolean=false, bufferLength:int=5, rtmp:String="",inside:Boolean=true,domain:String="") { setup(width, height,autoPlay,bufferLength,rtmp,inside,domain); }
		
		/**
		 * SETUP
		 * 
		 * @param	width
		 * @param	height
		 * @param	autoPlay
		 * @param	type
		 * @param	domain
		 */
		private function setup(width:int, height:int, autoPlay:Boolean, bufferLength:int, rtmp:String, inside:Boolean, domain:String):void {
			if (domain!="") {
				Security.allowDomain(domain);
				Security.loadPolicyFile(domain+"/crossdomain.xml");
			}
			
			this.rtmp = rtmp;
			this.autoPlay = autoPlay;
			this.bufferLength = bufferLength;
			this.inside = inside;
			_videoWidth = width;
			_videoHeight = height;
			scrubbingIndex = 0;
			loadBeforePlay = false;
			_videoState = EMPTY;
			
			//TIMERS
			loadTimer = new Timer(500);
			playTimer = new Timer(100);
			
			//VIDEO
			video = new Video(width, height);
			video.height = height
			video.width = width;
			video.visible = false;
			video.smoothing = true;
		}
		
		/**
		 * CONNECT
		 * @param	event
		 */
		private function connect(e:StageVideoAvailabilityEvent):void {	
			TopLevel.stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, connect);
			_hasStageVideo = (e.availability == StageVideoAvailability.AVAILABLE);
			
			//////////////////////////////////////
			nc = new NetConnection();
			initListeners();
			nc.client = this;
			nc.connect( (rtmp!=""?rtmp:null) );
			/////////////////////////////////////
		}
		
		/**
		 * LAUNCH
		 */
		private function launch():void {
			//INIT VIDEO
			if (_hasStageVideo) {
				if (stageVideo == null && stage.stageVideos.length > 0) {
					stageVideo = stage.stageVideos[0];
					stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onRenderState, false, 0, true);
				}
			} else {
				video.addEventListener(VideoEvent.RENDER_STATE, onRenderState, false, 0, true);
				addChild(video);
			}

			//STREAM
			ns = new NetStream(nc);
			ns.bufferTime = bufferLength;
			ns.client = this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			ns.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError, false, 0, true);
			
			//SOUND
			sound = new SoundTransform();
			ns.soundTransform = sound;
			
			// ATTACH STREAM TO VIDEO
			if (_hasStageVideo) stageVideo.attachNetStream(ns);
			else {
				video.attachNetStream(ns);
				video.visible = true;
			}
			videoAvailable = true;
			activated = true;
			
			// PLAY/LOAD
			loadTimer.start();
			ns.play(videoUrl);
			if (autoPlay || loadBeforePlay) playTimer.start();
			else ns.pause();
		}
		
		/**
		 * LISTENERS
		 */
		private function initListeners():void {
			playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer, false, 0, true);
			loadTimer.addEventListener(TimerEvent.TIMER, onLoadTimer, false, 0, true);
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onError, false, 0, true);
		}
		
		private function delListeners():void {
			playTimer.removeEventListener(TimerEvent.TIMER, onPlayTimer );
			loadTimer.removeEventListener(TimerEvent.TIMER, onLoadTimer);
			nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onError);
			if (ns != null) {
				ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				ns.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			}
		}
		
		/**
		 * LOAD VIDEO
		 * @param	videoUrl
		 */
		public function load(videoUrl:String):void {
			if (videoUrl == null) return
			this.videoUrl = videoUrl;
			_videoMetaData = null;
			
			// STAGE VIDEO AVAILABLE
			TopLevel.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, connect, false, 0, true);
		}
		
		/**
		 * PAUSE
		 */
		public function pause():void {
			if(!activated) return;
			ns.pause();
			playTimer.reset();
			_videoState = PAUSED;
		}
		
		/**
		 * PLAY
		 */
		public function play():void{
			if(!activated) {
				loadBeforePlay = true;
				load(videoUrl);
				return;
			}
			if(_videoState == STOPPED) ns.seek(0);
			else ns.resume();
			playTimer.start(),
			_videoState = PLAYING
		}
		
		/**
		 * STOP
		 */
		 public function stop():void{
            ns.close();
            nc.close();
            playTimer.stop();
            loadTimer.stop();
            loadBeforePlay = false;
            activated = false;
            _videoState = EMPTY;
            if (_hasStageVideo){
                stageVideo.attachNetStream(null);
            } else {
                video.clear();
                video.attachNetStream(null);
            };
            delListeners();
        }		
		
		/**
		 * SEEK PERCENT
		 * 
		 * @param	seekPercent
		 * @param	scrubbing
		 */
		public function seekPercent(seekPercent:Number, scrubbing:Boolean=false):void {
			if(seekPercent < 0) seekPercent = 0;
			if(seekPercent > ns.bytesLoaded/ns.bytesTotal) seekPercent = ns.bytesLoaded/ns.bytesTotal;
			if (!scrubbing) { 
				scrubbingIndex = 0;
				if(!playTimer.running) { playTimer.reset(); playTimer.start(); }
			}
			else ++scrubbingIndex;
			
			if(scrubbingIndex == 1) {
				stateBeforeScrubbing = videoState;
				if(_videoState == PLAYING || _videoState == STOPPED) { pause(); }
			}
			
			ns.seek(seekPercent * _videoMetaData.duration);
			
			if(!scrubbing) { if(stateBeforeScrubbing == PLAYING || stateBeforeScrubbing == STOPPED) play(); }
		}
		
		/**
		 * SEEK TIME
		 * 
		 * @param	seekTime
		 * @param	scrubbing
		 */
		public function seek(seekTime:Number, scrubbing:Boolean = false):void {
			var seekPercent:Number = seekTime / _videoMetaData.duration;
			if(seekPercent < 0) seekPercent = 0;
			if(seekPercent > ns.bytesLoaded/ns.bytesTotal) seekPercent = ns.bytesLoaded/ns.bytesTotal;
			if (!scrubbing) { 
				scrubbingIndex = 0;
				if(!playTimer.running) { playTimer.reset(); playTimer.start(); }
			}
			else ++scrubbingIndex;
			
			if(scrubbingIndex == 1) {
				stateBeforeScrubbing = videoState;
				if(_videoState == PLAYING || _videoState == STOPPED) { pause(); }
			}
			
			ns.seek(seekTime);
			if (_videoState == STOPPED) {
				_videoState = PLAYING;
				ns.resume();
				playTimer.start();
			}
			if(!scrubbing) { if(stateBeforeScrubbing == PLAYING || stateBeforeScrubbing == STOPPED) play(); }
		}
		
		/**
		 * CLOSE CALLBACK
		 * @param	data
		 */
		public function close():void {
			Logger.log("close connection");
			_videoState = STOPPED;
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STOP));
		}
		
		/**
		 * METADATAS
		 * 
		 * @param	data
		 */
		public function onMetaData(data:Object):void {
			if(_videoMetaData == null){
				_videoMetaData = new VideoMetadatas(data);
				if(!isNaN(videoMetaData.width) && !isNaN(videoMetaData.height)) {
					if(stage.displayState == StageDisplayState.FULL_SCREEN) resizeVideo(stage.stageWidth,stage.stageHeight);
					else resizeVideo(_videoWidth,_videoHeight);						
				}
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_METADATA));
			}
		}
		
		/**
		 * ON PLAY STATUS
		 * 
		 * @param	data
		 */
		public function onPlayStatus( data:Object ) :void {
			Logger.log("onPlayStatus: " + data);
		}
		
		/**
		 * ON BW CHECK
		 * @param	...rest
		 */
		public function onBWCheck(...rest):void{
            Logger.log("onBWCheck");
        }
		
		/**
		 * ON BW DONE
		 * @param	kbitDown
		 * @param	deltaDown
		 * @param	deltaTime
		 * @param	latency
		 */
        public function onBWDone(kbitDown:Number, deltaDown:Number, deltaTime:Number, latency:Number):void{
            if (isBandwidthChecked) return;
            if (!isNaN(kbitDown)){
                if (kbitDown >= 500) _bandwidth = "-1000";
                if (kbitDown >= 2500) _bandwidth = "-2800";
                isBandwidthChecked = true;
                dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_BANDWITH_CHECK));
            };
        }
		
		/**
		 * XMP DATAS
		 * 
		 * @param	data
		 */
		public function onXMPData(data:Object):void {
			Logger.log(("onXMPData: " + data));
		}
		
		/**
		 * RESIZE VIDEO
		 */
		public function resizeVideo(width:int=0, height:int=0):void{
			_videoWidth = width;
			_videoHeight = height;
			if ( _hasStageVideo ) {
				getVideoRect(stageVideo.videoWidth?stageVideo.videoWidth:videoMetaData.width, stageVideo.videoHeight?stageVideo.videoHeight:videoMetaData.height);
				stageVideo.viewPort = videoRect;
			} else  {
				getVideoRect(video.videoWidth?video.videoWidth:videoMetaData.width,video.videoHeight?video.videoHeight:videoMetaData.height);
				video.width = videoRect.width;
				video.height = videoRect.height;
				video.x = videoRect.x;
				video.y = videoRect.y;
			}
		}
		
		/**
		 * GET VIDEO RECT
		 * @param	width
		 * @param	height
		 * @return
		 */
		private function getVideoRect(width:int,height:int):void {
			var vW:int = width;
			var vH:int = height;
			var scaling:Number = Math.min ( stage.stageWidth / vW, stage.stageHeight / vH );
			
			vW *= scaling, vH *= scaling;
			
			if (!inside) {
				vH = (vH*_videoWidth)/vW;
				vW = _videoWidth;
				if (vH < _videoHeight) {
					vW = (vW*_videoHeight)/vH;
					vH = _videoHeight;
				}
			} else {
				vW = (vW*_videoHeight)/vH;
				vH = _videoHeight;
			}
			
			
			var posX:int = stage.stageWidth - vW >> 1;
			var posY:int = stage.stageHeight - vH >> 1;
			
			videoRect.x = posX;
			videoRect.y = posY;
			videoRect.width = vW;
			videoRect.height = vH;
		}
		
		/**
		 * TOGGLE PLAY PAUSE
		 */
		public function togglePlayPause():void {
			if(_videoState == PLAYING) pause();
			else if(_videoState == PAUSED || _videoState == EMPTY) play();
			else if(_videoState == STOPPED) { seek(0); play(); }
		}
		
		/**
		 * TICKERS
		 * @param	event
		 */
		private function onLoadTimer(event:TimerEvent):void {
			if (ns == null) return
			_loaded = rtmp!=""?Math.min(Math.round(ns.bufferLength/ns.bufferTime*100), 100):(ns.bytesLoaded/ns.bytesTotal)*100;
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_LOAD, _loaded));
			if (_loaded == 100) {
				loadTimer.stop();
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_LOAD_COMPLETE, _loaded));
			}
		}
		
		private function onPlayTimer(event:TimerEvent):void {
			if(videoMetaData == null) return;
			_played  = (ns.time / videoMetaData.duration)*100;
			if (_videoState == STOPPED) playTimer.stop();
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_PROGRESS, _played));
		}
		
		/**
		 * ERRORS AND INFOS
		 */
		private function onAsyncError(e:ErrorEvent):void { Logger.log("onAsyncError() >>> " + e.text); }
		private function onError(e:ErrorEvent):void { Logger.log("onError() >>> " + e.text);	}
		private function onNetStatus(e:NetStatusEvent):void {
			Logger.log(e.info["code"]);
			switch(e.info["code"]) {
				case "NetStream.Play.Start": 
					if (_videoState != PAUSED) {
						_videoState = PLAYING;
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_START));
					}
					break;
				case "NetStream.Play.Stop": 
					_videoState = STOPPED; 
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STOP));
					break;
				case "NetStream.Buffer.Full": 
					_buffering = false;
					if(_videoState!=STOPPED) dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_STOP_BUFFERING, _played));
					break;
				case "NetStream.Buffer.Empty": 
					_buffering = true;
					if(_videoState!=STOPPED) dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_START_BUFFERING, _played));
					break;
				case "NetConnection.Connect.Success": launch(); break;
				case "NetConnection.Connect.Failed": break;
				default:break;
			}
		}
		
		/**
		 * RENDER STATE
		 * @param	e
		 */
		private function onRenderState(e:*):void {	
			Logger.log( "Render State : " + e.target +" "+ e.status);
			resizeVideo(_videoWidth,_videoHeight);
		}
		
		/**
		 * TIME
		 */
		public function get time():String {
			var seconds:Number = ns.time % 60;
			var minutes:Number = (ns.time - seconds) / 60;
			var heures:Number = int((ns.time - minutes) / 60);
			var secondsStr:String = seconds.toString().split(".")[0];
			secondsStr = StringUtils.padString(secondsStr, 2, "0");
			var minutesStr:String = StringUtils.padString(minutes.toString(), 2, "0");
			var heuresStr:String = StringUtils.padString(heures.toString(), 2, "0");
			return minutesStr + ":" + secondsStr;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get videoMetaData():VideoMetadatas { return _videoMetaData; }
		public function get bandwidth():String{ return _bandwidth; }
		public function get videoState():String { return _videoState; }
		public function get loaded():Number  { return _loaded; }
		public function get played():Number { return _played; }
		public function get videoWidth():int { return video.width; }
		public function set videoWidth(width:int):void{ video.width = _videoWidth = width; }
		public function get videoHeight():int { return video.height; }
		public function set videoHeight(height:int):void { video.height = _videoHeight = height; }
		public function get volume():Number { return sound.volume; }
		public function set volume(volume:Number):void {
			if (ns != null) {
				sound.volume = volume
				ns.soundTransform = sound;
			}
		}
	}
}
