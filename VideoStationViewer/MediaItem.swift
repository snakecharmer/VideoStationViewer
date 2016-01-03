//
//  MediaItem.swift
//  VideoStationViewer
//
//  Created by Zac Tolley on 01/01/2016.
//  Copyright © 2016 Scropt. All rights reserved.
//

import Foundation
import CoreData


class MediaItem: NSManagedObject {

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

}
