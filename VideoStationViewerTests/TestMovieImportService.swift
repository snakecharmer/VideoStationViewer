import Foundation

class TestMovieImportService:MovieImportService {
	
	var movie:SynologyMediaItem?
	
	override func importMovieDetails(id: Int, success: (movie: Movie?, error: NSError?) -> Void) {
		
		if var movieValue = self.movie {
			movieValue.id = id
			let newMovie = self.makeMovieDetailFromSynologyMediaItem(movieValue)
			success(movie: newMovie, error: nil)
		}

		
	}
	
	
}