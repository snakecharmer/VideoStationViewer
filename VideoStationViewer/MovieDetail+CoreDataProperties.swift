//
//  MovieDetail+CoreDataProperties.swift
//  VideoStationViewer
//
//  Created by Zac Tolley on 15/12/2015.
//  Copyright © 2015 Scropt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MovieDetail {

    @NSManaged var cast: String?
    @NSManaged var certificate: String?
    @NSManaged var director: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var fileId: NSNumber?
    @NSManaged var lastWatched: NSNumber?
    @NSManaged var rating: NSNumber?
    @NSManaged var releaseYear: NSNumber?
    @NSManaged var summary: String?
    @NSManaged var genres: NSSet?
	@NSManaged var id: NSNumber?
	@NSManaged var title: String?

}
