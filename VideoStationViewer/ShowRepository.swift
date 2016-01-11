import Foundation
import CoreData

final class ShowRepository:EntityRepository {
    
    static let sharedInstance = ShowRepository(moc: CoreDataHelper.sharedInstance.managedObjectContext!)
    
    override func getEntityType() -> String? {
        return "Show"
    }
    
    func getShow(id:Int, success: ((show: Show?, error: NSError?) -> Void))
    {
        let fetchRequest = NSFetchRequest(entityName: "Show")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try self.moc.executeFetchRequest(fetchRequest) as![Show]
            if results.count > 0 {
                let show = results[0]
                success(show: show, error: nil)
                return
            }
            
        } catch {
            
        }
        
        success(show: nil, error: nil)
        return;
        
    }
	
	func getShows() -> [Show] {
		let fetchRequest = NSFetchRequest(entityName: "Show")
		let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
		let sortDescriptors = [descriptor]
		fetchRequest.sortDescriptors = sortDescriptors
		
		var shows = [Show]()
		
		do {
			shows = try moc.executeFetchRequest(fetchRequest) as![Show]
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return shows
		
	}


	
}