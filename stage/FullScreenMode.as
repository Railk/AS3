/**
* Fullscreen
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.stage 
{	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.ui.link.ILink;
	import railk.as3.ui.link.ILinkManager;
	import railk.as3.ui.link.LinkData;
	
	public class FullScreenMode
	{
		private var linkManager:ILinkManager;
		private var link:ILink;
		private var linkOff:ILink;
		private var stage:Stage;
		private var action:Function;
		private var state:String = 'normal';
		public var isFull:Boolean;
		
		public static function getInstance():FullScreenMode {
			return Singleton.getInstance(FullScreenMode);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function FullScreenMode() { Singleton.assertSingle(FullScreenMode); }
		
		/**
		 * INIT
		 * 
		 * @param	linkManager
		 * @param	stage
		 * @param	on
		 * @param	off
		 * @param	action                 Function(type:String("hover"|"out"|"do"|"undo"),data:LinkData)=null
		 * @param	colors                 Object {hover:,out:,click:}
		 */	
		public function init(linkManager:ILinkManager, stage:Stage,on:Object,off:Object, action:Function = null, colors:Object = null):void {
			if (!stage) return;
			this.linkManager = linkManager;
			this.action = action;
			this.stage = stage;
			if ( stage.hasOwnProperty("displayState") ) {
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, manageEvent, false, 0, true);
				if (on == off) {
					linkManager.addGroup("fullscreenmode");
					link = linkManager.add("fullscreenmode", on, execute,'fullscreenmode', colors);
				}
				else {
					linkManager.addGroup("fullscreenmode",true);
					link = linkManager.add("fullscreenmodeON", on, activate,'fullscreenmode',colors);
					linkOff = linkManager.add("fullscreenmodeOFF", off, desactivate,'fullscreenmode', colors);
					linkOff.doAction();
				}
			}
		}
		
		public function dispose():void {
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, manageEvent);
		}
		
		private function execute(type:String, data:LinkData):void {
			switch(type) {
				case "do" : stage.displayState = state = StageDisplayState.FULL_SCREEN; isFull = true; break;
				case "undo" : stage.displayState = state = StageDisplayState.NORMAL; isFull = false; break;
				default:break;
			}
			if(action!=null) action.apply(null,[type,data]);
		}

		
		private function activate(type:String,data:LinkData):void {
			switch(type) {
				case "do" : stage.displayState = state = StageDisplayState.FULL_SCREEN; isFull = true; break;
				default:break;
			}
			if(action!=null) action.apply(null,[type,data]);
		}
		
		private function desactivate(type:String,data:LinkData):void {
			switch(type) {
				case "do" :  stage.displayState = state = StageDisplayState.NORMAL;  isFull = false; break;
				default:break;
			}
			if(action!=null) action.apply(null,[type,data]);
		}
		
		private function manageEvent(e:FullScreenEvent):void {
			if (linkOff) {	
				if (state != stage.displayState && state == StageDisplayState.FULL_SCREEN) {
					linkOff.action();
					linkManager.navigationChange('fullscreenmodeOFF');
				}
			} else {
				if (state != stage.displayState) link.action();
			}
		}
	}
}