//
//  Episode.swift
//  VideoStationViewer
//
//  Created by Zac Tolley on 01/01/2016.
//  Copyright © 2016 Scropt. All rights reserved.
//

import UIKit
import CoreData


class Episode: MediaItem {

	func getImage(success: ((image: UIImage?, error: NSError?) -> Void)) {
		if let idValue = id {
			let imageApi = ImageAPI.sharedInstance
			imageApi.getImage(idValue.integerValue, type: "episode", success: success)
		}
	}

}
