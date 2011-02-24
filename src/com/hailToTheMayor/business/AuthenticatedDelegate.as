package com.hailToTheMayor.business
{
	import com.adobe.serialization.json.JSON;
	import com.hailToTheMayor.events.FoursquareResultEvent;
	import com.hailToTheMayor.models.*;
	import com.org.benrimbey.factory.VOInstantiator;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.HeaderEvent;
	import mx.rpc.events.ResultEvent;
	
	public class AuthenticatedDelegate {
				
		private var accessKey:String
		
		private static const API_URL:String = "https://api.foursquare.com/v2/"
		
		public function AuthenticatedDelegate(accessKey:String) {
			this.accessKey = accessKey;
		}
		
		protected function getAuthInfo():String {
			return "?oauth_token=" + accessKey;
 		}
		
		
		
		
		private function getCheckins(checkin:*, index:int, arr:Array):User {
			var user:User = new User();
			
			user.firstName = checkin.user.firstName;
			user.id = checkin.user.id;			
			user.photo = checkin.user.photo;
			
			return user;
		}		
		
		private function randomizer():String {
			return "&randomizer=" + Math.random() * 8000;
		}

		private function instantiate(array:Array, objClass:Class):Array {
			var result:Array = [];
			for each (var obj:* in array) {
				result.push( VOInstantiator.mapToFlexObjects(obj, objClass));	
			}
			return result;
		}
		
		public function getCategories(success:Function):void {
			load("venues/categories", function(event:Event):void {
			//	trace(event.target.data);
				var categories:Array = jsonResponse(event).categories;
				success(new FoursquareResultEvent(
					instantiate(categories, Category)
				));
			});			
		}
		
		private function load(endpoint:String, parseFunc:Function):void {
			var url:URLRequest = new URLRequest( API_URL + endpoint + getAuthInfo());
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, parseFunc);
			loader.load(url);
		}
		
		
		private function jsonResponse(event:Event):* {
			return JSON.decode(event.target.data, false).response;
		}
		
		public function getVenueInfo(venueId:String, success:Function):void {
			load("venues/" + venueId, function(event:Event):void {
				var venue:Venue = new Venue();
				var venueObj:* = jsonResponse(event).venue;
				
				venue.id = venueObj.id;
				venue.name = venueObj.name;
				
				venue.hereNow = new Vector.<User>();
				for (var i:Number = 0; i < venueObj.hereNow.groups.length; i++) {
					var tmpUsers:Array = venueObj.hereNow.groups[i].items.map(getCheckins);
					for each (var user:User in tmpUsers) {
						venue.hereNow.push(user);
					}
				}
				
				success(new FoursquareResultEvent(venue));
			});
		}	
	}
}