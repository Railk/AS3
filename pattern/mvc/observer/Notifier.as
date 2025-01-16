/**
* 
* Notifier
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.observer
{
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.core.Facade;
	
	public class Notifier implements INotifier
	{
		protected var MID:String;
		public function sendNotification( note:String, info:String = '', data:Object = null ):void {
			facade.sendNotification(note,info,data );
		}
		
		protected function get facade():IFacade { return Facade.getInstance(MID); }
	}
}	