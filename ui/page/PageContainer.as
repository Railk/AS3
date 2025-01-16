/**
 * PAGE Div Structure
 * 
 * @author Richard Rodney
 * @version 0.2
 */

package railk.as3.ui.page
{	
	import flash.events.Event;
	import railk.as3.ui.div.*;
	
	public class PageContainer extends Div implements IDiv
	{
		private var onScreen:IDiv;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	type
		 */
		public function PageContainer() {
			super();
		}
		
		/**
		 * ADD PAGE
		 */
		override public function addDiv(div:IDiv):IDiv {
			if (!onScreen) onScreen = div;
			return super.addDiv(div);
		}
		
		override protected function added(evt:Event):void {
			super.added(evt);
			unbind();
		}
		
		/**
		 * MANAGE BLOCKS
		 */
		public function addBlock(div:IDiv, onTop:Boolean):IDiv { return parent.addChildAt( div as Div, (onTop?parent.numChildren-1:0)) as IDiv; }
		public function delBlock(div:IDiv):void { parent.removeChild(div as Div); }
		
		/**
		 * UTILITIES
		 */
		public function goTo(name:String, transition:Function, complete:Function):void {
			onScreen = getDiv(name);
			transition.apply(null,[this,-onScreen.x, -onScreen.y,complete]);
		}
		
		override public function updateDiv():void {
			if (!onScreen) return;
			x = -onScreen.x;
			y = -onScreen.y;
		}
	}
}