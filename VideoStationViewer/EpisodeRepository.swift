import Foundation
import CoreData

final class EpisodeRepository:EntityRepository {
    
    static let sharedInstance = EpisodeRepository(moc: CoreDataHelper.sharedInstance.managedObjectContext!)
    
    override init(moc:NSManagedObjectContext) {
        super.init(moc: moc)
        NSLog("Episode Repository init")
    }
    
    
    override func getEntityType() -> String? {
        return "Episode"
    }
    
    
    func getEpisode(id:Int,
        success: ((episode: Episode?, error: NSError?) -> Void))
    {
        let fetchRequest = NSFetchRequest(entityName: "Episode")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try self.moc.executeFetchRequest(fetchRequest) as![Episode]
            if results.count == 1 {
                success(episode: results[0], error: nil)
                return
            }
            
        } catch {
            
        }

        success(episode: nil, error: nil)
        
    }
    
    
}