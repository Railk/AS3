/**
 * Composite Tween
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion.utils
{
	import flash.events.Event;
	import railk.as3.motion.tweens.Normal;
	
	public class Composite
	{
		public var target:*;
		public var tween:Normal;
		public var state:String = 'wait';
		public var duration:Number = 0;
		private var timeline:Array = [];
		private var curPos:Number = 0;
		private var gotoPos:Number=0;
		private var inited:Boolean;
		
		public function Composite(target:*,tween:Normal) {
			this.target = target;
			this.tween = tween;
		}
		
		public function add( pos:Number, props:Object ):void {
			timeline[timeline.length] = [pos,pos+props.duration,props];
			timeline.sortOn(start, Array.NUMERIC );
			duration = (pos+props.duration)-duration;
		}
		
		public function start():void {
			if (!inited) init();
			if (state != 'end') { tween.play(); state='play'; }
		}
		
		private function init():void {
			tween.setProps(timeline[0][2]);
			inited = true;
		}
		
		public function pause():void {
			if (state != 'end') { tween.pause(); state = 'pause'; }
		}
		
		public function goto(pos:Number):void {
			if ( pos != gotoPos ) {
				loop:for (var i:int = 0; i < timeline.length ; i++) {
					if (pos > timeline[i][0] && pos <= timeline[i][1]) {
						tween.setProps(timeline[i][2]);
						tween.setPosition(tween.getProp('_delay') + (pos - timeline[i][0]));
						//curPos=i;
						break loop;
					} else if (pos > timeline[i][1]) {
						tween.setProps(timeline[i][2]);
						tween.setPosition(tween.getProp('_delay')+(timeline[i][1]-timeline[i][0]));
					}
				}
				gotoPos = pos;
			}
		}
		
		public function update( pos:Number ):void {
			var i:int=timeline.length
			while ( --i > -1 ) {
				if (pos >= timeline[i][0] && i>curPos ) {
					tween.setProps(timeline[i][2]);
					tween.play();
					state='play';
					curPos = i;
				}
			}
		}
		
		public function dispose():void {
			timeline = null;
			tween = null;
			target = null;
		}
	}
}