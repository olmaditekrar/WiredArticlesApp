import UIKit
import SwiftSoup
import ROGoogleTranslate
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articlesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseArticleCell") as! cellModel
                cell.articleName.text = articlesArray[indexPath.row].articleName
        
                cell.articleImage.image = articlesArray[indexPath.row].articleImage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = articlesArray[indexPath.row]
        
        
        performSegue(withIdentifier: "segueArticlePage", sender:  selectedArticle)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueArticlePage" {
            
            let destination = segue.destination as! articlePageViewController
            
            destination.article = sender as! articleModel
            
        }
    }
    
    
    
    var articlesArray = [articleModel]() //It will return URL and Name of the last 5 articles in the website as an array !


    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlesArray = getArticlesArray()
        
                if articlesArray.isEmpty {
            
            print("articlesArrayMain is empty,there is nothing to show !")
        }else {
               
        }
     
        


    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    func getArticlesArray () -> Array<articleModel>{
        
        let myURLString = "https://wired.com"
        
        
        
        if (UIApplication.shared.canOpenURL(URL(string: myURLString)!) == false ) {
            
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return []
            
            
            
        }else {
            
            
            
            do {
                let myHTMLString = try String(contentsOf: URL(string : myURLString)!, encoding: .ascii)
                do {
                    //Getting the Body of the HTML .
                    let doc = try SwiftSoup.parseBodyFragment(myHTMLString)
                   // print(doc)
                    do {
                        //Trying to parse a little more .
                        let articleElementDiv  = try doc.select("div")
                        let articleElementDiv1 = try articleElementDiv.select("div")
                        let articleElementDiv2 = try articleElementDiv1.select("div")
                        let articleElementDiv3 = try articleElementDiv2.select("div").array()
                        let articleElementDiv4 = try articleElementDiv3[1].select("div").array()
                        
                        var articleElementDiv5 = articleElementDiv3[2]
                        var articleElementDiv6 : Array<Element>
                        var articleElementDiv7 : Array<Element>
                        
                        
                        
//                        do {
//                        for i in 141...451 {
                        
               //                 print(articleElementDiv4[i])
              //                  print(try articleElementDiv4[i].text())
                                articleElementDiv5 =  articleElementDiv4[145]
                                
                        //}
                        
//                        }catch{
//                            
//                        }
                        
                        //Get the Article Names and Links as an Array.
                         articleElementDiv6 = try articleElementDiv5.select("h5").array() //Article Names !
                         articleElementDiv7 = try articleElementDiv5.select("a").array() // Article Links !
                        
                        
                        
                        do {
                            var articles: [articleModel] = [articleModel]()
                            
                            for i in 0...4{ // It will loop for 5 times to get last 5 articles in the site.
                                //Temporary article objet to append later and take the current values .
                                let tempArticle = articleModel()
                                //Assignments
                                tempArticle.articleLink = try URL(string :"\(myURLString)\(articleElementDiv7[i].attr("href"))")!
                                tempArticle.articleName = try articleElementDiv6[i].text()
                                
                                getComponentsOfArticle(currentArticle: tempArticle)
                                
                                
                                
                                
                                
                                
                                //ARTICLE IS ALL SET !
                                
                                
                                
                                //Append the temporary object into the array.
                                articles.append(tempArticle)
                            }
                            return articles
                        }catch{
                        }
                        
                    }catch {
                    }
                    
                }catch{
                    
                }
                
            }catch let error {
                print("Error: \(error)")
            }
            
            return []
        }
    }
    
    func getComponentsOfArticle( currentArticle : articleModel) {
        
        
        if (UIApplication.shared.canOpenURL(currentArticle.articleLink) == false ) {
            
            print("Error: \(currentArticle.articleLink) doesn't seem to be a valid URL")
            return
            
            
        }else {
            
            
            do {
                
                let myHTMLString = try String(contentsOf: currentArticle.articleLink, encoding: .ascii)
                
               
                    
                    getTextOfArticle(into: currentArticle, from: myHTMLString)
                    getImageOfArticle(into: currentArticle, from: myHTMLString)
                    
                    
                    
                    
                                
            }catch let error{
                
                print("Error: \(error)")
                
            }
            
        }
        
    }
    
    func getTextOfArticle(into currentArticle : articleModel , from HTMLString : String)  {
        
        
        do{
            let doc = try SwiftSoup.parseBodyFragment(HTMLString)
            let div = try doc.select("div")
           let div1 = try div.select("div")
            let div2 = try div1.select("article")
            let div3 = try div2.select("p")
            
            
            let content = try div3.text() // â harfini ayarlamayi unutma !!!!!!
            
            
            currentArticle.articleContent = content

            
            getTopFiveWordsAndMeanings(from: currentArticle)
            
            
        }catch let error{
            print("Error : \(error)")
            
        }
        
        
    }
    func getTopFiveWordsAndMeanings (from currentArticle : articleModel){
        
        let translator = requestTranslationModel()

        
        var wordList =  currentArticle.articleContent.components(separatedBy: .punctuationCharacters).joined().lowercased().components(separatedBy: " ").filter{!$0.isEmpty} //Divide the string into its own words as an array.
        // Words List is here ! We will translate in this loop.
        var counts: [String: Int] = [:]
        
        for item in wordList {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        let myArr = Array(counts.keys)
        var sortedKeys = myArr.sorted() {
            let obj1 = counts[$0] // get ob associated w/ key 1
            let obj2 = counts[$1] // get ob associated w/ key 2
            return obj1! > obj2!
        }
        for i in 0...4{
            
            let stringToTranslate = sortedKeys[i]
            currentArticle.topFiveIndex.append(sortedKeys[i])
            translator.translate(translateText: stringToTranslate, currentArticle: currentArticle)
            
        }
        
        
    }
    func getImageOfArticle(into currentArticle: articleModel , from HTMLString : String ){
        
        
        
        var srcs = Elements()
        
        
        do {
            
            let doc = try SwiftSoup.parseBodyFragment(HTMLString)
            srcs = try doc.select("img[src]")
            print(srcs)
            
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        
        let srcsStringArray: [String?] = srcs.array().map { try? $0.attr("src").description } // All the Image Source Strings in the website!
        let session = URLSession.shared
        let imageURL = URL(string: srcsStringArray[0]!)
        let request = URLRequest(url: imageURL!)
        
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            print(data)
            if let imageData = try? Data(contentsOf: imageURL!) {
                
                
               currentArticle.articleImage = UIImage(data : imageData)!
                self.tableViewMain.reloadData()
                
            } else {
                print("Image does not exist at \(String(describing: imageURL))")
                
            }
        })
        performUIUpdatesOnMain {
            task.resume()
        }
        
    }
    

}
