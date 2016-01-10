import Foundation
import CoreData

final class MovieRepository:EntityRepository {
	
	static let sharedInstance = MovieRepository(moc: CoreDataHelper.sharedInstance.managedObjectContext!)

    override init(moc:NSManagedObjectContext) {
        super.init(moc: moc)
        NSLog("Movie Repository init")
    }
    
    
    override func getEntityType() -> String? {
        return "Movie"
    }

    
	func getMovie(id:Int,
		success: ((movie: Movie?, error: NSError?) -> Void))
	{
		let fetchRequest = NSFetchRequest(entityName: "Movie")
		fetchRequest.predicate = NSPredicate(format: "id == %d", id)
		
		do {
			let results = try self.moc.executeFetchRequest(fetchRequest) as![Movie]
			if results.count == 1 {
				let movie = results[0]
				if movie.isContainsDetail == true {
					success(movie: results[0], error: nil)
                    return
				} else {
					moc.deleteObject(movie)
					self.movieImportService.importMovieDetails(id, success: success);
                    return
                }
			}
			
			
			self.movieImportService.importMovieDetails(id, success: success);
			return
		} catch {
			
		}
		
	}
	

}