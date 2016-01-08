import Foundation
import CoreData

final class TestMovieImportService:MovieImportServiceProtocol {
	
	let moc:NSManagedObjectContext!
	
	init(moc:NSManagedObjectContext) {
		self.moc = moc
	}
	
	func importMovieDetails(id: Int, success: (movie: Movie?, error: NSError?) -> Void) {
		
		let movieEntity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: moc)

		let movie = NSManagedObject(entity: movieEntity!, insertIntoManagedObjectContext: self.moc!) as! Movie
		movie.id = id
		movie.title = "Movie Title"
		movie.summary = "Movie Summary"
		
		success(movie: movie, error: nil)
		
	}
	
	func importMovies(success:(total:Int, error : NSError?) -> Void) {
		let movieEntity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: moc)
		
		let movie = NSManagedObject(entity: movieEntity!, insertIntoManagedObjectContext: self.moc!) as! Movie
		movie.id = 1
		movie.title = "Movie Title"
		movie.summary = "Movie Summary"
		
		success(total: 1, error: nil)
	}

	func importShows(success:(total:Int, error : NSError?) -> Void) {
		let showEntity =  NSEntityDescription.entityForName("Show", inManagedObjectContext: moc)
		
		let show = NSManagedObject(entity: showEntity!, insertIntoManagedObjectContext: self.moc!) as! Show
		show.id = 1
		show.title = "Movie Title"
		show.summary = "Movie Summary"
		
		success(total: 1, error: nil)
	}
	
	func importEpisodeDetails(id:Int, success:(episode:Episode?, error : NSError?) -> Void) {
		let episodeEntity =  NSEntityDescription.entityForName("Show", inManagedObjectContext: moc)
		
		let episode = NSManagedObject(entity: episodeEntity!, insertIntoManagedObjectContext: self.moc!) as! Episode
		episode.id = 1
		episode.title = "Movie Title"
		episode.summary = "Movie Summary"
		
		success(episode: episode, error: nil)
	}
	
	
}