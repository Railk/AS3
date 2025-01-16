/**
 * Classes Manager in a plugin system thinking.
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class Classs
	{
		static private var classes:Dictionary = new Dictionary(true);
		static public function register(...args):void {
			for (var i:int = 0; i < args.length; ++i) classes[getQualifiedClassName(args[i]).split('::')[1]] = args[i];
		}
		
		static public function getInstance(name:String,params:Array=null):* {
			if (classes[name] != undefined) {
				var instance:*;
				try { instance = instantiate(classes[name] as Class,(params?params:[])) }
				catch (e:Error) {
					try { instance = classes[name].getInstance.apply() }
					catch (e:Error){ instance = classes[name].getInstance.apply(null,[name]) }
				}
				return instance;
			} 
			else return null;
		}
		
		static private function instantiate(c:Class,p:Array):*{
			switch(p.length) {
				case 0 : return new c(); break;
				case 1 : return new c(p[0]); break; 
				case 2 : return new c(p[0],p[1]);break;
				case 3 : return new c(p[0],p[1],p[2]);break;
				case 4 : return new c(p[0],p[1],p[2],p[3]);break;
				case 5 : return new c(p[0],p[1],p[2],p[3],p[4]);break;
				case 6 : return new c(p[0],p[1],p[2],p[3],p[4],p[5]);break;
				case 7 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6]);break;
				case 8 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);break;
				case 9 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8]);break;
				case 10 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9]); break;
				case 11 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10]); break;
				case 12 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11]); break;
				case 13 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12]); break;
				case 14 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13]); break;
				case 15 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14]); break;
				case 16 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14],p[15]); break;
				case 17 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14],p[15],p[16]); break;
				case 18 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14],p[15],p[16],p[17]); break;
				case 19 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14],p[15],p[16],p[17],p[18]); break;
				case 20 : return new c(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],p[14],p[15],p[16],p[17],p[18],p[19]); break;
				default : break;
			}
		}
	}	
}