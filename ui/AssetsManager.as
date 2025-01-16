/**
 * Assets Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class AssetsManager
	{
		static private var assets:Dictionary = new Dictionary(true);
		
		static public function addAssets(...assets):void {
			for (var i:int = 0; i < assets.length; i++) addAsset(assets[i]);
		}
		
		static public function addAsset(name:String,data:*=null):void {
			if (data) assets[name] = data;
			else assets[name] = getDefinitionByName( name ) as Class;
		}
		
		static public function getAsset(name:String):* {
			if ( assets[name] != undefined) return assets[name];
			throw new Error("l'asset "+name+" n'existe pas");
		}
		
		static public function hasAsset(name:String):*{
			return (assets[name] !== undefined);
		}
	}
}