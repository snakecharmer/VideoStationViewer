//
//  MediaItem+CoreDataProperties.swift
//  VideoStationViewer
//
//  Created by Zac Tolley on 10/01/2016.
//  Copyright © 2016 Scropt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MediaItem {

    @NSManaged var certificate: String?
    @NSManaged var containsDetail: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var fileId: NSNumber?
    @NSManaged var lastWatched: NSNumber?
    @NSManaged var mediaType: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var releaseYear: NSNumber?
    @NSManaged var cast: NSSet?
    @NSManaged var directors: NSSet?
    @NSManaged var genres: NSSet?

}
