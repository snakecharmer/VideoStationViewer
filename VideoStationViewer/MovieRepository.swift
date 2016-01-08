import Foundation
import CoreData

class MovieRepository {
	
	static let sharedInstance = MovieRepository(moc: CoreDataHelper.sharedInstance.managedObjectContext!)
	
	var moc:NSManagedObjectContext!
	var movieApi:MovieAPI!
	var movieImportService:MovieImportService!

	init(moc:NSManagedObjectContext) {
		self.moc = moc
		self.movieImportService = MovieImportService(moc: self.moc)
		self.movieApi = MovieAPI.sharedInstance
	}
	
	init(moc:NSManagedObjectContext, movieImportService:MovieImportService, movieApi:MovieAPI) {
		self.moc = moc
		self.movieApi = movieApi
		self.movieImportService = movieImportService
	}
	
	func getEntitySummariesForGenre(genre:String, entityType:String = "Movie",
		success: ((mediaItems: [MediaItem]?, error: NSError?) -> Void))
	{
		let fetchRequest = NSFetchRequest(entityName: entityType)
		fetchRequest.predicate = NSPredicate(format: "ANY genres.genre == %@", genre)
		let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
		fetchRequest.sortDescriptors = [descriptor]
		var mediaItems:[MediaItem]?
		
		do {
			mediaItems = try self.moc.executeFetchRequest(fetchRequest) as? [Movie]
		} catch let error as NSError {
			success(mediaItems: nil, error: error)
			return
		}
		
		success(mediaItems: mediaItems, error: nil)
	}
	
	func getGenres(entityType:String? = nil) -> [Genre] {
		let fetchRequest = NSFetchRequest(entityName: "Genre")
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "genre", ascending: true)
        let sortDescriptors = [descriptor]
        fetchRequest.sortDescriptors = sortDescriptors
		if let entityTypeValue = entityType {
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


}