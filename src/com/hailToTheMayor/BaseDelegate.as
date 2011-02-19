package com.hailToTheMayor
{
	import com.FoursquareResultEvent;
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	public class BaseDelegate {
				
		private var accessKey:String
		
		private static const API_URL:String = "https://api.foursquare.com/v2/"
		
		public function BaseDelegate(accessKey:String) {
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
		
		public function getVenueInfo(venueId:String, success:Function):void {
			var url:URLRequest = new URLRequest( API_URL + "venues/" + venueId + getAuthInfo());
			
			var loader:URLLoader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, function(event:Event):void {
				var venue:Venue = new Venue();
				var venueObj:* = JSON.decode(loader.data, false).response.venue;
				
				venue.id = venueObj.id;
				venue.name = venueObj.name;
				
				venue.hereNow = venueObj.hereNow.groups[1].items.map(getCheckins);
				
				success(new FoursquareResultEvent(venue));
			});
			loader.load(url);
			
//  venues/VENUE_ID
		}	
	}
}