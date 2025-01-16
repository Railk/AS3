/**
* 
* uploader file filters
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.net.uploader 
{
	import flash.net.FileFilter;
	public class UpLoaderFilters 
	{	
		static public const IMGFILE                  :String ="IMGFile";
		static public const TXTFILE                  :String ="TXTFile";
		static public const SWFFILE                  :String ="SWFFile";
		static public const XMLFILE                  :String ="XMLFile";
		static public const FLVFILE                  :String = "FLVFile";
		static private var filter                    :FileFilter;
		
		public static function Type( type:String ):FileFilter {
			switch( type ) {
				case IMGFILE : filter = new FileFilter("Images", "*.jpg;*.jpeg;*.gif;*.png"); break;
				case TXTFILE : filter = new FileFilter("Text Files", "*.txt;*.rtf"); break;
				case SWFFILE : filter = new FileFilter("Flash Movies", "*.swf"); break;
				case XMLFILE : filter = new FileFilter("Xml Files", "*.xml"); break;	
				case FLVFILE : filter = new FileFilter("Video Files", "*.flv;*.mp4;*.mov"); break;
				default : break;
			}
			return filter;
		}
	}
}