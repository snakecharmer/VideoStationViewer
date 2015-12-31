import UIKit
import SwiftyJSON
import Alamofire

class SessionAPI {
	
	static let sharedInstance = SessionAPI()
	
	private let preferences:NSUserDefaults = NSUserDefaults.standardUserDefaults()
	private let httpManager:Alamofire.Manager = Alamofire.Manager()
	
	var sid:String!
	
	func login(success: ((session: String?, error: NSError?) -> Void)) {
		
		func returnError() {
			self.sid = nil
			success(session: nil, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		
		var user:String?
		var password:String?
		var hostname:String?
		
		user = preferences.stringForKey("USERID")
		password = preferences.stringForKey("PASSWORD")
		hostname = preferences.stringForKey("HOSTNAME")
		
		if user == nil || password == nil || hostname == nil {
			returnError()
			return
		}
		
		let parameters = [
			"api" : "SYNO.API.Auth",
			"version": "3",
			"method": "login",
			"account": user!,
			"passwd": password!
		]
		
		httpManager.request(.GET, "http://\(hostname!):5000/webapi/auth.cgi", parameters: parameters)
			.response { request, response, data, error in
				
				if error != nil {
					returnError()
					return
				}
				
				guard let jsonData = data else {
					returnError()
					return
				}
				
				let json = JSON(data: jsonData)
				
				if let _sid = json["data"]["sid"].string {
					self.sid = _sid
					success(session: self.sid, error: nil)
					return
				}
				
				returnError()
		}
	}
	
	func getSid()->String? {
		return self.sid
	}


	
}