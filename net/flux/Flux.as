/**
* 
* Flux Maker class
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.net.flux 
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import railk.as3.net.amfphp.AmfphpClient;
	import railk.as3.net.saver.xml.XmlSaver;
	import railk.as3.net.saver.xml.XmlSaverEvent;	
	import railk.as3.pattern.singleton.Singleton;
	
	
	public class Flux extends EventDispatcher  
	{
		public var FluxList    :Object={};
		private var amf        :AmfphpClient;
		private var saver      :XmlSaver;
		private var filePath   :String
		private var rssNodes   :Array;
		private var atomNodes  :Array;
		
		private var monthObj   :Object = {
			"january": { str:"Jan", num:"01" },
			"february": { str:"Feb", num:"02" },
			"march": { str:"Mar", num:"03" },
			"april": { str:"Apr", num:"04" },
			"may": { str:"May", num:"05" },
			"june": { str:"Jun", num:"06" },
			"july": { str:"Jul", num:"07" },
			"august": { str:"Aug", num:"08" },
			"september": { str:"Sep", num:"09" },
			"october": { str:"Oct", num:"10" },
			"november": { str:"Nov", num:"11" },
			"december": { str:"Dec", num:"12" } 
			}
		
		private var dayObj     :Object = {  
			"monday":{ str:"Mon", num:"01" },								
			"tuesday":{ str:"Tue", num:"02" },								
			"wednesday":{ str:"Wed", num:"03" },							
			"thursday":{ str:"Thu", num:"04" },							
			"friday":{ str:"Fri", num:"05" },								
			"saturday":{ str:"Sat", num:"06" },							
			"sunday": { str:"Sun", num:"07" } 
			}
			
		
		/**
		 * SINGLETON
		 */
		public static function getInstance():Flux {
			return Singleton.getInstance(Flux);
		}
		
		public function Flux() { Singleton.assertSingle(Flux); }
		
		
		/**
		 * ADD RSS
		 * 
		 * @param	filename
		 * @param	titre
		 * @param	link
		 * @param	desc       simple description
		 * @param	webmaster  mail
		 */
		public function addRss( id:String, filename:String, titre:String, link:String, desc:String, webmaster:String ):void {
			filePath = filename;
			
			rssNodes = new Array();
			rssNodes.push( { root:"rss", type:"title", attribute:null, content:titre } );
			rssNodes.push( { root:"rss", type:"link", attribute:null, content:link } );
			rssNodes.push( { root:"rss", type:"description", attribute:null, content:desc } );
			rssNodes.push( { root:"rss", type:"webMaster", attribute:null, content:webmaster } );
			rssNodes.push( { root:"rss", type:"atom:link", attribute: { 'xmlns:atom':'http://www.w3.org/2005/Atom', href:link + filePath, rel:"self" , type:"application/rss+xml" }, content:null } );
			
			FluxList[id] = rssNodes;
		}
		
		/**
		 * 
		 * ADD RSS ITEM
		 * 
		 * @param	permalink
		 * @param	titre
		 * @param	content
		 * @param	link
		 * @param	author     mail
		 */
		public function addRssItem( fluxID:String, permalink:String, titre:String, date:String, content:String, link:String, author:String ):void {
				FluxList[fluxID].push( { root:"rss", type:"item", attribute:null, content:[ { type:"guid", attribute:null, content:permalink  },
																					{ type:"pubDate", attribute:null, content:rssDate(date) }, 
																					{ type:"title", attribute:null, content:titre },
																					{ type:"description", attribute:null, content:titre },
																					{ type:"content:encoded", attribute:{ 'xmlns:content':'http://purl.org/rss/1.0/modules/content/' }, content:"<![CDATA["+content+"]]>" }, 
																					{ type:"link", attribute:null, content:link }, 
																					{ type:"author", attribute:null, content:author } ]
								} );
		}
		
		/**
		 * 
		 * ADD ATOM
		 * 
		 * @param	filename
		 * @param	titre
		 * @param	link
		 * @param	author
		 * @param	mail
		 */
		public function addAtom( id:String, filename:String, titre:String, link:String, author:String, mail:String ):void {
			filePath = filename;
			
			atomNodes = new Array();
			atomNodes.push( { root:"atom", type:"title", attribute:null, content:titre } );
			atomNodes.push( { root:"atom", type:"link", attribute:{ rel:'self',href:link+filePath }, content:null } );
			atomNodes.push( { root:"atom", type:"updated", attribute:null, content:atomDate() } );
			atomNodes.push( { root:"atom", type:"author", attribute:null, content:"<name>"+author+"</name><email>"+mail+"</email>" } );
			atomNodes.push( { root:"atom", type:"id", attribute:null, content:link } );
			
			FluxList[id] = atomNodes;
		}
		
		/**
		 * ADD ATOM ITEM
		 * 
		 * @param	fluxID
		 * @param	permalink
		 * @param	titre
		 * @param	contentType    "xhtml" dans la plupart des cas
		 * @param	content
		 * @param	author
		 */
		public function addAtomItem( fluxID:String, permalink:String, titre:String, date:String, content:String, author:String ):void {
				FluxList[fluxID].push( { root:"atom", type:"entry", attribute:null, content:[ { type:"title", attribute:null, content:titre }, 
																					  { type:"id", attribute:null, content:permalink  }, 
																					  { type:"updated", attribute:null, content:atomDate(date) },
																					  { type:"content", attribute:{ type:"xhtml" }, content:"<div xmlns='http://www.w3.org/1999/xhtml'>"+content+"</div>" }, 
																					  { type:"author", attribute:null, content:"<name>"+author+"</name>" } ]
								} );
		}
		
		
		/**
		 * PUBLISH
		 * 
		 * @param	fluxID
		 */
		public function Publish( fluxID:String, amf:AmfphpClient ):void {	
			saver = new XmlSaver( amf );
			saver.update( '', filePath, FluxList[fluxID] );
			saver.addEventListener( XmlSaverEvent.ON_ERROR, manageEvent, false, 0, true );
			saver.addEventListener( XmlSaverEvent.ON_SAVE_XML_COMPLETE, manageEvent,false,0,true );
		}
		
		
		/**
		 * UTILITIES
		 */
		private function rssDate( date:String = "" ):String {
			var timeStr:String;
			var tmpArr:Array;
			var dayTab:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
			var monthTab:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul" ,"Aug" ,"Sep", "Oct", "Nov", "Dec"];
			
			if( date == "" ){
				var myTime:Date = new Date();
				timeStr =  String( dayTab[myTime.getDay()] + ", " + zero(myTime.getDate()) + " " + monthTab[myTime.getMonth()] + " " + myTime.fullYear + " " + zero(myTime.getHours()) +":" + zero(myTime.getMinutes()) +":" + zero(myTime.getSeconds()) + " +0200" );
			}
			else {
				tmpArr = date.split(" "); var day:String = tmpArr[0]; var dmy:String = tmpArr[1]; var heure:String = tmpArr[2];
				tmpArr = dmy.split("-"); var d:String = tmpArr[0]; var m:String = tmpArr[1]; var y:String = tmpArr[2];
				timeStr = String(  dayObj[day].str+", "+d+" "+monthObj[m].str+" "+y+" "+heure+ " +0200" );
			}
			return timeStr;
		}
		
		private function atomDate( date:String = "" ):String {
			var timeStr:String;
			var tmpArr:Array;
			
			if( date == "" ){
				var myTime:Date = new Date();
				timeStr =  String( myTime.fullYear + "-" + zero(myTime.getMonth()+1) + "-" + zero(myTime.getDate()) + "T" + zero(myTime.getHours()) +":" + zero(myTime.getMinutes()) +":" + zero(myTime.getSeconds()) + "Z" );
			}
			else {
				tmpArr = date.split(" "); var day:String = tmpArr[0]; var dmy:String = tmpArr[1]; var heure:String = tmpArr[2];
				tmpArr = dmy.split("-"); var d:String = tmpArr[0]; var m:String = tmpArr[1]; var y:String = tmpArr[2];
				timeStr = String( y+ "-" +monthObj[m].num+ "-" +d+ "T" +heure+ "Z" );
			}
			return timeStr;
		}
		
		private function zero( value:* ):String {
			var tmpStr:String;
			if ( value >= 0 && value <= 9 ) tmpStr = "0" + value;
			else tmpStr = String(value);
			return tmpStr
		}
		
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent( evt:XmlSaverEvent ):void {
			switch( evt.type ) {
				case XmlSaverEvent.ON_ERROR: dispatchEvent( new FluxEvent( FluxEvent.ON_FLUX_PUBLISH_ERROR, { info:"flux error " } ) ); break;
				case XmlSaverEvent.ON_SAVE_XML_COMPLETE :
					saver.removeEventListener( XmlSaverEvent.ON_ERROR, manageEvent );
					saver.removeEventListener( XmlSaverEvent.ON_SAVE_XML_COMPLETE, manageEvent );
					saver.dispose();
					break;
				default : break;
			}
		}
	}
}