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

				let entity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: moc)
				
				for synologyMovie in moviesValue {
					
					let movieSummary = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! Movie
					movieSummary.title = synologyMovie.title
					movieSummary.id = synologyMovie.id
                    movieSummary.summary = synologyMovie.summary
					
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
	
	func importMovieDetails(id:Int, success:(movie:Movie?, error : NSError?) -> Void) {
		self.movieAPI.getMovie(id) { (movie, error) -> Void in
			if let sourceMovieValue = movie {
				let movieDetail = self.makeMovieDetailFromSynologyMediaItem(sourceMovieValue)
				movieDetail.isContainsDetail = true
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
	
	func makeMovieDetailFromSynologyMediaItem(sourceMovie:SynologyMediaItem) -> Movie {
		
		let entity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: moc)
		let movieDetail = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! Movie
		
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
	
	func importShows(success:(total:Int, error : NSError?) -> Void) {

		movieAPI.getTVShows { (shows, total, offset, error) -> Void in

			let moc = self.moc
			
			if let showsValue = shows {
				
				var toProcess = showsValue.count
				let showEntity =  NSEntityDescription.entityForName("Show", inManagedObjectContext: moc)
				
				
				for synologyShow in showsValue {
					let show = NSManagedObject(entity: showEntity!, insertIntoManagedObjectContext: moc) as! Show
					show.title = synologyShow.title
					show.id = synologyShow.id
					show.summary = synologyShow.summary
					
					self.getShowEpisodes(show, success: { (error) -> Void in
						toProcess--
							
						if toProcess == 0 {
							success(total: showsValue.count, error: nil)
						}

					})

				}
			}
		}
	}
	
	func getShowEpisodes(show: Show, success:(error: NSError?) -> Void) {
		
		self.movieAPI.getTVShowEpisodes((show.id?.integerValue)!, success: { (episodes, error) -> Void in
			
			if let synologyEpisodes = episodes {
				
				var episodeEntities = [Episode]()
				
				for synologyEpisode in synologyEpisodes {
					let episode = self.makeEpisodeFromSynologyMediaItem(synologyEpisode)
					episode.show = show
					episodeEntities.append(episode)
				}
				
				show.episodes = NSSet(array: episodeEntities)
				success(error: nil)
			}
		})
	
	}
	
	func makeEpisodeFromSynologyMediaItem(sourceEpisode: SynologyMediaItem) -> Episode {
		let entity =  NSEntityDescription.entityForName("Episode", inManagedObjectContext: moc)
		let episode = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc) as! Episode
		
		episode.id = sourceEpisode.id
		episode.title = sourceEpisode.tagline
		episode.summary = sourceEpisode.summary
		episode.fileId = sourceEpisode.fileId
        episode.season = sourceEpisode.season
        episode.episode = sourceEpisode.episode
		
		if let synologyEpisodeGenres = sourceEpisode.genre {
			var genreArray = [Genre]()
			for genre in synologyEpisodeGenres {
				let genreEntity = self.getGenreEntity(genre)
				if let genreEntityValue = genreEntity {
					genreArray.append(genreEntityValue)
				}
			}
			episode.genres = NSSet(array: genreArray)
		}
		
		return episode
	}

}