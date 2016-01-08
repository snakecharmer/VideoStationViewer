import Foundation

class TestMovieApi:MovieAPIProtocol {
	
	var movies:[SynologyMediaItem]?
	var movie:SynologyMediaItem?
	
	
	func getMovie(id:Int,
		success: ((movie: SynologyMediaItem?, error: NSError?) -> Void))
	{
		success(movie: movie, error: nil)
	}
	
    func getMovieTitles(offset:Int=0, genre:String? = nil, limit:Int=99999, sortBy:String="added",
        success: ((movies: [SynologyMediaItem]?, total: Int, offset: Int, error: NSError?) -> Void))
    {
        
        // create 2 dummy movies and send them back
        var movie1 = SynologyMediaItem()
        movie1.id = 1
        movie1.title = "Test Title 1"
        movie1.genre = ["Comedy","Drama"]
        movie1.summary = "Test Summary 1"
        
        var movie2 = SynologyMediaItem()
        movie2.id = 2
        movie2.title = "Test Title 2"
        movie2.genre = ["Comedy","Family"]
        movie2.summary = "Test Summary 2"
        
        success(movies: [movie1,movie2], total: 2, offset: 0, error: nil)
        
    }
	
	func getTVShows(offset: Int, limit: Int, sortBy: String, success: ((shows: [SynologyMediaItem]?, total: Int, offset: Int, error: NSError?) -> Void)) {
		// create 2 dummy shows
		
		var show1 = SynologyMediaItem()
		show1.id = 1
		show1.title = "Test Title 1"
		show1.genre = ["Comedy","Drama"]
		show1.summary = "Test Summary 1"
		
		
		var show2 = SynologyMediaItem()
		show2.id = 2
		show2.title = "Test Title 2"
		show2.genre = ["Comedy","Family"]
		show2.summary = "Test Summary 2"
		
		success(shows: [show1,show2], total: 2, offset: 0, error: nil)
	}
	
	func getTVShowEpisodes(id: Int, success: ((episodes: [SynologyMediaItem]?, error: NSError?) -> Void)) {
	
		// create 3 dummy episodes
		
		var episode1 = SynologyMediaItem()
		episode1.id = 1
		episode1.title = "Test Title 1"
		episode1.summary = "Test Summary 1"
		episode1.tagline = "Tagline 1"
		episode1.showId = id
		
		
		var episode2 = SynologyMediaItem()
		episode2.id = 2
		episode2.title = "Test Title 2"
		episode2.summary = "Test Summary 2"
		episode2.tagline = "Tagline 2"
		episode2.showId = id
		
		
		var episode3 = SynologyMediaItem()
		episode3.id = 3
		episode3.title = "Test Title 3"
		episode3.summary = "Test Summary 3"
		episode3.tagline = "Tagline 3"
		episode3.showId = id
		
		success(episodes: [episode1, episode2, episode3], error: nil)
		
		
	}
	
	func getEpisode(id: Int, success: ((episode: SynologyMediaItem?, error: NSError?) -> Void)) {
		var episode1 = SynologyMediaItem()
		episode1.id = id
		episode1.title = "Test Title 1"
		episode1.summary = "Test Summary 1"
		episode1.tagline = "Tagline 1"
		episode1.showId = 99
		success(episode: episode1, error: nil)
	}
	
	
}
