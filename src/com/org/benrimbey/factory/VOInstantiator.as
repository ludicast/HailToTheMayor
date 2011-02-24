package com.org.benrimbey.factory {
	import com.adobe.serialization.json.JSON;
	import com.hailToTheMayor.models.Category;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	public class VOInstantiator {
		public static function createVO(jsonSource:String,objClass:Class):Object {	
			var returnObject:Object = mapToFlexObjects(decodeJSONObject(jsonSource),objClass);
			return returnObject;	
		}
		
		public static function mapToFlexObjects(obj:Object, objClass:Class):Object {
			var returnObject:Object = new(objClass)();
			var propertyMap:XML = describeType(returnObject);
			var propertyTypeClass:Class;
			for each (var varList:XMLList in [propertyMap.variable, propertyMap.accessor]) {
			
			for each (var property:XML in varList) {	
				//trace ("looking at prop " + property.@name);
				if ((obj as Object).hasOwnProperty(property.@name)) {
				//	trace ("checking out name : " + property.@name);
					propertyTypeClass = getDefinitionByName(property.@type) as Class;
					if (
						obj[property.@name] is Array 
						//&& propertyTypeClass is Vector		
					) {
						var array:Array = obj[property.@name] as Array;
						var split:Array = String(property.@type).split("Vector.");
						var innerClassName:String = String(split[1]).slice(1,-1);
						var innerClass:Class = getDefinitionByName(innerClassName) as Class;						
						returnObject[property.@name] = new propertyTypeClass();
						for each (var item:* in obj[property.@name]) {
							returnObject[property.@name].push( 
								mapToFlexObjects(item,innerClass)
							);
						} 
						//trace("created ...  " + returnObject[property.@name]);
						
					} else if (obj[property.@name] is (propertyTypeClass)) {
						returnObject[property.@name] = obj[property.@name];
					}
				}
			}
			
			}
			return returnObject;
		}
		
		internal static function decodeJSONObject(jsonSource:String):Object {
			var jsonObj:Object = JSON.decode(jsonSource);
			return jsonObj;	
		}	
	}
}