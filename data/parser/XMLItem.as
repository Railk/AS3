/**
* xml parser class
* 
* @author richard rodney
* @version 0.2
*/

package railk.as3.data.parser 
{	
	public class XMLItem 
	{	
		/**
		 * PARSE
		 * 
		 * @param	xmlFile
		 * @return
		 */
		public static function parse( xmlFile:XML ):Array {
			var result:Array = new Array(), nbNodes:Number = getNbChildrens( xmlFile );
			for ( var i:int = 0; i<nbNodes; i++ ) result[i] = getChildrens( xmlFile.children()[i] );
			return result;
		}
		
		/**
		 * CHILDREN UTILITIES
		 * 
		 * @param	child
		 * @return
		 */
		private static function getNbChildrens( child:XML ):int { return child.children().length(); }
		
		
		private static function getChildrens( child:XML ):Object {
			var result:Object = {}, name:String, attributes:Object = getAttributes( child ), nbChildrens:int = getNbChildrens( child );
			if ( nbChildrens != 0) {
				for ( var i:int = 0; i < nbChildrens; i++ ) {
					var hasChildren:int = getSubChildrens( child.children()[i] );
					if ( hasChildren == 2 ) {
						name = String( child.children()[i].name() );
						result[name] = getChildrens( child.children()[i] );
					}
					else if ( hasChildren == 1 ) {
						name = String( child.children()[i].name() );
						if( result[name] ) result[name] += ','+child.children()[i];
						else result[name] = child.children()[i];
						var subAttributes:Object = getAttributes( child.children()[i] );
						if ( subAttributes ) result[name + "_attributes"] = subAttributes;
					}
					else if ( hasChildren == 0 ) {
						name = String( child.children()[i].name() );
						result[name] = getAttributes( child.children()[i] );
					}
				}
				if(attributes) result["attributes"] = attributes;
			} else {
				if ( attributes != null) {
					name = String( child.name() );
					result[name] = attributes;
				} else {
					result = null;
				}	
			}
			return result;
		}
		
		private static function getSubChildrens( child:XML ):int {
			var result:int, nbChildrens:int = getNbChildrens( child );
			if ( nbChildrens > 1) result = 2;
			else {
				if ( nbChildrens == 0 ) result = 0;
				else {
					var childKind:String  = child.children()[0].nodeKind();
					if ( childKind == "element" ) result = 2;
					else result = 1;
				}	
			}
			return result;
		}	
		
		/**
		 * ATTRIBUTE UTILITIES
		 * 
		 * @param	child
		 * @return
		 */
		private static function getNbAttributes( child:XML ):int { return child.@*.length(); }
		
		private static function getAttributes( child:XML ):Object {
			var result:Object = {}, nbAttributes:int = getNbAttributes( child ); 
			if ( nbAttributes != 0 ) for( var i:int=0; i<nbAttributes; i++ ) result[String(child.attributes()[i].name())] = child.attributes()[i];
			else result = null;
			return result;
		}
		
		
		/**
		 * REMOVE NAMESPACE
		 * @param	child
		 * @return
		 */
		private static function removeXmlNamespace( child:XML ):XML {
			var xmlnsPattern:RegExp = new RegExp('xmlns[ a-zA-Z0-9é._%-/:"=]{1,}', '');
			return child.replace(xmlnsPattern, '');
		}
	}
}