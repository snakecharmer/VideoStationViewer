//
//  Show.swift
//  VideoStationViewer
//
//  Created by Zac Tolley on 01/01/2016.
//  Copyright © 2016 Scropt. All rights reserved.
//

import Foundation
import CoreData


class Show: Title {

    func sortedEpisodes() -> [Episode]? {
        
        if let episodeValues = self.episodes {
            let seasonSort: NSSortDescriptor = NSSortDescriptor(key: "season", ascending: true)
            let episodeSort: NSSortDescriptor = NSSortDescriptor(key: "episode", ascending: true)
            let titleSort: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            return episodeValues.sortedArrayUsingDescriptors([seasonSort, episodeSort, titleSort]) as? [Episode]
        }
        
        return nil
        
    }

}
