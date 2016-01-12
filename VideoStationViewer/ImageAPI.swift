import UIKit
import Alamofire


class ImageAPI {
	
	static let sharedInstance = ImageAPI()
	static var processedImageCache = NSCache()

	private let preferences:NSUserDefaults = NSUserDefaults.standardUserDefaults()
	let httpManager:Alamofire.Manager = Alamofire.Manager()

	func getImage(id: Int, type: String = "Movie", success: ((image: UIImage?, error: NSError?) -> Void)) {
		
		var imageType = type.lowercaseString
		if (imageType == "episode") {
			imageType = "tvshow_episode"
		}

		func returnError() {
			success(image: nil, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		let cachedImage = ImageAPI.processedImageCache.objectForKey(id) as? NSData
		
		if let cachedImageValue = cachedImage {
			guard let image = UIImage(data: cachedImageValue) else { return }
			success(image: image, error: nil)
			return
		}
		
		let preferences = NSUserDefaults.standardUserDefaults()
		guard let hostname = preferences.stringForKey("HOSTNAME") else { return }
		
		let parameters = [
			"api" : "SYNO.VideoStation.Poster",
			"version": "1",
			"method": "getimage",
			"id": "\(id)",
			"type": imageType
		]
		
		httpManager.request(.GET, "http://\(hostname):5000/webapi/VideoStation/poster.cgi", parameters: parameters)
			.response { request, response, data, error in
				
				if error != nil {
					returnError()
					return
				}
				
				guard let imageData = data else {
					returnError()
					return
				}
				
				ImageAPI.processedImageCache.setObject(imageData, forKey: id)
				guard let image = UIImage(data: imageData) else { return }
				success(image: image, error: nil)

				
		}
		
	}
	
}