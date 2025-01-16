/**
 * File utils
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{	
	public class FileUtil
	{
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		
		public static function readFile(file:File):String {
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var str:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return str;
		}
	}
}