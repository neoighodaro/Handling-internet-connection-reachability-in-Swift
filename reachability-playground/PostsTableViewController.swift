//
//  ListTableViewController.swift
//  reachability-playground
//
//  Created by Neo Ighodaro on 28/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import Alamofire

struct RedditPost {
    let title: String!
    let subreddit: String!
}

class PostsTableViewController: UITableViewController {
    
    var posts = [RedditPost]()
    let network = NetworkManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Latest Posts"
        
        fetchPosts { posts in
            self.posts = posts
            self.tableView.reloadData()
        }
        
        network.reachability.whenUnreachable = { reachability in
            self.showOfflinePage()
        }
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
    
    private func fetchPosts(completion: @escaping (_ posts: [RedditPost]) -> Void) -> Void {
        Alamofire.request("https://api.reddit.com").validate().responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let data = JSON as! [String:AnyObject]
                
                guard let children = data["data"]!["children"] as? [AnyObject] else { return }
            
                var posts = [RedditPost]()
                
                for child in 0...children.count-1 {
                    let post = children[child]["data"] as! [String: AnyObject]
                    
                    posts.append(RedditPost(
                        title: post["title"] as! String,
                        subreddit: "/r/" + (post["subreddit"] as! String)
                    ))
                }
                
                DispatchQueue.main.async {
                    completion(posts)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        let post = posts[indexPath.row] as RedditPost

        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.subreddit

        return cell
    }
}
