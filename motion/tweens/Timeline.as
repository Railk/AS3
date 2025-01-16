/**
 * 
 * Timeline
 * 
 * @author Richard Rodney
 * @version 0.1  
 */

package railk.as3.motion.tweens
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import railk.as3.motion.*;
	import railk.as3.motion.utils.CallBack;
	import railk.as3.motion.utils.Composite;
	import railk.as3.utils.ObjectMerger;
	
	public class Timeline extends EventDispatcher
	{	
		static private var timelines:Dictionary = new Dictionary(true);
		private var timeline:Object={};
		private var labels:Object={};
		private var callBacks:Object={};
		private var tweens:Dictionary = new Dictionary(true);
		private var tween:Object;
		
		public var name:String;
		private var ticker:Shape = new Shape();
		private var startTime:Number=0;
		private var elapsedTime:Number = 0;
		private var duration:Number = 0;
		private var position:Number = 0;
		private var currentPos:Number=-1;
		private var paused:Boolean;
		private var reversed:Boolean;
		private var length:int = 0;
		
		static public function get(name:String):Timeline {
			if ( timelines[name]!= undefined ) return timelines[name];
			return new Timeline(name);
		}
		
		public function Timeline(name:String):void {
			this.name = name;
			timelines[name] = this;
		}
		
		/**
		 * Timeline append
		 */
		public function append( pos:Number, target:Object, duration:Number, props:Object, options:Object = null ):void {
			var merged:Object = ObjectMerger.merge(props, options, { duration:duration, _delay:0 } );
			if ( !willOverwrite(target, pos, merged) ) {
				merged._delay = pos;
				tweens[target] = new Composite(target, twin(target).dispose(false).delay(pos));
				tweens[target].add(pos, merged);
				tweens[target].tween.addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
				if ( timeline[pos] ) timeline[pos].push(target);
				else timeline[pos] = [target];
			}
			this.duration += (pos + duration) - this.duration;
			length++;
		}
		
		/**
		 * Timeline management
		 */
		public function start():void {
			if (paused) {
				startTime = getTimer()-elapsedTime*1000;
				for ( tween in tweens ) if(tweens[tween].state!='end') { tweens[tween].start(); }
				paused = false;
			} else {
				startTime = getTimer();
				for ( tween in tweens ) if (tweens[tween].state == 'wait') { tweens[tween].start(); }
			}
			ticker.addEventListener(Event.ENTER_FRAME, tick, false, 0, true );
		}
		
		public function pause():void {
			stop();
			paused = true;
			for ( tween in tweens ) if( tweens[tween].state!='end'){ tweens[tween].pause(); tweens[tween].state='pause'; }
		}
		
		public function reset():void { 
			startTime = getTimer(); 
			currentPos = -1;
		}
		
		public function reverse():void {
			startTime = getTimer();
			reversed = (reversed)?false:true; 
		}
		
		public function stop():void {
			ticker.removeEventListener( Event.ENTER_FRAME, tick );
			if( hasEventListener(Event.COMPLETE) ) dispatchEvent(new Event(Event.COMPLETE) );
		}
		
		public function dispose():void {
			pause();
			for ( tween in tweens ) {
				tweens[tween].dispose();
				tweens[tween].tween.removeEventListener( Event.COMPLETE, manageEvent);
			}
			tweens = null;
		}
		
		/**
		 * Labels
		 */
		public function addLabel( pos:Number, name:String ):void { labels[name] = pos; }
		
		public function removeLabel( name:String ):void { delete labels[name]; }
		
		/**
		 * CallBacks
		 */
		public function addCallBack( pos:Number, action:Function, params:Array = null ):void { 
			if ( callBacks[pos] ) callBacks[pos].push(new CallBack(pos,action,params));
			else callBacks[pos] = [new CallBack(pos,action,params)];
		}
		
		public function removeCallBack( pos:Number ):void { delete callBacks[pos]; }
		
		/**
		 * Gotos
		 */
		public function gotoAndPlay( posLabel:* ):void { goto( ((posLabel is String)?labels[posLabel]:posLabel) ); }
		
		public function gotoAndStop( posLabel:* ):void { goto( ((posLabel is String)?labels[posLabel]:posLabel),true ); }
		
		private function goto( pos:Number, stop:Boolean=false ):void {
			if (!stop) start();
			else {
				if (!paused) pause();
			}
			for ( tween in tweens) {
				tweens[tween].goto(pos);
				position = pos;
			}
		}
		
		/**
		 * willOverwrite
		 */
		private function willOverwrite( target:*, pos:Number, props:Object ):Boolean {
			for ( var o:Object in tweens ) if ( o == target ) { tweens[o].add(pos, props); return true; }
			return false;
		}
		
		/**
		 * Event
		 */
		private function manageEvent( evt:Event ):void {
			tweens[evt.target.target].state = 'end';
			--length;
		}
		
		/**
		 * Tick
		 */
		private function tick( evt:Event ):void {
			elapsedTime = position + ((!reversed)?((getTimer()-startTime)*.001):(duration-((getTimer()-startTime)*.001)));
			for ( var o:Object in callBacks ) {
				for ( var i:int = 0; i < callBacks[o].length; i++) {
					if ( elapsedTime >= callBacks[o][i].pos && callBacks[o][i].pos > currentPos ) {
						if(i==callBacks[o].length-1) currentPos = callBacks[o][i].pos;
						callBacks[o][i].apply(paused);
					}
				}
				
			}
			for ( tween in tweens ) tweens[tween].update(elapsedTime);
			if ( elapsedTime >= duration) stop();
			if( hasEventListener(Event.CHANGE) ) dispatchEvent(new Event(Event.CHANGE));
		}
	}
}