/**
* 
*  TAG
* 
* @author Richard Rodney
* @version 0.3
*/

package railk.as3.ui.tag 
{	
	public class Tag 
	{	
		public var next:Tag;
		public var prev:Tag;
		
		public var name:String;
		public var value:Number=0;
		private var firstFile:FileNode;
		private var lastFile:FileNode;
		
		/**
		 * TAG
		 */
		public function Tag( name:String, displayObjectName:String ):void {
			this.name = name;
			this.addFile( displayObjectName );
		}
		
		public function getFile(name:String):FileNode {
			var walker:FileNode = lastFile;
			while (walker) {
				if(name == walker.name) return walker;
				walker = walker.prev;
			}
			return null;
		}
		
		public function addFile( displayObjectName:String ):void {
			var f:FileNode = new FileNode(displayObjectName);
			if (!firstFile) firstFile = lastFile = f
			else {
				lastFile.next = f;
				f.prev = lastFile;
				lastFile = f;
			}
			value++;
		}
		
		public function removeFile( file:String ):void {
			var f:FileNode = getFile(name);
			if (f.next) f.next.prev = f.prev;
			if (f.prev) f.prev.next = f.next;
			else if (firstFile == f) firstFile = f.next;
			f = null;
		}
		
		public function dispose():void {
			firstFile = lastFile = null;
		}
		
		/**
		 * HAS FILE
		 */
		public function hasFile( file:String ):Boolean {
			if ( getFile(name) ) return true;
			return false;
		}
	}
}

internal class FileNode {
	public var next:FileNode;
	public var prev:FileNode;
	public var name:String;
	public function FileNode(name:String) {
		this.name = name;
	}
}