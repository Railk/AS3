/**
* Video Player Metadatas
* 
* @author Richard Rodney.
* @version 0.1
*/

package railk.as3.video  
{
	public class VideoMetadatas
	{
		public var duration:Number;
		public var width:Number;
		public var height:Number;
		public var keyframes:Object;
		public var isH264:Boolean;
		
		public function VideoMetadatas(data:Object=null) {		
			if (data != null) 
			{
				width = data["width"];
				height = data["height"];
				duration = data["duration"];
				
				if(data["keyframes"] != null)
				{
					isH264 = false;
					keyframes = data["keyframes"];
				}
				else if(data["seekpoints"] != null)
				{
					isH264 = true;
					keyframes = new Object();
					keyframes["times"] = new Array();
					keyframes["filepositions"] = new Array();
					
					for(var i:String in data["seekpoints"]) {
						keyframes["times"][i] = data["seekpoints"][i]["time"] as Number;
						keyframes["filepositions"][i] = data["seekpoints"][i]["offset"] as Number;
					}
				}
				else keyframes = null;
			}
		}
	}
}