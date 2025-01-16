/**
 * HASHMAP
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.hashmap
{
    import flash.utils.Dictionary;
    public class HashMap implements IMap
    {
        protected var map:Dictionary;
        public function HashMap(useWeakReferences:Boolean=true) {
            map = new Dictionary( useWeakReferences );
        }

        public function add(key:*, value:*):void {
            map[key] = value;
        }
        
        public function remove(key:*):void {
            delete map[key];
        }

        public function containsKey(key:*):Boolean {
            return map.hasOwnProperty( key );
        }

        public function containsValue(value:*):Boolean {
            for ( var key:* in map ) if ( map[key] == value ) return true;
            return false;
        }

        public function getKey(value:*):* {
            for ( var key:* in map ) if ( map[key] == value ) return key;
            return null;
        }

        public function getKeys():Array {
            var keys:Array = [];
            for (var key:* in map) keys.push( key );
            return keys;
        }
		
        public function getValue(key:*):* {
            return map[key];
        }

        public function getValues():Array {
            var values:Array = [];
            for (var key:* in map) values.push( map[key] );
            return values;
        }

        public function size():int {
            var length:int = 0;
            for (var key:* in map) length++;
            return length;
        }

        public function isEmpty():Boolean {
            return size() <= 0;
        }

        public function reset():void {
            for ( var key:* in map ) map[key] = undefined;
        }

        public function resetAllExcept(keyId:*):void {
            for ( var key:* in map ) if ( key != keyId ) map[key] = undefined;
        }

        public function clear():void {
            for ( var key:* in map ) remove( key );
        }

        public function clearAllExcept(keyId:*):void {
            for ( var key:* in map ) if ( key != keyId ) remove( key );
        }
    }
}