import Foundation
import CoreData

class MovieRepository {
	
	static let sharedInstance = MovieRepository(moc: CoreDataHelper.sharedInstance.managedObjectContext!)
	
	var moc:NSManagedObjectContext!
	var movieApi:MovieAPI!
	var movieImportService:MovieImportService!
	
	init(moc:NSManagedObjectContext) {
		self.moc = moc
		self.movieApi = MovieAPI.sharedInstance
		self.movieImportService = MovieImportService(moc: moc)
	}
	
	func getMovieSummariesForGenre(genre:String,
		success: ((movies: [Movie]?, error: NSError?) -> Void))
	{
		let fetchRequest = NSFetchRequest(entityName: "Genre")
		fetchRequest.predicate = NSPredicate(format: "genre == %@", genre)
		var movies = [Movie]()
		
		do {
			let results = try self.moc.executeFetchRequest(fetchRequest) as![Genre]
			let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
			movies = results[0].media?.sortedArrayUsingDescriptors([descriptor]) as! [Movie]
		} catch let error as NSError {
			success(movies: [], error: error)
			return
		}
		
		success(movies: movies, error: nil)
	}
	
	func getGenres() -> [Genre] {
		let fetchRequest = NSFetchRequest(entityName: "Genre")
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "genre", ascending: true)
        let sortDescriptors = [descriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
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
	
    
    func getMovieGenres() -> [Genre] {
        let fetchRequest = NSFetchRequest(entityName: "Genre")
        fetchRequest.predicate = NSPredicate(format: "ALL media.mediaType = %@", "Movie")
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "genre", ascending: true)
        let sortDescriptors = [descriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        var genres = [Genre]()
        
        do {
            genres = try moc.executeFetchRequest(fetchRequest) as![Genre]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return genres
        
    }
}