//
//  MovieSummary+CoreDataProperties.swift
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

extension MovieSummary {

    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var detail: MovieDetail?
    @NSManaged var genres: NSSet?

}
