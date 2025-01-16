/**
 * Delicious
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.external.delicious
{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import railk.as3.crypto.Base64;

	public class Delicious extends EventDispatcher
	{
		private static const DELICIOUS_ENDPOINT:String = "https://api.del.icio.us/v1";
		
		public static const POSTS_ADD:String    = "/posts/add";
		public static const POSTS_ALL:String    = "/posts/all";
		public static const POSTS_DATES:String  = "/posts/dates";    
		public static const POSTS_DELETE:String = "/posts/delete";
		public static const POSTS_GET:String    = "/posts/get";
		public static const POSTS_RECENT:String = "/posts/recent";
		
		public static const TAGS_GET:String     = "/tags/get";
		public static const TAGS_RENAME:String  = "/tags/rename";
		
		private var user:String;
		private var pass:String;
		
		/**
		 * SINGLETON
		 */
		public static function getInstance():Delicious{
			return Singleton.getInstance(Delicious);
		}
		
		public function Delicious() { Singleton.assertSingle(Delicious); }
		
		/**
		 * CONNECT TO THE SERVICE
		 */
		public function connect( user:String, pass:String ):void {
			this.user = user;
			this.pass = pass;
		}
		
		public function getSignedRequest( method:String, url:String ):URLRequest 
		{
		  var request:URLRequest = new URLRequest( DELICIOUS_ENDPOINT + url );
		  
		  request.shouldAuthenticate = false;
		  request.requestHeaders.push( new URLRequestHeader( "Authorization", "Basic " + Base64.encode( _user + ":" + _pass ) ) );
		  request.userAgent = 'asdelicious - ' + _user;
		  request.method = method;
		  
		  return request;
		}
		
		/**
		 * Returns posts matching the arguments. If no date or url is given, most 
		 * recent date will be used.
		 *  
		 * @param options
		 */
		public function getPosts( options : Object = null ) : void 
		{
		  var parameters:String = URLUtil.objectToString({tag: options.tag, url: options.url}, '&', true);
		  
		  handleRequest( DeliciousConstants.POSTS_GET + parameters, function( e : Event) : void 
		  {
			var objects : Array = new Array();
			var posts : XML = new XML(URLLoader(e.target).data);
			
			for each ( var post : XML in posts.post ) 
			  objects.push( unmarshallPost( post ) );
			
			if ( options.onSuccess != undefined ) 
			  options.onSuccess({data: objects});
		  }, options );
		}
		
		
		/**
		 * Returns all posts. Please use sparingly. Call the update function to see 
		 * if you need to fetch this at all.
		 *  
		 * @param url - the url of the item.
		 * @param description - the description of the item.
		 * @param options
		 */
		public function getAllPosts( options : Object = null ) : void 
		{
		  var parameters : String = '?';
		  
		  if ( options.tags != undefined ) {
			parameters += 'tag=';
			parameters += options.tags;
		  }
		  
		  handleRequest( DeliciousConstants.POSTS_ALL + parameters, function( e : Event ) : void 
		  {
			var objects : Array = new Array();
			var posts : XML = new XML(URLLoader(e.target).data);
			
			for each ( var post : XML in posts.post ) 
			  objects.push( unmarshallPost( post ) );
			
			if (options.onSuccess != undefined) options.onSuccess({data: objects});
		  }, options );
		}

		/**
		 * Returns a list of the most recent posts, filtered by argument. Maximum 100.
		 *  
		 * @param options
		 */
		public function getRecentPosts( options : Object = null ) : void 
		{
		  var parameters : String = '?' + URLUtil.objectToString({tag: options.tag, count: options.count}, '&', true);
		  
		  if ( parameters == '?&' ) parameters = '';
		  
		  handleRequest( DeliciousConstants.POSTS_RECENT + parameters, function( e : Event ) : void 
		  {
			var objects : Array = new Array();
			var posts : XML = new XML(URLLoader(e.target).data);
			
			for each ( var post : XML in posts.post ) 
			  objects.push( unmarshallPost( post ) );
			
			if ( options.onSuccess != undefined ) 
			  options.onSuccess( { data: objects } );
		  }, options );
		}
		
		/**
		 * Returns a list of the most recent posts by a user.  If no user name is supplied
		 * retrieves a list of the most recent popular posts.
		 *  
		 * @param user
		 * @param options
		 */
		public function getUserRecentPosts( user : String, options : Object = null ) : void 
		{
		   var service : HTTPService = new HTTPService();
		   service.url = 'http://del.icio.us/rss/';
		   service.addEventListener(ResultEvent.RESULT, function(e:ResultEvent) : void
		   {
			 var objects : Array = new Array();
			 var result:* = HTTPService(e.target).lastResult;
			 for each ( var item : Object in result.RDF.item )
			 {
			   var object : ObjectProxy = new ObjectProxy();
			   object.href        = item.link,
			   object.description = item.title,
			   object.tag         = item.tag,
			   object.time        = DateUtil.parseW3CDTF(item.date),
			   object.user        = item.creator

			   objects.push(object);
			 }
			 
			 if ( options.onSuccess != undefined ) 
			   options.onSuccess({data: objects});
		   });
		   service.send();
		}

		/**
		 * Add a post to del.icio.us
		 *  
		 * @param url - the url of the item.
		 * @param description - the description of the item.
		 * @param options
		 */
		public function addPost( url : String, description : String, options : Object = null) : void 
		{
		  var object : Object = {
			url         : options.url,
			description : options.description,
			extended    : options.extended,
			tags        : options.tags }
			
		  var parameters : String = URLUtil.objectToString( object, '&', true );
		  
		  handleRequest( DeliciousConstants.POSTS_ADD + parameters, function( e : Event ) : void 
		  {
			if ( options.onSuccess != undefined ) 
			  options.onSuccess();
		  }, options );
		}
		
		/**
		 * Delete a post from del.icio.us
		 *  
		 * @param options
		 */
		public function deletePost( url : String, options : Object = null ) : void 
		{
		  handleRequest( DeliciousConstants.POSTS_DELETE + '?url=' + url, function( e : Event ) : void 
		  {
			if ( options.onSuccess != undefined ) 
			  options.onSuccess();
		  }, options );
		}

		/**
		 * Returns a list of tags and number of times used by a user.
		 *  
		 * @param options onSuccess(), onError()
		 */
		public function getTags( options : Object = null ) : void 
		{
		  handleRequest( DeliciousConstants.TAGS_GET, function( e : Event ) : void 
		  {
			var objects : Array = new Array();
			var tags : XML = new XML(URLLoader(e.target).data);
			for each ( var tag : XML in tags.tag )
			  objects.push({tag: tag.@tag, count: tag.@count});
			
			if ( options.onSuccess != undefined ) 
			  options.onSuccess( {data: objects} );
		  }, options );
		}
		
		/**
		 * Rename an existing tag with a new tag name.
		 *  
		 * @param oldTag
		 * @param newTag
		 * @param options onSuccess(), onError()
		 */
		public function renameTag(oldTag:String, newTag:String, options:Object = null):void {
		  var object:Object = {'old': oldTag, 'new': newTag}
			
		  var parameters:String = URLUtil.objectToString(object, '&', true);
		  
		  handleRequest(DeliciousConstants.TAGS_RENAME + parameters, function(e:Event):void {
			if (options.onSuccess != undefined) options.onSuccess();
		  }, options);
		}
		
		/**
		 * Returns a list of dates with the number of posts at each date.
		 *  
		 * @param options tag, onSuccess(), onError()
		 */
		public function getDates( options : Object = null ) : void 
		{
		  var parameters : String = '?';
		  
		  if ( options.tags != undefined ) 
		  {
			parameters += 'tag=';
			parameters += options.tags;
		  }
		  
		  handleRequest( DeliciousConstants.POSTS_DATES + parameters, function( e : Event ) : void 
		  {
			var objects : Array = new Array();
			var dates : XML = new XML(URLLoader(e.target).data);
			
			for each ( var date : XML in dates.date ) 
			{
			  objects.push({
				date  : date.@date,
				count : date.@count
			  });
			}
			
			if ( options.onSuccess != undefined ) 
			  options.onSuccess({data: objects});
		  }, options );
		}

		// Private methods

		private function handleRequest( method : String, onComplete : Function, options : Object ) : void
		{
		  var loader:URLLoader = new URLLoader();
		  
		  loader.addEventListener(Event.COMPLETE, function(e:Event) : void 
		  {
			onComplete(e);
		  });

		  loaderListeners(loader, options);

		  loader.load(_connection.getSignedRequest('GET', method));
		}

		private function loaderListeners( loader : URLLoader, options : Object) : void 
		{
		  _httpResponseCode = 0;

		  loader.addEventListener( IOErrorEvent.IO_ERROR, function( ioe : IOErrorEvent ) : void
		  { 
			if (options.onError != undefined) 
			  options.onError(ioe);
			else 
			  dispatchEvent(ioe); 
		  });
		  
		  loader.addEventListener( Event.COMPLETE, function( e : Event ) : void 
		  {
			dispatchEvent(e);
		  });
		  
		  loader.addEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, function( e : HTTPStatusEvent ) : void 
		  {
			_httpResponseCode = e.status;
		  });
		}

		private function unmarshallPost( xml : XML ) : Object 
		{
		  var post:ObjectProxy = new ObjectProxy();

		  post.href        = xml.@href,
		  post.description = xml.@description,
		  post.tag         = xml.@tag,
		  post.time        = DateUtil.parseW3CDTF(xml.@time),
		  post.extended    = xml.@extended

		  return post;
		}	
	}
}