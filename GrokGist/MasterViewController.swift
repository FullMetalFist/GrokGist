//
//  MasterViewController.swift
//  GrokGist
//
//  Created by Michael Vilabrera on 2/14/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

import UIKit
import PINRemoteImage

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var gists = [Gist]()
    var imageCache = [String: UIImage?]()
    var nextPageURLString: String?
    var isLoading = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadGists(urlToLoad: nil)
    }
    
    
    func loadGists(urlToLoad: String?) {
        self.isLoading = true
        GitHubAPIManager.sharedInstance.fetchPublicGists(pageToLoad: urlToLoad) { (result, nextPage) in
            self.isLoading = false
            self.nextPageURLString = nextPage
            guard result.error == nil else {
                self.handleLoadGistsError(result.error!)
                return
            }
            
            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }
            
            self.tableView.reloadData()
        }
        GitHubAPIManager.sharedInstance.fetchPublicGists(pageToLoad: urlToLoad) { (result, nextPage) in
            guard result.error == nil else {
                self.handleLoadGistsError(result.error!)
                return
            }
            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }
            self.tableView.reloadData()
        }
    }
    
    func handleLoadGistsError(_ error: Error) {
        // TODO: show error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let alert = UIAlertController(title: "Not working", message: "Can't create new gists yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let gist = gists[indexPath.row]
                if let controller = (segue.destination as? UINavigationController)? .topViewController as? DetailViewController {
                    controller.detailItem = gist
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let gist = gists[indexPath.row]
        cell.textLabel?.text = gist.description
        cell.detailTextLabel?.text = gist.ownerLogin
        
        if let urlString = gist.ownerAvatarURL, let url = URL(string: urlString) {
            cell.imageView?.pin_setImage(from: url, placeholderImage: UIImage(named: "placeholder")) {
                result in
                if let cellToUpdate = self.tableView?.cellForRow(at: indexPath) {
                    cellToUpdate.setNeedsLayout()
                }
            }
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        
        if !isLoading {
            let rowsLoaded = gists.count
            let rowsRemaining = rowsLoaded - indexPath.row
            let rowsToLoadFromBottom = 5
            
            if rowsRemaining <= rowsToLoadFromBottom {
                if let nextPage = nextPageURLString {
                    self.loadGists(urlToLoad: nextPage)
                }
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            gists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}

