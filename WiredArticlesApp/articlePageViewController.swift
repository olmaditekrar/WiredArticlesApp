//
//  articlePageViewController.swift
//  WiredArticlesApp
//
//  Created by Onur Can on 15.08.2017.
//  Copyright © 2017 Olmaditekrar. All rights reserved.
//

import UIKit

class articlePageViewController: UIViewController {

    @IBOutlet weak var topFiveLabel: UILabel!
    @IBOutlet weak var viewView: UIView!
     var article = articleModel()
    @IBOutlet weak var articleNameLabel: UILabel!

    @IBOutlet weak var articleContentLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let topFiveString = "\(article.topFiveIndex[0]) = \(article.articleTopFiveDictionary[article.topFiveIndex[0]]!)\n\(article.topFiveIndex[1]) = \(article.articleTopFiveDictionary[article.topFiveIndex[1]]!)\n\(article.topFiveIndex[2]) = \(article.articleTopFiveDictionary[article.topFiveIndex[2]]!)\n\(article.topFiveIndex[3]) = \(article.articleTopFiveDictionary[article.topFiveIndex[3]]!)\n\(article.topFiveIndex[4]) = \(article.articleTopFiveDictionary[article.topFiveIndex[4]]!)"
        
        
        
        
        
        topFiveLabel.text = topFiveString
        articleContentLabel.text = article.articleContent
        articleNameLabel.text = article.articleName
        articleImageView.image = article.articleImage

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
