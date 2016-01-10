import Foundation
import CoreData

class EntityRepository {

    var moc:NSManagedObjectContext!
    var movieImportService:MovieImportService!
    
    init(moc:NSManagedObjectContext) {
        self.moc = moc
        self.movieImportService = MovieImportService(moc: self.moc)
    }
    
    func getEntityType() -> String? {
        return nil
    }
    
    func getSummariesForGenre(genre:String, success: ((mediaItems: [MediaItem]?, error: NSError?) -> Void))
    {
        if let entityType = self.getEntityType() {
            let fetchRequest = NSFetchRequest(entityName: entityType)
            fetchRequest.predicate = NSPredicate(format: "ANY genres.genre == %@", genre)
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
            var mediaItems:[MediaItem]?
            
            do {
                mediaItems = try self.moc.executeFetchRequest(fetchRequest) as? [MediaItem]
            } catch let error as NSError {
                success(mediaItems: nil, error: error)
                return
            }
            
            success(mediaItems: mediaItems, error: nil)
        }

    }
    
    func getGenres() -> [Genre] {
        let fetchRequest = NSFetchRequest(entityName: "Genre")
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "genre", ascending: true)
        let sortDescriptors = [descriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        if let entityTypeValue = self.getEntityType() {
            fetchRequest.predicate = NSPredicate(format: "ANY media.mediaType = %@", entityTypeValue)
        }
        
        var genres = [Genre]()
        
        do {
            genres = try moc.executeFetchRequest(fetchRequest) as![Genre]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return genres
        
    }

}
