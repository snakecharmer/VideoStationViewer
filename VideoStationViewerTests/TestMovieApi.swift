import Foundation

class TestMovieApi:MovieAPI {
	
	var movies:[SynologyMediaItem]?
	var movie:SynologyMediaItem?
	
	
	override func getMovie(id:Int,
		success: ((movie: SynologyMediaItem?, error: NSError?) -> Void))
	{
		success(movie: movie, error: nil)
	}
	
    override 	func getMovieTitles(offset:Int=0, genre:String? = nil, limit:Int=99999, sortBy:String="added",
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
	
}
