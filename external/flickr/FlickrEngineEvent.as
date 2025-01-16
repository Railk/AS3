/**
* 
* Flickr engine event
* 
* @author RICHARD RODNEY
* @version 0.2
*/

package railk.as3.external.flickr 
{
	import flash.events.Event;
	public dynamic class FlickrEngineEvent extends Event
	{
		static public const ON_CONNECTED                        :String = "onConnected";
		static public const ON_NSID                     		:String = "onNsid";
		static public const ON_TAGS                     		:String = "onTags";
		static public const ON_CONTACTS                     	:String = "onContacts";
		static public const ON_PHOTOSETSLIST            		:String = "onPhotoSetsList";
		static public const ON_PHOTOSLIST               		:String = "onPhotosList";
		static public const ON_PHOTO                    		:String = "onPhoto";
		static public const ON_PHOTOSIZES              			:String = "onPhotoSizes";
		
		
		public function FlickrEngineEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}	
}