extends Node

var artists = ["Debug Test", "John Doe", "Mike Wowza", "Sharon O'Shea", "Laura Wille", "Roger S.", "Jane D'Goode"]

const paintings = {
	"painting1" : {"name": "Broadcaster", "artist": 1, "colors": ["e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","000000","e74c3c","9b59b6","9b59b6","9b59b6","9b59b6","3498db","3498db","3498db","f1c40f","9b59b6","9b59b6","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","f1c40f","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","2ecc71","3498db","f1c40f","9b59b6","f39c12","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","f39c12","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","f39c12","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","f1c40f","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","9b59b6","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","f1c40f","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","f1c40f","f1c40f","9b59b6","f39c12","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","9b59b6","9b59b6","9b59b6","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","3498db","f1c40f","3498db","3498db","3498db","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","3498db","3498db","f1c40f","f1c40f","3498db","3498db","3498db","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","3498db","9b59b6","3498db","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","000000","e74c3c","e74c3c","9b59b6","9b59b6","9b59b6","9b59b6","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","000000","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","000000"]},
	"painting2" : {"name": "Sunflower", "artist": 2, "colors": ["3498db","3498db","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","2ecc71","9b59b6","9b59b6","9b59b6","9b59b6","2ecc71","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","2ecc71","9b59b6","9b59b6","9b59b6","9b59b6","2ecc71","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","2ecc71","9b59b6","9b59b6","9b59b6","9b59b6","2ecc71","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","2ecc71","9b59b6","9b59b6","9b59b6","9b59b6","2ecc71","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","3498db","3498db","3498db","3498db","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db"]},
	"painting3" : {"name": "House", "artist": 3, "colors": ["f1c40f","f1c40f","3498db","f1c40f","3498db","3498db","3498db","3498db","3498db","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","3498db","f1c40f","f1c40f","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","ffffff","ffffff","ffffff","ffffff","3498db","3498db","3498db","3498db","f1c40f","3498db","3498db","3498db","ffffff","ffffff","ffffff","3498db","3498db","3498db","3498db","3498db","3498db","3498db","f1c40f","3498db","3498db","3498db","3498db","ffffff","ffffff","ffffff","ffffff","ffffff","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","ffffff","ffffff","ffffff","3498db","3498db","3498db","e74c3c","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","e74c3c","e74c3c","e74c3c","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","f39c12","f39c12","f39c12","3498db","3498db","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","f39c12","000000","f39c12","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","f39c12","000000","f39c12","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","f1c40f","3498db","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","f39c12","f39c12","2ecc71","2ecc71","9b59b6","2ecc71","2ecc71","2ecc71","3498db","2ecc71","2ecc71","2ecc71","f39c12","f39c12","f39c12","f39c12","2ecc71","2ecc71","2ecc71","9b59b6","f1c40f","9b59b6","2ecc71","2ecc71","2ecc71","2ecc71","f39c12","f39c12","2ecc71","2ecc71","2ecc71","2ecc71","e74c3c","2ecc71","2ecc71","2ecc71","9b59b6","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","e74c3c","f1c40f","e74c3c","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","e74c3c","2ecc71"]},
	"painting4" : {"name": "Sad Clown", "artist": 5, "colors": ["f1c40f","f1c40f","000000","000000","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","000000","000000","000000","f1c40f","f1c40f","000000","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","000000","000000","f1c40f","000000","f1c40f","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","000000","f1c40f","000000","f1c40f","f1c40f","f1c40f","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","000000","f1c40f","f1c40f","f1c40f","000000","f1c40f","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","000000","f1c40f","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","3498db","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","3498db","f1c40f","f1c40f","f1c40f","f1c40f","3498db","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","3498db","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","f1c40f","f1c40f","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","e74c3c","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","e74c3c","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","f39c12","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","f39c12","e74c3c","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f"]},
	"painting5" : {"name": "Sunset", "artist": 3, "colors": ["000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","e74c3c","e74c3c","e74c3c","e74c3c","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","e74c3c","e74c3c","e74c3c","e74c3c","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","2ecc71","3498db","2ecc71","3498db","2ecc71","3498db","3498db","3498db","3498db","2ecc71","3498db","2ecc71","3498db","2ecc71","3498db","3498db","3498db","2ecc71","3498db","2ecc71","3498db","3498db","3498db","3498db","3498db","3498db","2ecc71","3498db","2ecc71","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f"]},
	"painting6" : {"name": "Conversation", "artist": 1, "colors": ["9b59b6","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","9b59b6","3498db","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","3498db","3498db","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","ffffff","ffffff","ffffff","ffffff","000000","000000","000000","000000","000000","3498db","3498db","e74c3c","e74c3c","f1c40f","f1c40f","f1c40f","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","000000","000000","3498db","3498db","f1c40f","f1c40f","f39c12","ffffff","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","ffffff","000000","3498db","3498db","f1c40f","f39c12","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","3498db","3498db","f39c12","f39c12","f39c12","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","2ecc71","2ecc71","2ecc71","3498db","9b59b6","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","9b59b6"]},
	"painting7" : {"name": "Conformity", "artist": 2, "colors": ["000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","e74c3c","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","f1c40f","000000","000000","e74c3c","000000","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","f1c40f","000000","000000","e74c3c","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","f1c40f","000000","000000","e74c3c","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","f1c40f","000000","000000","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","e74c3c","000000","000000","9b59b6","000000","f1c40f","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","e74c3c","000000","000000","9b59b6","000000","f1c40f","000000","000000","f39c12","000000","000000","000000","000000","000000","000000","000000","e74c3c","000000","000000","9b59b6","000000","f1c40f","000000","000000","f39c12","000000","9b59b6","000000","000000","2ecc71","000000","000000","000000","000000","000000","000000","000000","f1c40f","000000","000000","f39c12","000000","9b59b6","000000","000000","2ecc71","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","f39c12","000000","9b59b6","000000","000000","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","000000","000000","f39c12","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","2ecc71","000000","000000","f39c12","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","2ecc71","000000","000000","f39c12","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","2ecc71","000000","000000","f39c12","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","000000","2ecc71","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000","000000"]},
	"painting8" : {"name": "Summer", "artist": 3, "colors": ["f1c40f","f1c40f","9b59b6","f1c40f","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","9b59b6","f1c40f","f1c40f","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","f1c40f","3498db","3498db","2ecc71","3498db","3498db","3498db","ffffff","ffffff","3498db","3498db","3498db","3498db","3498db","f1c40f","3498db","3498db","3498db","2ecc71","2ecc71","2ecc71","3498db","3498db","3498db","3498db","3498db","2ecc71","3498db","ffffff","ffffff","3498db","3498db","3498db","2ecc71","2ecc71","2ecc71","f39c12","2ecc71","3498db","3498db","3498db","2ecc71","2ecc71","2ecc71","3498db","3498db","3498db","ffffff","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","2ecc71","f39c12","2ecc71","2ecc71","2ecc71","3498db","3498db","3498db","3498db","2ecc71","f39c12","2ecc71","2ecc71","2ecc71","3498db","ffffff","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","3498db","3498db","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","3498db","2ecc71","2ecc71","2ecc71","f39c12","2ecc71","3498db","3498db","3498db","3498db","3498db","3498db","f39c12","3498db","3498db","3498db","3498db","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","3498db","000000","000000","000000","000000","000000","f39c12","000000","000000","000000","000000","000000","000000","f39c12","000000","000000","000000","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","ffffff","f1c40f","f1c40f","f1c40f","f39c12","f1c40f","3498db","3498db","3498db","f1c40f","f1c40f","f39c12","f1c40f","ffffff","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","3498db","3498db","3498db","3498db","3498db","f1c40f","f39c12","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","ffffff","f1c40f","f1c40f","3498db","3498db","3498db","3498db","3498db","3498db","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","3498db","3498db","f1c40f","f1c40f","f1c40f","ffffff","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f","f1c40f"]}
#	"painting9" : {"name": "Praise The Sun", "artist": 0, "colors": ["f39c12","3498db","f39c12","3498db","f39c12","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","f39c12","f39c12","f39c12","3498db","3498db","3498db","000000","3498db","3498db","3498db","3498db","3498db","000000","3498db","3498db","f39c12","f39c12","f1c40f","f39c12","f39c12","3498db","3498db","3498db","000000","3498db","ffffff","3498db","000000","3498db","3498db","3498db","3498db","f39c12","f39c12","f39c12","3498db","3498db","3498db","3498db","000000","3498db","ffffff","3498db","000000","3498db","3498db","3498db","f39c12","3498db","f39c12","3498db","f39c12","3498db","3498db","3498db","000000","3498db","e74c3c","3498db","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","e74c3c","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","e74c3c","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","3498db","000000","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","3498db","000000","3498db","000000","3498db","3498db","3498db","3498db","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","000000","2ecc71","000000","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","000000","2ecc71","000000","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71","2ecc71"]}
}

const statues = {
	"statue1" : {"name": "Aviator", "artist": 4, "data": [
		{"type": "cube", "position": [0.0, 1.0, 0.0]},
		{"type": "cube", "position": [2.5, 3.0, 0.0]},
		{"type": "cube", "position": [-2.5, 3.0, 0.0]},
		{"type": "cube", "position": [0.0, 3.0, 0.0]}
	]},
	"statue2" : {"name": "Archway", "artist": 4, "data": [{"type":"cube","position":[-2.5,1,0]},{"type":"cube","position":[2.5,1,0]},{"type":"cube","position":[2.5,3,0]},{"type":"cube","position":[-2.5,3,0]},{"type":"cube","position":[-0.5,4,0]},{"type":"cube","position":[0.5,4,0]},{"type":"sphere","position":[0,4,0.5]}]},
	"statue3" : {"name": "Three-Way", "artist": 6, "data": [{"type":"cone","position":[-2,1,0]},{"type":"cone","position":[2,1,0]},{"type":"cone","position":[-1,3,0]},{"type":"cone","position":[1,3,0]},{"type":"cone","position":[0,5,0]},{"type":"cone","position":[0,1,0]}]},
	"statue4" : {"name": "Balance", "artist": 4, "data": [{"type":"sphere","position":[0,4,0]},{"type":"cube","position":[0,1,0]},{"type":"cone","position":[-1,1,0]},{"type":"cone","position":[1,1,0]},{"type":"cone","position":[0,2,0]},{"type":"cube","position":[0,1,-0.5]},{"type":"cube","position":[0,1,0.5]}]},
	"statue5" : {"name": "Sensational", "artist": 2, "data": [{"type":"cube","position":[-1.5,2,0]},{"type":"cube","position":[0,1,0]},{"type":"cube","position":[0,4,0]},{"type":"cube","position":[-0.5,5,0.5]},{"type":"cube","position":[0.5,3,-0.5]}]},
	"statue6" : {"name": "Dancer", "artist": 2, "data": [{"type":"cube","position":[0,1,0]},{"type":"cube","position":[0,3,0]},{"type":"cone","position":[-1,1,0]},{"type":"cone","position":[1,1,0]},{"type":"cone","position":[-1,3,0]},{"type":"cone","position":[1,3,0]},{"type":"sphere","position":[0,5,0]}]},
	"statue7" : {"name": "Automobile", "artist": 6, "data": [{"type":"sphere","position":[-1.5,1,2]},{"type":"sphere","position":[1.5,1,2]},{"type":"cube","position":[0,2,2]},{"type":"cube","position":[0,3,0]},{"type":"cube","position":[0,2,-2]},{"type":"sphere","position":[-1.5,1,-2]},{"type":"sphere","position":[1.5,1,-2]}]},
	"statue8" : {"name": "Dreamer", "artist": 4, "data": [{"type":"sphere","position":[-1,3,0]},{"type":"cone","position":[-0.5,2,0]},{"type":"cube","position":[0.5,1,0]},{"type":"cone","position":[1.5,3,0]},{"type":"sphere","position":[-0.5,5,0]},{"type":"sphere","position":[1,4,0]},{"type":"sphere","position":[2,1,0]}]}
#	"statue9" : {"name": "Oh Grow Up", "artist": 0, "data": [{"type":"sphere","position":[-1.5,1,0]},{"type":"sphere","position":[1.5,1,0]},{"type":"cube","position":[0,1,0]},{"type":"cube","position":[0,3,0]},{"type":"cone","position":[0,5,0]}]}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
