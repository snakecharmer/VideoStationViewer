import Foundation
import CoreData

class MovieImportService {
	
	var movieAPI = MovieAPI.sharedInstance
	var moc:NSManagedObjectContext!
	
	init(moc:NSManagedObjectContext) {
		self.moc = moc
	}
	
	func importMovies(success:(total:Int, error : NSError?) -> Void) {
		
		// Get the moments
		movieAPI.getMovieTitles { (movies, total, offset, error) -> Void in
			
			var count = 0
			let moc = self.moc
			
			if let moviesValue = movies {

				let entity =  NSEntityDescription.entityForName("MovieSummary", inManagedObjectContext: moc)
				
				for synologyMovie in moviesValue {
					
					let movieSummary = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! MovieSummary
					movieSummary.title = synologyMovie.title
					movieSummary.id = synologyMovie.id
					
					if let synologyMovieGenres = synologyMovie.genre {
						var genreArray = [Genre]()
						for genre in synologyMovieGenres {
							let genreEntity = self.getGenreEntity(genre)
							if let genreEntityValue = genreEntity {
								genreArray.append(genreEntityValue)
							}
						}
						movieSummary.genres = NSSet(array: genreArray)
					}
					count++
				}
				
				success(total: count, error: nil)
				return;
			}
			
		}
	}
	
	func importMovieDetails(id:Int, success:(movie:MovieDetail?, error : NSError?) -> Void) {
		self.movieAPI.getMovie(id) { (movie, error) -> Void in
			if let sourceMovieValue = movie {
				let movieDetail = self.makeMovieDetailFromSynologyMediaItem(sourceMovieValue)
				success(movie: movieDetail, error: nil)
			} else {
				success(movie: nil, error: nil)
			}
		}
	}
	
	func getGenreEntity(genre:String) -> Genre? {
		
		let genreEntity:Genre?
		
		do {
			let predicate = NSPredicate(format: "genre == %@", genre)
			let fetchRequest = NSFetchRequest(entityName: "Genre")
			fetchRequest.predicate = predicate
			
			let fetchedEntities = try moc.executeFetchRequest(fetchRequest)
			
			if fetchedEntities.count == 1 {
				genreEntity = fetchedEntities[0] as? Genre
				return genreEntity
			} else {
				let entity =  NSEntityDescription.entityForName("Genre", inManagedObjectContext: moc)
				let genreEntity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.moc) as! Genre
				genreEntity.genre = genre
				return genreEntity
			}
			
		} catch {
			NSLog("Error getting Genre")
		}

		return nil
	}
	
	func makeMovieDetailFromSynologyMediaItem(sourceMovie:SynologyMediaItem) -> MovieDetail {
		
		let entity =  NSEntityDescription.entityForName("MovieDetail", inManagedObjectContext: moc)
		let movieDetail = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! MovieDetail
		
		movieDetail.id = sourceMovie.id
		movieDetail.title = sourceMovie.title
		movieDetail.summary = sourceMovie.summary
		movieDetail.fileId = sourceMovie.fileId
		
		if let synologyMovieGenres = sourceMovie.genre {
			var genreArray = [Genre]()
			for genre in synologyMovieGenres {
				let genreEntity = self.getGenreEntity(genre)
				if let genreEntityValue = genreEntity {
					genreArray.append(genreEntityValue)
				}
			}
			movieDetail.genres = NSSet(array: genreArray)
		}
		
		return movieDetail
		
	}
}