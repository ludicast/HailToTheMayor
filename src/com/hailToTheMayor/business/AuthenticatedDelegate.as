package com.hailToTheMayor.business
{
	import com.hailToTheMayor.events.FoursquareResultEvent;
	import com.adobe.serialization.json.JSON;
	
	import com.hailToTheMayor.models.*;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.IResponder;
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
		
		public function getVenueInfo(venueId:String, success:Function):void {
			var url:URLRequest = new URLRequest( API_URL + "venues/" + venueId + getAuthInfo() + randomizer());
			
			var loader:URLLoader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				var venue:Venue = new Venue();
				var venueObj:* = JSON.decode(loader.data, false).response.venue;
				
				venue.id = venueObj.id;
				venue.name = venueObj.name;
				
				var userList:Array = [];
				for (var i:Number = 0; i < venueObj.hereNow.groups.length; i++) {
					var tmpUsers:Array = venueObj.hereNow.groups[i].items.map(getCheckins);
					for each (var user:User in tmpUsers) {
						userList.push(user);
					}
				
				}
				
				venue.hereNow = userList
				success(new FoursquareResultEvent(venue));
			});
			loader.load(url);
			
//  venues/VENUE_ID
		}	
	}
}