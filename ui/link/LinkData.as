/**
* 
* LinkData
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.ui.link 
{	
	public class LinkData
	{	
		public var link:Object;
		public var target:Object;
		public var action:Function;
		public var data:*;
		public var type:String;
		public var eventType:String;
		public var colors:Object;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	target
		 * @param	action
		 * @param	data
		 * @param	type
		 * @param	eventType
		 * @param	colors
		 */
		public function LinkData(link:ILink,target:Object,action:Function,data:*,type:String='',eventType:String='',colors:Object=null) {
			this.link = link;
			this.target = target;
			this.action = action;
			this.data = data;
			this.type = type;
			this.eventType = eventType;
			this.colors = colors;
		}
	}
}