//
//  ViewController.swift
//  Make School Code Challenge
//
//  Created by Eliot Han on 3/17/17.
//  Copyright © 2017 Eliot Han. All rights reserved.
//

//ListVC displays the top 25 movies on iTunes using a UITableView

import UIKit

class ListVC: UIViewController {
    var tableView: UITableView!
    var movies: [Movie] = []
    var imageCache: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupTableView()
        getMovies()
    }
    
    //Sets up the Navigation
    func setupNav() {
        self.navigationItem.title = "Top 25 Movies"
        
        //Setup the back button in the next screen as just <
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

    }
    
    //Gets the data from the url
    func getMovies() {
        let url: URL = URL(string: "https://itunes.apple.com/us/rss/topmovies/limit=25/json")!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
    
        //Configure datatask
        dataTask = defaultSession.dataTask(with: url, completionHandler: {data, response, error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            }else if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{  //if success
                    self.createMovieObjects(data: data!)
                }
            }
        })
        dataTask?.resume()  //start the process
        
    }
    
    // Creates movie objects from the data
    func createMovieObjects(data: Data){
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary{
                let movieArray: NSArray = (jsonResult["feed"] as! NSDictionary)["entry"] as! NSArray
                for i in 0..<25 {
                    //Reference to movie dictionary
                    let ref = movieArray[i] as! NSDictionary
                    
                    //Movie properties
                    let title = (ref["im:name"] as! NSDictionary)["label"] as! String
                    let releaseDate = (ref["im:releaseDate"] as! NSDictionary)["label"] as! String
                    let price = (ref["im:price"] as! NSDictionary)["label"] as! String
                    let imgArray = ref["im:image"] as! NSArray
                    let bigImgUrlString = (imgArray[2] as! NSDictionary)["label"] as! String
                    let contentLinkArray = ref["link"] as! NSArray
                    let contentLinkString = ((contentLinkArray[0] as! NSDictionary)["attributes"] as! NSDictionary)["href"] as! String
                    
                    //Before creating the movie, let's format the date
                    let dateFormatted = releaseDate.substring(to: releaseDate.characters.index(of: "T")!)
                    
                    //Create and store movie, then update the tableview
                    let movie = Movie(title: title, releaseDate: dateFormatted, price: price, bigImgUrlString: bigImgUrlString, contentLinkString: contentLinkString)
                    movies.append(movie)
                    DispatchQueue.main.sync {
                        self.tableView.insertRows(at: [IndexPath(row: self.movies.count - 1, section: 0)], with: UITableViewRowAnimation.bottom)
                    }
                }
            }
        } catch let error as NSError {
            print("Error turning search result into JSON:", error.localizedDescription)
        }
    }
    
}

//MARK: TableView
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    //Initializes TableView
    func setupTableView(){
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        view.addSubview(tableView)
    }
    
    //Specifies the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //Creates and returns a cell for a row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        //For reused cells
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let movie = movies[indexPath.row]
        cell.updateWithModel(movie: movie)
        
        //If the image is already downloaded, retrieve from imageCache
        if let downloadedImage = imageCache[String(indexPath.row)]{
            DispatchQueue.main.async {
                cell.updateArt(art: downloadedImage as! UIImage)
            }
            
        } else {
            //Download the image
            UtilityFunctions.getDataFromUrl(url: URL(string: movie.bigImgUrlString)!, completion: {  (data, response, error) in
                guard let data = data, error == nil else{
                    print("Error downloading album art", error?.localizedDescription as Any)
                    return
                }
                
                //Once data is returned, update cell's art and store it to cache
                DispatchQueue.main.async {
                    let art = UIImage(data: data)!
                    self.imageCache[String(indexPath.row)] = art
                    cell.updateArt(art: art)
                }
            })
        }
        
        return cell
    }
    
    //Actions to take upon a row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //The chosen movie and it's image
        let chosenMovie = movies[indexPath.row]
        let movieImage = imageCache[String(indexPath.row)] as! UIImage
        
        //We will programmatically move to the next screen
        let movieVC = MovieVC()
        movieVC.setup(movie: chosenMovie, image: movieImage)
        self.navigationController?.pushViewController(movieVC, animated: true)
        
        //Also, let's deselect that row
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

