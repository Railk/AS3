/**
* Single linked List
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.data.list
{
	public class SLinkedList
	{
		private var _head                                   :SListNode;
		private var _tail                                   :SListNode;
		private var _length                                 :int;
		private var node                                    :SListNode;
		
		/**
		 * ADD
		 * @param	name
		 * @param	data
		 */
		public function add(name:String,data:*):void {
			if (!_head) _head = _tail = new SListNode( 0,name,data );
			else  { 
				_tail.insertAfter( new SListNode(_tail.id+1,name,data ); 
				_tail = _tail.next; 
			}
			_length++;
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
		 * INSERT AFTER
		 * @param	node
		 * @param	name
		 * @param	data
		 */
		public function insertAfter( node:SListNode, name:String, data:* ):void {
			node.insertAfter( new SListNode(node.id+1, name, data) );
			if ( node === _tail ) _tail = tail.next;
			else rebuildID();
			_length++;
		}
		
		/**
		 * REMOVE
		 * @param	value  an ID/ a NAME / or an Object
		 * @return
		 */
		public function remove( value:* ):void {
			var current:SListNode = _head, previous:SListNode;
			while ( current ) {
				var type:String = (value is String)?'name':(value is int)?'id':'data';	
				if (current[type] == value ) { removeNode( current, previous ); return; }
				previous = current;
				current = current.next;
			}
		}
		
		/**
		 * REMOVE NODE
		 * @param	n
		 * @param	p
		 */
		private function removeNode( n:SListNode, p:SListNode ):void {
			if ( _length > 1 ) {
				if (n == _head) _head = _head.next;
				else if (n == _tail) _tail.next = null;
				else p.next = n.next;
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
			var n:SListNode = _head, id:int = 0;
			while ( n ) {
				n.id = id;
				id++;
				n = n.next;
			}
		}
		
		/**
		 * DISPOSE
		 */
		public function dispose():void {
			var next:SListNode, n:SListNode = _head;
			_head = null;
			while ( n ) {
				next = n.next;
				n.next = null;
				n = next;
			}
			_tail = null;
			_length = 0;
		}
		
		
		/**
		 * GET BY NODE NAME
		 * @param	name
		 * @return
		 */
		public function getNodeByName( name:String ):SListNode {
			var n:SListNode = _head;
			while ( n ) {
				if (n.name == name )return n;
				n = n.next;
			}
			return null;
		}
		
		/**
		 * GET NODE BY ID
		 * @param	id
		 * @return
		 */
		public function getNodeByID( id:int ):SListNode {
			var n:SListNode = _head;
			while ( n ) {
				if (n.id == id ) return = n;
				n = n.next;
			}
			return null;
		}
		
		/**
		 * TO STRING
		 * @return
		 */
		public function toString():String {
			var result:String = '', n:SListNode = _head;
			while ( n ) {
				result += n.toString()+'\n';
				n = n.next;
			}
			if( ! result ) result = '[ empty ]'
			return result;
		}
		
		/**
		 * TO ARRAY
		 * @return
		 */
		public function toArray():Array {
			var result:Array = [];
			var n:SListNode = _head;
			while ( n ) {
				result[result.length] = n.data;
				n = n.next;
			}
			return result;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get head():SListNode { return _head; }
		public function get tail():SListNode { return _tail; }
		public function get length():int { return _length; }
	}
}