//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Nitie on 9/7/18.
//  Copyright © 2018 Nitie. All rights reserved.
//

import UIKit
import AlamofireImage



class NowPlayingViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    // set new properties in the view controller with a wider scope that can be seen anywhere in the view controller
    var movies: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    //how the table view will react to the holder of the sort after data.
        tableView.dataSource = self // self is the now playingviewcontroller
        
        
        // In point for the URL we want to hit
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //method to actually do the work to go get the movies,completion handler to work with the returned data
        let task = session.dataTask(with: request) { (data, response, error) in
            //Completion block:This will run when the network request returns
            if let error = error  {
                print(error.localizedDescription)
            }  else if let data = data {
                let dataDictionary =  try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                //diffrenciate movies local variable.
                self.movies = movies
                self.tableView.reloadData()
                
            }
        }
        task.resume()// call the task to resume
    }
//how many cells auto complete after specifying uiviewdatasource.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    //what the cell will be
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell // go find an identifier made of type movie cell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        //setup outlets for these in a custom cell class not a reusable class like Moviecell
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        //add photo path url
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
