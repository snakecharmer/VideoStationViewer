import Foundation

protocol MovieAPIProtocol {
	func getMovieTitles(offset:Int, genre:String?, limit:Int, sortBy:String,
	success: ((movies: [SynologyMediaItem]?, total: Int, offset: Int, error: NSError?) -> Void))
	
	func getMovie(id:Int, success: ((movie: SynologyMediaItem?, error: NSError?) -> Void))

	func getTVShows(offset:Int, limit:Int, sortBy:String,
	success: ((shows: [SynologyMediaItem]?, total: Int, offset: Int, error: NSError?) -> Void))

	func getTVShowEpisodes(id:Int, success: ((episodes: [SynologyMediaItem]?, error: NSError?) -> Void))
	
	func getEpisode(id:Int, success: ((episode: SynologyMediaItem?, error: NSError?) -> Void))
}