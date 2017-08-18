import Foundation
import UIKit
class articleModel {
    
    var articleName : String
    var articleLink : URL
    var articleContent : String
    var articleImage : UIImage
    var articleTopFiveDictionary : [String:String]
    var topFiveIndex = [String]()
    
    init() {
        self.articleName = ""
        self.articleContent = ""
        self.articleImage = #imageLiteral(resourceName: "cantFound")
        self.articleLink = URL(string: "www.google.com")!
        self.articleTopFiveDictionary = [:]
    }
    
    
    
    
    
    
    
    
}
