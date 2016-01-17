//
//  MediaItem.swift
//  VideoStationViewer
//
//  Created by Zac Tolley on 01/01/2016.
//  Copyright © 2016 Scropt. All rights reserved.
//

import UIKit
import CoreData


class MediaItem: Title {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.mediaType = self.entity.name
    }
    

	var isContainsDetail: Bool {
		get {
			if let containsDetailValue = containsDetail {
				return Bool(containsDetailValue)
			}
			return false
		}
		set {
			containsDetail = NSNumber(bool: newValue)
		}
	}
    
    func getImage(success: ((image: UIImage?, error: NSError?) -> Void)) {
        if let idValue = id {
            let imageApi = ImageAPI.sharedInstance
            imageApi.getImage(idValue.integerValue, type: self.mediaType!,  success: success)
        }
    }
    
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

}
