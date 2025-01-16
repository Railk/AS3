/**
* Animatedclip class with frame and script
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.display
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public final class AnimatedClip extends RegistrationPoint
	{
		public var frames:int = 0;
		public var first:Frame;
		public var last:Frame;
		public var current:Frame;
		
		private var _frameRate:Number=1;
		private var t:Timer;
		
		/**
		* CONSTRUCTEUR
		*/
		public function AnimatedClip( frames:int = 1 ):void {
			super();
			this.frames = frames;
			init();
		}
		
		private function init():void {
			for ( var i:int = 0; i < frames; i++ ) {
				
			}
			t = new Timer(1);
			t.addEventListener( TimerEvent.TIMER, pushFrameOnScreen, false, 0, true );
		}
		
		
		/**
		* PLAY
		*/
		public function play( frameRate:int=1 ):void {
			this.frameRate = frameRate;
			t.start();
		}
		
		/**
		* STOP
		*/
		public function stop():void {
			t.stop();
			t.reset();
		}
		
		/**
		* FRAME SELECTION
		*/
		public function goToFrame( frame:* ):void {
			current = getFrame(frame);
			pushFrameOnScreen();
		}
		
		
		public function nextFrame():void {
			current = current.next;
			pushFrameOnScreen();
		}
		
		public function previousFrame():void {
			current = current.prev;
			pushFrameOnScreen();
		}
		
		/**
		* MANAGE FRAME
		*/
		
		private function getFrame(frame:*):Frame {
			var f:Frame = first;
			while ( f ) {
				if ( frame == f.name || frame == f.id ) return f;
				f = f.next;
			}
			return null;
		}
		
		public function addFrame( data:Object = null, action:Function = null, ...params ):void {
			var frame:Frame = new Frame();
			frame.id = i;
			frame.data = data;
			frame.action = action;
			frame.actionParams = params;
			if (!first) current = first = last = frame;
			else {
				last.next = frame;
				frame.prev = last;
				last = frame;
			}
			frames++;
		}
		
		public function removeFrame( frame:* ):void {
			var f:Frame = getFrame(frame);
			if (f == first) f.next = null;
			else if (f == last) f.prev = null;
			else {
				f.prev.next = f.next;
				f.next.prev = f.prev;
			}
			f.data=null;
			f = null;
			frames--;
		}
		
		public function addFrameContent( frame:*, data:Object ):void {
			getFrame( frame ).data = data;
			pushFrameOnScreen();
		}
		
		public function addFrameScript( frame:*, action:Function, ...params ):void {
			var f:Frame = getFrame(frame);
			f.action = action;
			f.actionParams = params;
		}
		
		/**
		* PUSH FRAME ON SCREEN
		*/
		private function pushFrameOnScreen(evt:TimerEvent=null):void {
			if(numChildren) removeChildAt(0);
			addChild( current );
		}
		
		/**
		* DISPOSE
		*/
		public function dispose():void {
			t.removeEventListener( TimerEvent.TIMER, manageEvent );
			var f:Frame = first;
			while ( f ) {
				f.data = null;
				f = f.next;
			}
			f = null;
		}
		
		/**
		* GETTER/SETTER
		*/
		public function get frameRate():Number { return _frameRate; }
		public function set frameRate( value:Number ):void {
			_frameRate = value;
			t.delay = value;
		}	
	}
}

internal class Frame 
{
	public var next:Frame;
	public var prev:Frame;
	public var id:int;
	public var name:String;
	public var data:Object;
	public var action:Function;
	public var actionParams:Function;
}