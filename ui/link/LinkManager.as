/**
* 
* class LinkManager
* 
* @author Richard Rodney
* @version 0.4
*/

package railk.as3.ui.link 
{	
	import flash.utils.Dictionary;
	import railk.as3.pattern.singleton.Singleton;
	
	public class LinkManager implements ILinkManager
	{	

		private var links:ILink;
		private var links_array:Array =[];
		private var groups:Dictionary = new Dictionary(true);
		
		public static function getInstance():LinkManager {
			return Singleton.getInstance(LinkManager);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function LinkManager() { Singleton.assertSingle(LinkManager); }
		
		/**
		 * ADD GROUP
		 * @param	name
		 */
		public function addGroup(name:String, navigation:Boolean = false):ILinkManager {
			if (groups[name] != undefined) throw new Error("ce groupe existe dèjà");
			groups[name] = navigation;
			return this;
		}
		
		/**
		 * DELETE GROUP
		 * @param	name
		 */
		public function delGroup(name:String):void { if (groups[name] != undefined) delete groups[name]; }
		
		/**
		 * ADD LINK
		 * 
		 * @param	target				   
		 * @param	action                 Function(type:String("hover"|"out"|"do"|"undo"),data:LinkData)=null
		 * @param	colors                 Object {hover:,out:,click:}
		 * @param   type                   'mouse' | 'roll'
		 */
		public function add( name:String, target:Object = null, action:Function = null, group:String = '', colors:Object = null, type:String = 'mouse', data:*= null):ILink {	
			if(group!="" && groups[group]== undefined) throw new Error ("le groupe "+group+" n'éxiste pas, veuillez le créer");
			if (!getLink(name)) {
				var link:ILink = links_array[links_array.length] = new Link(name, group, (group?groups[group]:false)).addTarget((target?target.name:name), target, type, action, colors, false, data);
				if (!links) links = link;
				else {
					link.prev = links;
					links = link;
				}
			} 
			else throw new Error ("liens déjà existant");
			return link;
		}
		
		/**
		 * MANAGE LINKS
		 */
		public function remove( name:String ):ILinkManager {
			var walker:ILink = links, previous:ILink;
			while (walker ) {
				if (walker.name == name) {
					if (previous) previous.prev = walker.prev;
					else links = walker.prev;
					walker.dispose();
				}
				previous = walker;
				walker = walker.prev;
			}
			return this;
		}
		
		public function getLink( name:String, group:String='' ):ILink { 
			var walker:ILink = links;
			while (walker ) {
				if(group!=""){ if (walker.name == name && walker.group == group ) return walker; }
				else{ if (walker.name == name ) return walker; }
				walker = walker.prev;
			}
			return null;
		}
		
		public function getLinks(group:String=''):Array { 
			var walker:ILink = links, result:Array=[];
			while (walker ) {
				if(group==""){ result[result.length] = walker; }
				else { if (walker.group == group ) result[result.length] = walker; }
				walker = walker.prev;
			}
			result.reverse();
			return result;
		}
		
		public function navigationChange(name:String):Boolean {
			if (!getLink(name)) return false;
			var group:String = getLink(name).group;
			if (groups[group]==undefined) return false;
			var a:Array = getLinks(group), i:int = a.length;
			if (noActive(a)) return true;
			while ( --i > -1) {
				if (a[i].active && a[i].name != name) {
					a[i].action();
					return true;
				}
			}
			return false;
		}
		
		private function noActive(a:Array):Boolean {
			var i:int = a.length;
			while ( --i > -1) if (a[i].active) return false;
			return true;
		}
	}
}