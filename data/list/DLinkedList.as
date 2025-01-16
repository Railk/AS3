/**
* Doubly linked List
* 
* @author Richard Rodney
* @version 0.2
*/


package railk.as3.data.list
{
	public class DLinkedList
	{
		private var _head:DListNode;
		private var _tail:DListNode;
		private var _length:int;
		private var node:DListNode;
		
		/**
		 * ADD NODE
		 * @param	name
		 * @param	data
		 */
		public function add(name:String, data:*):DLinkedList {
			if (!_head) _head = _tail = new DListNode(0,name,data);
			else  { 
				_tail.insertAfter( new DListNode(_tail.id+1,name,data) ); 
				_tail = _tail.next; 
			}
			_length++;
			return this;
		}
		
		/**
		 * INSERT AFTER
		 * @param	node
		 * @param	name
		 * @param	data
		 */
		public function insertAfter( node:DListNode, name:String, data:* ):DLinkedList {
			node.insertAfter( new DListNode(node.id+1,name,data) );
			if ( node === _tail ) _tail = tail.next;
			else rebuildID();
			_length++;
			return this;
		}
		
		
		/**
		 * INSERT BEFORE
		 * @param	node
		 * @param	name
		 * @param	data
		 */
		public function insertBefore( node:DListNode, name:String, data:* ):DLinkedList {
			node.insertBefore( new DListNode(node.id-1,name,data) );
			if ( node === _head ) _head = _head.prev;
			_length++;
			rebuildID();
		}
		
		/**
		 * UPDATE
		 * @param	name
		 * @param	data
		 */
		public function update(name:String, data:*=null):void {
			getNodeByName( name ).data = (data != null)?data:n.data;
		}
		
		/**
		 * REMOVE
		 * @param	value  an ID/ a NAME / or an Object
		 * @return
		 */
		public function remove( value:* ):void {
			var n:DListNode = _head;
			while ( n ) {
				var type:String = (value is String)?'name':(value is int)?'id':'data';	
				if (n[type] == value ) { removeNode( n ); return; }	
				n = n.next;
			}
		}
		
		/**
		 * REMOVE NODE
		 * @param	n
		 */
		public function removeNode( n:DListNode ):void {
			if ( _length > 1 ) {
				if ( n == _head ) { _head = _head.next; _head.prev = null; }
				else if ( n == _tail ) { _tail = _tail.prev; _tail.next = null; }
				else { n.prev.next = n.next; n.next.prev = n.prev; }
			} 
			else _tail = _head = null; 
			n.dispose();
			rebuildID();
			_length--;
		}
		
		/**
		 * REBUILD ID
		 */
		private function rebuildID():void {
			var id:int = 0, n:DListNode = _head;
			while ( n ) {
				n.id = id++;
				n = n.next;
			}
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			var next:DListNode, n:DListNode = _head;
			_head = null;
			while ( n ) {
				next = n.next;
				n.next = n.prev = null;
				n = next;
			}
			_tail = null;
			_length = 0;
		}
		
		/**
		 * GET OBJECT BY NAME
		 * @param	name
		 * @return
		 */
		public function getNodeByName( name:String ):DListNode {
			var n:DListNode = _head;
			while ( n ) {
				if (n.name == name ) return n;
				n = n.next;
			}
			return null;
		}
		
		/**
		 * GET OBJECT BY ID
		 * @param	id
		 * @return
		 */
		public function getNodeByID( id:int ):DListNode {
			var n:DListNode = _head;
			while ( n ) {
				if (n.id == id ) return n;
				n = n.next;
			}
			return null;
		}
		
		/**
		 * TO STRING
		 * @return
		 */
		public function toString():String {
			var result:String = '';
			var n:DListNode = _head;
			while ( n )
			{
				result += n.toString()+'\n';
				n = n.next;
			}
			if (!result) result = '[ empty ]'
			return result;
		}
		
		/**
		 * TO ARRAY
		 * @return
		 */
		public function toArray():Array {
			var result:Array = [];
			var n:DListNode = _head;
			while ( n ) {
				result[result.length] = n.data;
				n = n.next;
			}
			return result;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get head():DListNode { return _head; }
		public function get tail():DListNode { return _tail; }
		public function get length():int { return _length; }
	}
}