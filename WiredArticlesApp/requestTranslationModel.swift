//
//  requestTranslationModel.swift
//  WiredArticlesApp
//
//  Created by ONUR on 17.08.2017.
//  Copyright © 2017 Olmaditekrar. All rights reserved.
//

import UIKit

class requestTranslationModel {

    var requestStartingString = "https://translate.yandex.net/api/v1.5/tr.json/translate?"
    var apiKeyString = "key=trnsl.1.1.20170817T134437Z.8a7ed4d3908aaad5.8334af4cddebdfc9f91b737f6977aff82b71bd0f"
    var textToTranslateString = "&text="
    var translationDirection = "&lang=en-tr"
    
    func translate(translateText : String ,currentArticle : articleModel) -> String {
        var result : String = ""
        
        self.textToTranslateString = "&text=\(translateText)"
        var urlToYandex = "\(requestStartingString)\(apiKeyString)\(textToTranslateString)\(translationDirection)"
        let session = URLSession.shared
        let Url = URL(string: urlToYandex)
        let request = URLRequest(url: Url!)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
         
            do {
                if translateText == " " || data == nil{
                    
                    return
                }
                print("Translate Text : \(translateText)")
                if let data = try? data{
                  if  let json = try JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    do{
                        let text = json ["text"] as! Array<String>
                        result = text[0] as String
                        currentArticle.articleTopFiveDictionary[translateText] = result

                    }catch {
                        print("Some error in text")
                    }
                    
                    
                    }
                }
            }catch{
                print("Data is not recieved !")
            }
            
        })
        task.resume()
        return result
    }
}
