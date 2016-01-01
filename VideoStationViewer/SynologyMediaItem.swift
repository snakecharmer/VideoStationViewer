import Foundation

struct SynologyMediaItem: Equatable {

	var id: Int!
	var title: String!
	var tagline: String!
	var certificate: String!
	var fileId: Int!
	var summary: String!
	var genre: [String]!
	
	var identifier: String {
		return "\(id)"
	}

}

func ==(lhs: SynologyMediaItem, rhs: SynologyMediaItem)-> Bool {
	// Two `DataItem`s are considered equal if their identifiers match.
	return lhs.id == rhs.id
}