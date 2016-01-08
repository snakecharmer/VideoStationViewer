import Foundation
import CoreData

protocol MovieImportServiceProtocol {
	
	init(moc:NSManagedObjectContext)
	
	func importMovies(success:(total:Int, error : NSError?) -> Void)
	func importMovieDetails(id:Int, success:(movie:Movie?, error : NSError?) -> Void)
	func importShows(success:(total:Int, error : NSError?) -> Void)
	func importEpisodeDetails(id:Int, success:(episode:Episode?, error : NSError?) -> Void)
}