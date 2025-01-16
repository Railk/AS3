/**
* 
* GoogleAnalytics events
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.analytics.php {

	import flash.events.Event;
	public dynamic class GoogleAnalyticsEvent extends Event{
			
		static public const ONBEGIN                         :String = "onBegin";
		static public const ONPROGRESS                      :String = "onProgress";
		static public const ONCOMPLETE                      :String = "onComplete";
		static public const ONIOERROR                       :String = "onIoError";
		
		
		public function GoogleAnalyticsEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
				super(type, bubbles, cancelable) ;
				for(var name:String in data) {
					this[name] = data[name];
				}	
		}
		
	}
}