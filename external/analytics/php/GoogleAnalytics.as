/**
* 
* GoogleAnalytics
* 
* @author richard rodney
* @version 0.1
*/

package railk.as3.analytics.php {
	
	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	

	public class GoogleAnalytics extends Sprite {
		
		// ________________________________________________________________________________ VARIABLES LOADER
		private var loader                               :URLLoader;
		private var request                              :URLRequest;
		private var vars                                 :URLVariables;
		private var xmlReport                            :XML;
		
		// ________________________________________________________________________________ VARIABLES EVENT
		private var eEvent                               :GoogleAnalyticsEvent;
		
		
		
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						CONSTRUCTEUR
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		/**
		 * 
		 * @param	user
		 * @param	pass
		 * @param	path
		 */
		public function GoogleAnalytics( user:String, pass:String, path:String ):void {
			vars = new URLVariables();
			vars.user = user;
			vars.pass = pass;
			
			////////////////////////////////////////////////////////////////////////////////////////
			//on genere la date du jour pour reupéré les toutes dernieres valeur de google analytics
			var dateEnd:Date = new Date();//20080310
			var year:Number = dateEnd.getFullYear();
			var month:String = correctDate( dateEnd.getMonth(), "month" );
			var day:String = correctDate( dateEnd.getDate(), "day" );
			////////////////////////////////////////////////////////////////////////////////////////
			
			vars.end = String(year) + "" + month + "" + day;
			
			request = new URLRequest( path );
			request.method = URLRequestMethod.POST;
			request.data = vars;
			
			loader = new URLLoader();
			initListeners();
			
			loader.load( request );
		}
		
		
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   CORRECTION DE LA DATE
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		private function correctDate( date:Number, type:String ):String {
			var result:String;
			
			if ( type=="month" ) {
				if ( date>=0 && date <= 9 ) {
					result = "0"+String(date+1);
				}
				else {
					result = String(date);
				}
			}
			else if ( type=="day" ) {
				if ( date>=1 && date <= 9 ) {
					result = "0"+String(date);
				}
				else {
					result = String(date);
				}
			}
			return result;
		}
		
		
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   GESTION DES LISTENERS
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners():void {
			loader.addEventListener( Event.OPEN, manageEvent, false, 0, true );
			loader.addEventListener( ProgressEvent.PROGRESS, manageEvent, false, 0, true );
			loader.addEventListener( Event.COMPLETE, manageEvent, false, 0, true );
			loader.addEventListener( IOErrorEvent.IO_ERROR, manageEvent, false, 0, true );
		}
		
		private function delListeners():void {
			loader.removeEventListener( Event.OPEN, manageEvent );
			loader.removeEventListener( ProgressEvent.PROGRESS, manageEvent );
			loader.removeEventListener( Event.COMPLETE, manageEvent );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, manageEvent );
		}
		
		
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   	       GETTER/SETTER
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		public function get report():XML { return xmlReport; }
		
		
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   	  			 DESTROY
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		public function destroy():void {
			delListeners();
			loader = null;
		}
		
		
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			   	  GESTION DES EVENTS
		// —————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:*):void 
		{	
			var args:Object;
			switch( evt.type ) {
				case Event.OPEN :
					///////////////////////////////////////////////////////////////////
					args = { info:"GoogleAnalytics screen scraping beginned" };
					eEvent = new GoogleAnalyticsEvent( GoogleAnalyticsEvent.ONBEGIN, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////////
					break;
					
				case ProgressEvent.PROGRESS :
					var percent:Number = Math.floor(evt.bytesLoaded * 100 / evt.bytesTotal);
					///////////////////////////////////////////////////////////////////
					args = { info:"GoogleAnalytics screen scraping on progress", percent:percent };
					eEvent = new GoogleAnalyticsEvent( GoogleAnalyticsEvent.ONPROGRESS, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////////
					break;
					
				case Event.COMPLETE :
					xmlReport = new XML( loader.data );
					///////////////////////////////////////////////////////////////////
					args = { info:"GoogleAnalytics screen scraping finished and report gained" };
					eEvent = new GoogleAnalyticsEvent( GoogleAnalyticsEvent.ONCOMPLETE, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////////
					break;
					
				case IOErrorEvent.IO_ERROR :
					///////////////////////////////////////////////////////////////////
					args = { info:"GoogleAnalytics screen scraping error" };
					eEvent = new GoogleAnalyticsEvent( GoogleAnalyticsEvent.ONIOERROR, args );
					dispatchEvent( eEvent );
					///////////////////////////////////////////////////////////////////
					break;	
			}
		}
	}
}