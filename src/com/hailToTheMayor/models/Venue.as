package com.hailToTheMayor.models
{
	public class Venue {
		public var id:String;
		public var name:String;
		public var currentCheckins:Vector.<Checkin>;
		public var categories:Vector.<Category>;
	}
}