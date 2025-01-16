/**
* 
* GoogleAnalytics
* 
* @author richard rodney
* @version 0.1
*/

package railk.as3.external.analytics.asc
{
	import flash.events.Event;
	public dynamic class GoogleAnalyticsEvent extends Event
	{
		public static const ON_LOGIN_COMPLETE:String='onLoginComplete'
		public static const ON_DATA:String = 'onData';
		public static const ON_ACCOUNT:String = 'onAccount';
		public static const ON_ERROR:String = 'onError';
		
		public function GoogleAnalyticsEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}