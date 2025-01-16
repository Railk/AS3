package railk.as3.utils {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	
	 /*///////////////////////////////////////////////////////////
	 * 
	 * ...
	 * @author Kasper Bøttcher / http://www.bombastisk.dk
	 * 
	 * version
	 * #1.0
	 * #1.1 / buffer time added
	 * #1.2 / quality lock after defined seconds
	 * 
	 * 
	 *////////////////////////////////////////////////////////////
	 
	 /*///////////////////////////////////////////////////////////
	 * 
	 * 
	 * This class is destributed for free use!
	 * Fell free to optimize and give feedback at dr@bombastisk.dk
	 * 
	 * 
	 * 
	 * 
	 * USAGE:
	 * 
	 * Add some intervals when ftp goes lower than the interval new stage quality is used
	 * Also you can add eventlistener and listen for the CHANGE event.
	 * 
	 * AutoStageQuality.currInterval // return the array possition of the used quality
	 * 
	 * AutoStageQuality.init( Assets.STAGE, [ { fps: 10, quality: "LOW" }, 
	 *										  { fps: 20, quality: "MEDIUM" }, 
	 *										  { fps: 30, quality: "HIGH" },
	 * 										  { fps: 40, quality: "BEST" } ] );
	 * 
	 * 
	 * Good luck!
	 * 
	 * 
	 *////////////////////////////////////////////////////////////
	
	public class AutoStageQuality {
		

		private static var _timer 				:uint					;
		private static var _fps 				:uint					;
		private static var _ms 					:uint					;
		private static var _msPrev				:uint					;
		private static var _stg					:Stage					;
		private static var _stageFramerate		:int					;
		private static var _intervals			:Array					;
		private static var _intervalLength		:int					;
		private static var _currInterval		:int					;
		
		private static var _prevQuality			:String					= "";
		private static var _buffer				:Number					;
		private static var _bufferClear			:uint					;
		private static var _log					:Array					= new Array();
		
		public static const CHANGE				:String					= "CHANGE";
		private static var _changeEvent			:Event					= new Event( CHANGE );
		private static var _dispatcher			:EventDispatcher 		= new EventDispatcher();
	
		
		
		public function AutoStageQuality() {
			
			
		}
		
		public static function init( stg:Stage, intervals:Array, buffer:Number = 1.5, lockAfterSec:int = 30 ):void {
			
			_stg 				= stg;
			_stageFramerate 	= _stg.frameRate;
			_buffer				= buffer;
			
			_intervals			= intervals;
			_intervalLength 	= _intervals.length;
			
			_stg.addEventListener(Event.ENTER_FRAME, update);
			
			if ( lockAfterSec != 0 ) {
				setTimeout( lockQuality, 1000 * lockAfterSec );
			}
			
		}
		
		private static function lockQuality():void {
			
			clearTimeout( _bufferClear );
			
			_stg.removeEventListener(Event.ENTER_FRAME, update);
			var i			:int		;
			var holderArr	:Array		= new Array();
			
			for ( i = 0; i < _intervalLength; i += 1) {
				holderArr.push( { quality: _intervals[i].quality, amount: 0 } );
				//trace("create : " + _intervals[i].quality);
			}
			
			var	l			:int		= _log.length;
			var s			:int		;
			
			for ( i = 0; i < l; i += 1 ) {
				for ( s = 0; s < _intervalLength; s += 1 ) {
					if ( holderArr[s].quality == _log[i] ) {
						
						holderArr[s].amount += 1;
						
						//trace("was : " + holderArr[s].quality);
						
						break;
					}	
				}	
			}
			
			var highest		:int		= 0;
			var highestId	:int		;
			
			for ( i = 0; i < _intervalLength; i += 1 ) {
				
				//trace("id : " + i);
				//trace("holderArr[i].amount : " + holderArr[i].amount);
				//trace("holderArr[i].quality : " + holderArr[i].quality);
					
				if ( holderArr[i].amount > highest ) {
									
					highestId = i;
					highest = holderArr[i].amount;
					
				}
				
			}
			
			//trace("QUALITY LOCKED : " + holderArr[highestId].quality );
			_currInterval = highestId;
			_stg.quality = holderArr[highestId].quality;
		
		}	
		
		public static function get currInterval():int {
			return _currInterval;
		}

		private static function update( event:Event ):void {
			
			_timer = getTimer();
			
			if ( _timer - 1000 > _msPrev ) {
				
				_msPrev = _timer;

				//trace("Current framerate: " + _fps + " / " + _stageFramerate);
				
				var newQuality:String = "";
				
				var i:int;
				for ( i = 0; i < _intervalLength; i += 1 ) {
					//trace("_intervals[i].fps : " + _intervals[i].fps);
					if ( _fps < _intervals[i].fps ) {
						_currInterval = i;
						newQuality = _intervals[i].quality;
						
						//trace("--> pick this interval");
						
						break;
						
					}
				}
				
				if ( newQuality != _prevQuality ) {
					
					//trace( "consider : " + newQuality );
					
					clearTimeout( _bufferClear );
					_bufferClear = setTimeout( changeQuality, 1000 * _buffer, { quality: newQuality } );
					
					_log.push( newQuality );
					
					_prevQuality = newQuality;
					
				}
				
				_fps = 0;
				
			}

			_fps += 1;
			
			_ms = _timer;

		}
		
		
		private static function changeQuality( qualityObj:Object ):void {
			
			var quality:String = qualityObj.quality;
			
			_log.push( quality );
			//trace( "quality : " + quality );
			
			if ( quality != "" ) {
				_stg.quality = quality;
			}
			_dispatcher.dispatchEvent( _changeEvent );
			
		}
	

		/******************************
		 * EVENT DISPATCH
		 * ***************************/
		public static function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true ):void {
			_dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		public static function removeEventListener( type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener( type, listener, useCapture );
  		}

		public static function dispatchEvent(event:Event):void {
			 _dispatcher.dispatchEvent( event );
		}
		
			
	}

}