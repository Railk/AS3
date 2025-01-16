/**
* 
* edit and save xml files
* 
* @author Richard Rodney.
* @version 0.3
* 
* usage : 
*  créer un objet avec type/requester/content { root:"rss", type:"image", attribute:{ nom:String(upload.fileName), url:"../images"+String(upload.fileName)}=null, content:*={type:"", content:""}string,null }
*  le premeier objet de content doit définir de façon unique l'objet.
*  les apellations dans content sont libres.
* 
* TODO: UPDATEXMLFILE > make a better remove and modify fonction allowing more complex checking base on the whole node data.
* 		FIND A WAY TO GET THE ZIPFILE RIGHT VIA AMFPHP LOAD FOR NOW IT DOESNT WORK SO I USE URLLOADER THATS MAKE MORE CODE ><
* 
*/

package railk.as3.net.saver.xml 
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import nochump.util.zip.*;
	
	import railk.as3.net.amfphp.*;
	import railk.as3.data.parser.XMLItem;
	

	public class XmlSaver extends EventDispatcher 
	{		
		private var amf         :AmfphpClient;
		private var loader      :URLLoader;
		private var current     :String;
		
		private var name       	:String;
		private var nodes       :Array;
		private var file        :String;
		private var url         :String;
		private var zip         :Boolean;
		private var updateType  :String;
		
		private var xmlFile     :XML;
		private var zipFile     :ZipOutput;
		
		
		/**
		 * CONSTRUCTEUR
		 */
		public function XmlSaver( amf:AmfphpClient ):void {
			this.amf = amf;
			initListeners();
		}
		
		/**
		 * MANAGE LISTENERS
		 */
		private function initListeners():void {
			amf.addEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.addEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
			amf.addEventListener( AmfphpClientEvent.ON_CONNEXION_ERROR, manageEvent  );
		}
		
		private function delListeners():void {
			amf.removeEventListener( AmfphpClientEvent.ON_RESULT, manageEvent );
			amf.removeEventListener( AmfphpClientEvent.ON_ERROR, manageEvent  );
			amf.removeEventListener( AmfphpClientEvent.ON_CONNEXION_ERROR, manageEvent  );
		}
		
		/**
		 * CREATE a whole new xml file replacing the old one if it exist
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function create( url:String, file:String, nodes:Array, zip:Boolean = false ):void {
			this.url = url;
			this.file = file;
			this.nodes = nodes;
			this.zip = zip;
			createXmlFile();
		}
		
		/**
		 * ADD
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function add( url:String, file:String, nodes:Array, zip:Boolean = false ):void {
			this.url = url;
			this.file = file;
			this.nodes = nodes;
			this.zip = zip;
			this.updateType = 'add';
			checkFile();
		}
		
		/**
		 * remove based on id/content
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function remove( url:String, file:String, nodes:Array, zip:Boolean = false ):void {
			this.url = url;
			this.file = file;
			this.nodes = nodes;
			this.zip = zip;
			this.updateType = 'remove';
			checkFile();
		}
		
		/**
		 * update comparison based on the id/date of each root node
		 * 
		 * @param	file
		 * @param	nodes
		 * @param	zip
		 */
		public function update( url:String, file:String, nodes:Array, zip:Boolean = false ):void {
			this.url = url;
			this.file = file;
			this.nodes = nodes;
			this.zip = zip;
			this.updateType = 'modify';
			checkFile();
		}
		
		
		/**
		 * CHECK FILE
		 */
		private function checkFile():void {
			current = 'check';
			var toCheck:String = (zip)?file.split('.')[0]+'.zip':file;
			amf.directCall( 'File.Check.url', unescape(url+'/'+toCheck) );
		}
		
		/**
		 * LOAD FILE
		 */
		private function loadFile():void {
			current = 'load';
			//AmfphpClient.call( new FileService().load( toLoad, (zip) ? 'binary' : 'xml' ), requester );
			var toLoad:String = (zip)?file.split('.')[0] + '.zip':file;
			loader = new URLLoader();
			loader.dataFormat = (zip)?'binary':'text';
			loader.addEventListener( Event.COMPLETE, loadEvent, false, 0, true );
			loader.load(new URLRequest( url+'/'+toLoad ));
		}
		
		/**
		 * SAVE FILE
		 * @param	xml
		 */
		private function saveFile( xml:XML ):void {
			if (zip) {
				current = 'file';
				var entryName:String = file.split('/')[file.split('/').length - 1];
				var zipName:String = file.split('.')[0];
				zipFile = new ZipOutput();
				var ze:ZipEntry = new ZipEntry( entryName );
				zipFile.putNextEntry(ze);
				var fileData:ByteArray = new ByteArray();
				fileData.writeUTFBytes( "<?xml version='1.0' encoding='utf-8' ?>\n"+xml.toXMLString() );
				zipFile.write(fileData);
				zipFile.closeEntry();
				zipFile.finish();	
				amf.directCall( 'File.Save.bin', unescape(url+'/'+zipName+'.zip'), zipFile.byteArray );
			} else {
				current = 'xml';
				amf.directCall( 'File.Save.xml', unescape(url+'/'+file), xml.toXMLString() );
			}	
		}
		
		/**
		 * PARSE ZIP
		 * 
		 * @param	data
		 * @return
		 */
		private function parseZip( data:ByteArray ):String {
			var loadedData:IDataInput = data ;
			var zipFile:ZipFile = new ZipFile(loadedData);
			var entry:ZipEntry = zipFile.entries[0];
			var data:ByteArray = zipFile.getInput(entry);
			return data.toString();
		}
		
		/**
		 * MANAGE EVENT
		 */
		private function manageEvent(evt:* ):void {
			switch( evt.type ) {
				case AmfphpClientEvent.ON_RESULT :
					switch( current ) {
						case 'check' :
							if ( evt.data == true ) loadFile();
							else create(url, file, nodes, zip);
							dispatchEvent( new XmlSaverEvent( XmlSaverEvent.ON_CHECK_COMLETE, { info:"problem checking file", data:evt.data } ) );
							break;
							
						case 'load' :
							if ( zip ) xmlFile = new XML( parseZip( evt.data as ByteArray ) );
							else xmlFile = new XML( evt.data );
							updateXmlFile();
							dispatchEvent( new XmlSaverEvent( XmlSaverEvent.ON_LOAD_COMPLETE, { info:"load complete" } ) );
							break;
						
						case 'xml' :
							dispatchEvent( new XmlSaverEvent( XmlSaverEvent.ON_SAVE_XML_COMPLETE, { info:"saving xml complete "+evt.data } ) );
							//dispose();
							break;
							
						case 'file' :
							dispatchEvent( new XmlSaverEvent( XmlSaverEvent.ON_SAVE_FILE_COMPLETE, { info:"saving file complete "+evt.data } ) );
							//dispose();
							break;
						
						default : break;
					}
					break;
					
				case AmfphpClientEvent.ON_ERROR :
					dispatchEvent( new XmlSaverEvent( XmlSaverEvent.ON_ERROR, { info:"problem with "+ evt.service +" file" } ));
					dispose();
					break;
					
				case AmfphpClientEvent.ON_CONNEXION_ERROR :break;
				
				default : break;
			}
		}
		
		private function loadEvent( evt:Event ):void {
			if ( zip) xmlFile = new XML( parseZip( loader.data ) );
			else xmlFile = new XML( loader.data );
			updateXmlFile();
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			delListeners();
			amf.close();
			amf = null;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						CREATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function createXmlFile():void {
			var subtype:String;
			var tmpStr:String;
			XML.ignoreProcessingInstructions = false;
			
			//--root du fichier
			if ( nodes[0].root == "rss" ) {
				tmpStr = "<rss version='2.0'></rss>";
				xmlFile = new XML( tmpStr );
				xmlFile.appendChild( "<channel></channel>" );
			}
			else if ( nodes[0].root == "atom" ) {
				tmpStr = "<feed xmlns='http://www.w3.org/2005/Atom'></feed>";
				xmlFile = new XML( tmpStr );
			}
			else{
				tmpStr = "<" + nodes[0].root + "></" + nodes[0].root + ">";
				xmlFile = new XML( tmpStr );
			}
			
			
			//--noeuds
			for ( var i:int=0; i<nodes.length; i++ ) {
				
				tmpStr = "<"+nodes[i].type;
				
				if( nodes[i].attribute != null ){
					for ( subtype in nodes[i].attribute ) {
						tmpStr += " " + subtype + "='" + nodes[i].attribute[subtype] + "' ";
					}
				}	
				
				
				if ( nodes[i].content != null && nodes[i].content is String ) {
					tmpStr += ">" + nodes[i].content +"</" + nodes[i].type +">";
				}
				else if ( nodes[i].content != null && nodes[i].content is Array ) {
										
					tmpStr += ">";
					for ( var j:int = 0; j < nodes[i].content.length; j++ ){
						tmpStr += "<"+nodes[i].content[j].type;
						
						if ( nodes[i].content[j].attribute != null ) {
							for ( subtype in nodes[i].content[j].attribute ) {
								tmpStr += " " + subtype + "='" + nodes[i].content[j].attribute[subtype] + "' ";
							}
						}
						
						tmpStr += subNode(nodes[i].content[j].content, nodes[i].content[j].type);
					}	
					tmpStr += "</" + nodes[i].type +">";
					
				}
				else {
					tmpStr += "/>";
				}
				
				if ( nodes[0].root == 'rss' ) { xmlFile.children()[0].appendChild( new XML(tmpStr) ); }
				else { xmlFile.appendChild( new XML(tmpStr) ); }	
			}
			
			saveFile( xmlFile );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				CREATE XMLFILE SUBNODE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function subNode(node:*, type:String):String {
			var subtype:String;
			var tmpStr:String;
			
			if ( node != null && node is String ) {
					tmpStr = ">" + node +"</" + type +">";
			}
			else if ( node != null && node is Array ) {
									
				tmpStr = ">";
				for ( var i:int = 0; i < node.length; i++ ){
					tmpStr += "<"+node[i].type;
					
					if ( node[i].attribute != null ) {
						for ( subtype in node[i].attribute ) {
							tmpStr += " " + subtype + "='" + node[i].attribute[subtype] + "' ";
						}
					}
					
					tmpStr += subNode(node[i].content, node[i].type);
				}	
				tmpStr += "</" + type +">";
				
			}
			else {
				tmpStr = "/>";
			}
			
			return tmpStr;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				        UPDATE XMLFILE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function updateXmlFile():void {
			var updated:Boolean = false;
			if ( nodes[0].root == 'atom' ) xmlFile = removeXmlNamespace( xmlFile );
			else if ( nodes[0].root == 'rss' ) xmlFile = rssToXml( xmlFile );
			
			var actualXML:Array = parseToNode( xmlFile );
			var newXML:Array = nodes;
			var i:int, j:int = 0;
			
			
			switch( updateType )
			{
				case 'add' :
					var nextID:int = actualXML.length + 1;
					for (i= 0; i < newXML.length; i++) 
					{
						actualXML.push( newXML[i] );
					}
					updated = true;
					nodes = actualXML;
					break;
				
				case 'remove' :
					for (i= 0; i < newXML.length; i++) 
					{
						for (j = 0; j < actualXML.length ; j++) 
						{
							if ( newXML[i].content[0].content == actualXML[j].content[0].content )
							{
								actualXML.splice(j, 1);
								updated = true;
							}
						}
					}
					nodes = actualXML;
					break;
					
				case 'modify' :
					if ( nodes[0].root == 'atom')
					{
						for (i=0; i < 5; i++) 
						{
							actualXML[i].root = 'atom';
						}
						for (i=5; i < newXML.length; i++) 
						{
							for (j = 5; j < actualXML.length ; j++) 
							{
								if ( newXML[i].content[2].content != actualXML[j].content[2].content )
								{
									actualXML[j] = newXML[i];
									updated = true;
								}
							}
						}
						if (updated) actualXML[2].content = newXML[2].content;
					}
					else if ( nodes[0].root == 'rss')
					{
						for (i=0; i < 5; i++) 
						{
							actualXML[i].root = 'rss';
							if ( i == 4 )
							{
								actualXML[i].attribute['xmlns:atom'] = 'http://www.w3.org/2005/Atom';
								actualXML[i].type = 'atom:link';
							}
						}
						for (i= 5; i < newXML.length; i++) 
						{
							for (j = 5; j < actualXML.length ; j++) 
							{
								if ( newXML[i].content[1].content != actualXML[j].content[1].content )
								{
									actualXML[j] = newXML[i];
									updated = true;
								}
							}
						}
					}
					else
					{
						for (i= 0; i < newXML.length; i++) 
						{
							for (j = 0; j < actualXML.length ; j++) 
							{
								if ( newXML[i].content[0].content != actualXML[j].content[0].content )
								{
									actualXML[j] = newXML[i];
									updated = true;
								}
							}
						}
					}	
					nodes = actualXML;
					break;
					
					default : break;
			}
			
			if ( updated ) createXmlFile();
			else dispose();
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	PARSE TO NODE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function parseToNode( xmlFile:XML ):Array {
			var result:Array = new Array();
			var nbNodes:Number = getNbChildrens( xmlFile );			
			for ( var i:int = 0; i<nbNodes; i++ ) {
				result[i] = getChildrens( xmlFile.children()[i] );
			}
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																		   GET NB CHILDREN OF A CHILD
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getNbChildrens( child:XML ):int {
			var result:int;
			result = child.children().length();
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						GET CHILDRENS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getChildrens( child:XML, sub:Boolean=false ):Object {
			var result:Object = { };
			var subResult:Object;
			var content:Array = new Array();
			
			if(!sub) result.root = child.name()+'s';
			result.type = String( child.name() );
			var attributes:Object = getAttributes( child ) ; 
			result.attribute = attributes;
			
			if ( child.children()[0] && (child.children()[0].nodeKind() == 'text' && !sub) )
			{
				result.content = String( child.children()[0] );
			}
			else
			{
				var nbChildrens:int = getNbChildrens( child );
				if ( nbChildrens != 0) {
					for ( var i:int = 0; i < nbChildrens; i++ ) 
					{
						var hasChildren:int = getSubChildrens( child.children()[i] );
						if ( hasChildren == 2 ) 
						{
							content.push( getChildrens( child.children()[i], true ) );
							result.content = content;
						}
						else if ( hasChildren == 1 ) 
						{
							subResult = new Object();
							subResult.type = String( child.children()[i].name() );
							subResult.content = String( child.children()[i] );
							subResult.attribute = getAttributes( child.children()[i] );
							content.push( subResult );
							if (nbChildrens > 1) result.content = content;
							else result.content = subResult;
						}
						else if ( hasChildren == 0 ) 
						{
							subResult = new Object();
							subResult.type = String( child.children()[i].name() );
							subResult.content = null;
							subResult.attribute = getAttributes( child.children()[i] );
							content.push( subResult );
							if (nbChildrens > 1) result.content = content;
							else result.content = subResult;
						}
					}
				}
				else 
				{
					result.content = null;
				}
			}	
			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					GET SUB CHILDRENS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getSubChildrens( child:XML ):int {
			var result:int;
			
			var nbChildrens:int = getNbChildrens( child );
			if ( nbChildrens > 1) {
				result = 2;
			}
			else {
				if ( nbChildrens == 0 ) {
					result = 0;
				}
				else {
					var childKind:String  = child.children()[0].nodeKind();
					if ( childKind == "element" ) { result = 2; }
					else { result = 1; }
				}	
			}
			return result;
		}	
				
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				    GET NB ATTRIBUTES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getNbAttributes( child:XML ):int {
			var result:int;
			result = child.@*.length();
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																				  	   GET ATTRIBUTES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function getAttributes( child:XML ):Object {
			var result:Object = {};
			var name:String;
			
			var nbAttributes:int = getNbAttributes( child ); 
			if ( nbAttributes != 0 ) {
				for( var i:int=0; i<nbAttributes; i++ ){
					name= String(child.attributes()[i].name());
					result[name] = child.attributes()[i];
				}
			}
			else {
				result = null;
			}
			
			return result;
		}
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 REMOVE NAMESPACE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function removeXmlNamespace( child:XML ):XML {
			var result:XML;
			var xmlnsPattern:RegExp = new RegExp('xmlns[a-zA-Z0-9é._%-/:"=]{1,}', '');
			result = new XML( child.toString().replace(xmlnsPattern, '') );
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					 	   RSS TO XML
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private static function rssToXml( child:XML ):XML {
			var result:XML;
			result = child.children()[0];
			return result;
		}
		
	}	
}