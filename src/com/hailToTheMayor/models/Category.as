package com.hailToTheMayor.models
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Category {
		public var id:String;
		public var name:String;
		public var icon:String;
		public var subCategories:ArrayCollection;
		
		public function toString():String {
			return "{ name: " + name + " subCategories: [" + subCategories + "] }"
		}
	}
}