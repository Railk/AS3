/**
* 
* Flickr engine error event
* 
* @author RICHARD RODNEY
* @version 0.2
*/

package railk.as3.external.flickr 
{
	import flash.events.Event;
	public dynamic class FlickrEngineErrorEvent extends Event
	{
		static public const ON_FROB_ERROR  			            :String = "onFrobError";
		static public const ON_TOKEN_ERROR			            :String = "onTokenError";
		static public const ON_NSID_ERROR             			:String = "onNsidError";
		static public const ON_TAGS_ERROR               		:String = "onTagsError";
		static public const ON_CONTACTS_ERROR		            :String = "onContactsError";
		static public const ON_PHOTOSETSLIST_ERROR      		:String = "onPhotoSetsListError";
		static public const ON_PHOTOSLIST_ERROR         		:String = "onPhotosListError";
		static public const ON_PHOTO_ERROR              		:String = "onPhotoError";
		static public const ON_PHOTOSIZES_ERROR        			:String = "onPhotoSizesError";
		
		
		public function FlickrEngineErrorEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable) ;
			for(var name:String in data) this[name] = data[name];
		}
	}	
}