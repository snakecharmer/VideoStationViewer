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
			"additional": "[\"genre\",\"summary\"]",
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
					let movies:[SynologyMediaItem] = self.makeMediaItems(jsonArray)
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
					let movies:[SynologyMediaItem] = self.makeMediaItems(jsonArray)
					success(movie: movies[0], error: nil)
					return
				}
				
				returnError()
		}
	}
	
	
	func getTVShows(offset:Int=0, limit:Int=99999, sortBy:String="sort_title",
		success: ((shows: [SynologyMediaItem]?, total: Int, offset: Int, error: NSError?) -> Void))
	{
		
		guard let hostname = preferences.stringForKey("HOSTNAME") else { return }
		
		var parameters = [
			"api" : "SYNO.VideoStation.TVShow",
			"version": "2",
			"method": "list",
			"offset": "\(offset)",
			"limit": "\(limit)",
			"sort_by": sortBy,
			"sort_direction": "asc",
			"additional": "[\"summary\"]",
		]
		
		func returnError() {
			success(shows: nil, total:0, offset: offset, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		httpManager
			.request(.GET, "http://\(hostname):5000/webapi/VideoStation/tvshow.cgi", parameters: parameters)
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
				
				if let jsonArray = json["data"]["tvshows"].array {
					let shows:[SynologyMediaItem] = self.makeMediaItems(jsonArray)
					var total = 0;
					if let totalValue = json["data"]["total"].int {
						total = totalValue
					}
					success(shows: shows, total: total, offset: offset, error: nil)
					return
				}
				
				returnError()
		}
	}
	
	func getTVShowEpisodes(id:Int,
		success: ((episodes: [SynologyMediaItem]?, error: NSError?) -> Void))
	{
		
		guard let hostname = preferences.stringForKey("HOSTNAME") else { return }
		
		var parameters = [
			"api" : "SYNO.VideoStation.TVShowEpisode",
			"version": "2",
			"method": "list",
			"additional": "[\"summary\"]",
			"tvshow_id": "\(id)"
		]
		
		func returnError() {
			success(episodes: nil, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		httpManager
			.request(.GET,
				"http://\(hostname):5000/webapi/VideoStation/tvshow_episode.cgi",
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
				
				if let jsonArray = json["data"]["episodes"].array {
					let episodes:[SynologyMediaItem] = self.makeMediaItems(jsonArray)
					success(episodes: episodes, error: nil)
					return
				}
				
				returnError()
		}
	}

	func getEpisode(id:Int,
		success: ((episode: SynologyMediaItem?, error: NSError?) -> Void))
	{
		
		guard let hostname = preferences.stringForKey("HOSTNAME") else { return }
		
		var parameters = [
			"api" : "SYNO.VideoStation.TVShowEpisode",
			"version": "2",
			"method": "getinfo",
			"additional": "[\"summary\",\"file\",\"actor\",\"writer\",\"director\",\"extra\",\"genre\",\"collection\",\"poster_mtime\",\"watched_ratio\"]",
			"id": "\(id)"
		]
		
		func returnError() {
			success(episode: nil, error:  NSError(domain:"com.scropt", code:1, userInfo:[NSLocalizedDescriptionKey : "Cannot Login."]))
		}
		
		httpManager
			.request(.GET,
				"http://\(hostname):5000/webapi/VideoStation/tvshow_episode.cgi",
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
				
				if let jsonArray = json["data"]["episodes"].array {
					let episodes:[SynologyMediaItem] = self.makeMediaItems(jsonArray)
					success(episode: episodes[0], error: nil)
					return
				}
				
				returnError()
		}
	}
	
	
	func makeMediaItem(mediaJson:JSON)->SynologyMediaItem {
		var media = SynologyMediaItem()
		media.id = mediaJson["id"].int
		media.title = mediaJson["title"].string
		media.sortTitle = mediaJson["sort_title"].string
		media.tagline = mediaJson["tagline"].string
		media.certificate = mediaJson["certificate"].string
		media.showId = mediaJson["tvshow_id"].int
		media.season = mediaJson["season"].int
		media.episode = mediaJson["episode"].int
		let additional = mediaJson["additional"].dictionary
		
		
		let summaryJson = additional!["summary"]
		if summaryJson != nil {
			media.summary = summaryJson!.string
		}
		if let files = additional!["file"]?.array {
			let file = files[0].dictionary
			media.fileId = file!["id"]!.int
		}
		
		if let genreJson = additional!["genre"]?.array {
			var genre:[String] = []
			
			for genreItem in genreJson {
				genre.append(genreItem.stringValue)
			}
			
			media.genre = genre
		}
		
		if let actorsJson = additional!["actor"]?.array {
			var actors = [String]()
			for actorsItem in actorsJson {
				actors.append(actorsItem.stringValue)
			}
			media.actor = actors
		}

		if let writersJson = additional!["writer"]?.array {
			var writers = [String]()
			for writersItem in writersJson {
				writers.append(writersItem.stringValue)
			}
			media.writer = writers
		}
		
		if let directorsJson = additional!["director"]?.array {
			var directors = [String]()
			for directorsItem in directorsJson {
				directors.append(directorsItem.stringValue)
			}
			media.director = directors
		}
		
		
		return media
	}
	func makeMediaItems(mediaJson:[JSON])->[SynologyMediaItem] {
		var media:[SynologyMediaItem] = []
		
		for appDict in mediaJson {
			media.append(makeMediaItem(appDict))
		}
		
		return media
	}
	
}