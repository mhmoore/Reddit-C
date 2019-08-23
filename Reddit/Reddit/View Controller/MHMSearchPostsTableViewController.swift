//
//  MHMSearchPostsTableViewController.swift
//  Reddit
//
//  Created by Michael Moore on 8/20/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import UIKit

class MHMSearchPostsTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var posts: [MHMPost] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()
        let searchTerm = searchText.replacingOccurrences(of: " ", with: "+")
        
        MHMPostController.shared().searchForPost(withSearchTerm: searchTerm) { (posts, error) in
            // fill the posts that come back from the json add set them to our local array so it can populate the TVC
            self.posts = posts
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.title = searchText
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? MHMPostTableViewCell else { return UITableViewCell() }
        
        let post = posts[indexPath.row]
        cell.post = post
        
        MHMPostController.shared().fetchImagePost(post) { (fetchedImage) in
            DispatchQueue.main.async {
                cell.thumbnail = fetchedImage
            }
        }

        return cell
    }
}
