//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Anil Mukundan on 9/13/15.
//  Copyright (c) 2015 Mukundan. All rights reserved.
//

import UIKit
import AFNetworking
//import JTProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies : [NSDictionary]?
    
    var refreshControl: UIRefreshControl!
    
    //var progressHUD: JTProgressHUD = JTProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let json : NSDictionary = fetchResponseFromRottenTomatoes() as NSDictionary
        println(json)
        self.movies = json["movies"] as? [NSDictionary]
        self.tableView.reloadData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        // The following statement is giving a "[NSDictionary]? does not have a member named subscript error"
        // Just getting the first element to continue past this.
        //let movie = self.movies[indexPath?.row]
        let movie = self.movies?.first
        let movieDetailsViewController = segue.destinationViewController as MovieDetailViewController
        movieDetailsViewController.movie = movie
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies![indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var thumbnailUrl = movie.valueForKeyPath("posters.thumbnail") as String
        println(thumbnailUrl)
        let url = NSURL(fileURLWithPath: thumbnailUrl)
        cell.posterView.setImageWithURL(url)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onRefresh() {
        println("Refreshing View")
        let json : NSDictionary = fetchResponseFromRottenTomatoes() as NSDictionary
        self.movies = json["movies"] as? [NSDictionary]
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func fetchResponseFromRottenTomatoes () -> AnyObject {
        let path = NSBundle.mainBundle().pathForResource("rottentomatoes", ofType: "json")
        var jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        return NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)!
    }
}
