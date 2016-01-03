
import UIKit
import CoreData


class Movie: MediaItem {

	func getMovieUrl() -> NSURL? {
		if let fileIdValue = fileId {
			let sessionAPI = SessionAPI.sharedInstance
			
			let preferences = NSUserDefaults.standardUserDefaults()
			guard let hostname = preferences.stringForKey("HOSTNAME") else { return nil }
			
			let urlString = "http://\(hostname):5000/webapi/VideoStation/video.cgi/1.mp4?id=\(fileIdValue)&api=SYNO.VideoStation.Video&method=download&version=1&_sid=\(sessionAPI.getSid())"
			
			return NSURL(string: urlString)
		} else {
			return nil
		}
	}
	
	func getImage(success: ((image: UIImage?, error: NSError?) -> Void)) {
		if let idValue = id {
			let imageApi = ImageAPI.sharedInstance
			imageApi.getImage(idValue.integerValue, success: success)
		}
	}

}
