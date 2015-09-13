//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Anil Mukundan on 9/13/15.
//  Copyright (c) 2015 Mukundan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let json : NSDictionary = fetchResponseFromRottenTomatoes() as NSDictionary
        println(json)
        self.movies = json["movies"] as? [NSDictionary]
        self.tableView.reloadData()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        
        //let imageurl = NSURL(string: movie.valueForKeyPath("posters.thumbnail"))
        // cell.posterView.setImageWithURL(imageurl)
        return cell
    }
    
    func fetchResponseFromRottenTomatoes () -> AnyObject {
        let path = NSBundle.mainBundle().pathForResource("rottentomatoes", ofType: "json")
        var jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        return NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)!
    }
}
