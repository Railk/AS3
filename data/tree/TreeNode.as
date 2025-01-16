/**
* Tree Node
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.tree
{
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	
	public class TreeNode 
	{
		public var parent:TreeNode;
		public var name:String;
		public var o:*;
		public var childs:DLinkedList =  new DLinkedList();
		
		/**
		 * CONSTRUCTEUR
		 * @param	name
		 * @param	o
		 * @param	parent
		 */
		public function TreeNode(name:String, o:*= null, parent:TreeNode=null) {
			this.o = o;
			this.name = name;
			if (parent) {
				this.parent = parent;
				parent.childs.add(name,this);
			}
		}
		
		/**
		 * GET NODE BY NAME
		 * @param	name
		 * @return
		 */
		public function getTreeNodeByName(name:String):TreeNode {
			var result:TreeNode;
			if ( name == this.name ) result = this;
			else {
				var t:Array = treePlanner( this );
				for (var i:int = 0; i < t.length ; i++) {
					if ( t[i].name == name ) {
						result = t[i];
						break;
					}
				}
			}
			return result;
		}
		
		/**
		 * TREE PLANNER
		 * @param	from
		 * @return
		 */
		private function treePlanner( from:TreeNode ):Array {
			var result:Array = [];
			result[result.length] =  from;
			if ( from.hasChildren() ) result = result.concat( subTreePlanner( from ) );
			return result;
		}
		
		private function subTreePlanner( t:TreeNode ):Array {
			var result:Array = [], n:DListNode = t.childs.head;
			while ( n ) {
				result[result.length] = n.data;
				if ( n.data.hasChildren() ) result = result.concat( subTreePlanner( n.data ) );
				n = n.next;
			}
			return result;
		}
		
		/**
		 * DISPOSE
		 */
		public function clear():void {
			while (childs.head) {
				var node:TreeNode = childs.head.data;
				childs.removeNode(childs.head);
				node.clear();
			}
		}
		
		/**
		 * TREE TO STRING
		 * @return
		 */
		public function treeToString():String {
			var result:String='', t:Array = treePlanner( this ); 
			for (var i:int = 0; i < t.length ; i++) result += t[i]+'\n';
			return result;
		}
		
		/**
		 * TO ARRAY
		 * @return
		 */
		public function toArray():Array { return treePlanner( this ); }
		
		/**
		 * TO STRING
		 * @return
		 */
		public function toString():String {
			var s:String = "[TreeNode "+ name +" > " + (parent == null ? "(root)" : "( parent is "+parent.name+" )");
			if (childs.length == 0) s += "(leaf)";
			else s += " has " + childs.length + " child node" + (size > 1 || size == 0 ? "s" : "");
			s += ", data=" + data + "]";
			return s;
		}
		
		/**
		 * IS/HAS
		 * @return
		 */
		public function isEmpty():Boolean { return childs.length == 0; }
		public function isRoot():Boolean { return !Boolean(parent); }
		public function isLeaf():Boolean { return childs.length == 0; }
		public function hasChildren():Boolean { return childs.length > 0; }
		public function hasSiblings():Boolean {
			if (parent) return parent.childs.length > 1;
			return false;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get size():int {
			var c:int = 1, node:DListNode = childs.head;
			while (node) {
				c += TreeNode(node.data).size;
				node = node.next;
			}
			return c;
		}
		
		public function get depth():int {
			if (!parent) return 0;	
			var node:TreeNode = this, c:int = 0;
			while (node.parent) {
				c++;
				node = node.parent;
			}
			return c;
		}
		
		public function get numChildren():int { return childs.length; }
		
		public function get numSiblings():int {
			if (parent) return parent.childs.length;
			return 0;
		}
	}
}