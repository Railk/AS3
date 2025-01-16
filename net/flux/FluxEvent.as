/**
* 
* Rss event
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.flux 
{
	import flash.events.Event;
	public dynamic class FluxEvent extends Event
	{		
		static public const ON_FLUX_PUBLISH_ERROR                 :String = "onFluxPublishError";
		
		public function FluxEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}
}