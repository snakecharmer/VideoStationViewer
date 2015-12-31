import UIKit
import SwiftyJSON
import Alamofire

class MovieAPI
{
	
	static let sharedInstance = MovieAPI()
	
	private let preferences:NSUserDefaults = NSUserDefaults.standardUserDefaults()
	private let httpManager:Alamofire.Manager = Alamofire.Manager()
	
	func getMovieTitles(offset:Int=0, genre:String? = nil, limit:Int=99999, sortBy:String="added",
		success: ((movies: [SynologyMediaItem]?, total: Int, offset: Int, error: NSError?) -> Void))
	{
		
		guard let hostname = preferences.stringForKey("HOSTNAME") else { return }
		
		var parameters = [
			"api" : "SYNO.VideoStation.Movie",
			"version": "2",
			"method": "list",
			"offset": "\(offset)",
			"limit": "\(limit)",
			"sort_by": sortBy,
			"sort_direction": "desc",
			"additional": "[\"genre\"]",
			"library_id": "0"
		]
		
		if let genreValue = genre {
			parameters["genre"] = "[\"\(genreValue)\"]"
		}
		
		func returnError() {
			success(movies: nil, total:0, offset: offset, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		httpManager
			.request(.GET, "http://\(hostname):5000/webapi/VideoStation/movie.cgi", parameters: parameters)
			.response { request, response, data, error in
				
				if error != nil {
					returnError()
					return
				}
				
				guard let jsonData = data else {
					returnError()
					return
				}
				
				let json = JSON(data: jsonData)
				
				if let jsonArray = json["data"]["movies"].array {
					let movies:[SynologyMediaItem] = self.makeMovies(jsonArray)
					var total = 0;
					if let totalValue = json["data"]["total"].int {
						total = totalValue
					}
					success(movies: movies, total: total, offset: offset, error: nil)
					return
				}
				
				returnError()
		}
	}
	
	func getMovie(id:Int,
		success: ((movie: SynologyMediaItem?, error: NSError?) -> Void))
	{
		
		guard let hostname = preferences.stringForKey("HOSTNAME") else { return }
		
		var parameters = [
			"api" : "SYNO.VideoStation.Movie",
			"version": "2",
			"method": "getinfo",
			"additional": "[\"poster_mtime\",\"summary\",\"watched_ratio\",\"collection\",\"file\",\"actor\",\"write\",\"director\",\"genre\",\"extra\"]",
			"id": "\(id)"
		]
		
		func returnError() {
			success(movie: nil, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		httpManager
			.request(.GET,
					"http://\(hostname):5000/webapi/VideoStation/movie.cgi",
					parameters: parameters)
			.response { request, response, data, error in
				
				if error != nil {
					returnError()
					return
				}
				
				guard let jsonData = data else {
					returnError()
					return
				}
				
				let json = JSON(data: jsonData)
				
				if let jsonArray = json["data"]["movies"].array {
					let movies:[SynologyMediaItem] = self.makeMovies(jsonArray)
					success(movie: movies[0], error: nil)
					return
				}
				
				returnError()
		}
	}
	
	
	func makeMovie(movieJson:JSON)->SynologyMediaItem {
		var movie = SynologyMediaItem()
		movie.id = movieJson["id"].int
		movie.title = movieJson["title"].string
		movie.tagline = movieJson["tagline"].string
		movie.certificate = movieJson["certificate"].string
		let additional = movieJson["additional"].dictionary
		
		
		let summaryJson = additional!["summary"]
		if summaryJson != nil {
			movie.summary = summaryJson!.string
		}
		if let files = additional!["file"]?.array {
			let file = files[0].dictionary
			movie.fileId = file!["id"]!.int
		}
		
		if let genreJson = additional!["genre"]?.array {
			var genre:[String] = []
			
			for genreItem in genreJson {
				genre.append(genreItem.stringValue)
			}
			
			movie.genre = genre
		}
		return movie
	}
	func makeMovies(moviesJson:[JSON])->[SynologyMediaItem] {
		var movies:[SynologyMediaItem] = []
		
		for appDict in moviesJson {
			movies.append(makeMovie(appDict))
		}
		
		return movies
	}
	
}