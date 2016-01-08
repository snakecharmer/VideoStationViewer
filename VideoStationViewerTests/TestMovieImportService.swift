import Foundation
import CoreData

class TestMovieImportService:MovieImportService {
    
	override func importMovieDetails(id: Int, success: (movie: Movie?, error: NSError?) -> Void) {
		
		let movieEntity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: moc)

		let movie = NSManagedObject(entity: movieEntity!, insertIntoManagedObjectContext: self.moc!) as! Movie
		movie.id = id
		movie.title = "Movie Detail"
		movie.summary = "Movie Summary"
        movie.fileId = 99
		
		success(movie: movie, error: nil)
		
	}
	
	override func importMovies(success:(total:Int, error : NSError?) -> Void) {
		let movieEntity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: moc)
		
		let movie = NSManagedObject(entity: movieEntity!, insertIntoManagedObjectContext: self.moc!) as! Movie
		movie.id = 1
		movie.title = "Movie Title"
		movie.summary = "Movie Summary"
		
		success(total: 1, error: nil)
	}

	override func importShows(success:(total:Int, error : NSError?) -> Void) {
		let showEntity =  NSEntityDescription.entityForName("Show", inManagedObjectContext: moc)
		
		let show = NSManagedObject(entity: showEntity!, insertIntoManagedObjectContext: self.moc!) as! Show
		show.id = 1
		show.title = "Movie Title"
		show.summary = "Movie Summary"
		
		success(total: 1, error: nil)
	}

}