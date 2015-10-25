//
//  ViewController.swift
//  StoreSearch
//
//  Created by lgm on 15/10/24.
//  Copyright © 2015年 lgm. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar:UISearchBar!;
    
    @IBOutlet weak var tableView:UITableView!;
    
    var searchResults = [SearchResult]();
    
    var hasSearched:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0);
        searchBar.delegate = self;
        tableView.dataSource = self;
        tableView.delegate = self;
    }

}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        hasSearched = true;
        searchBar.resignFirstResponder();
        searchResults.removeAll();
        if searchBar.text != "justin bieber"{
            for i in 0...2 {
                searchResults.append(SearchResult(name: String(format: "Fake Result %d for", i), artistName: searchBar.text!));
            }
        }else{
            
        }
        tableView.reloadData();
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
}

extension SearchViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched{
            return 0;
        }else if searchResults.count == 0 {
            return 1;
        }else{
            return searchResults.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell";
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier);
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier);
        }
        if searchResults.count == 0{
            cell.textLabel!.text = "(Nothing found)";
            cell.detailTextLabel!.text = "";
        }else{
            cell.textLabel!.text = searchResults[indexPath.row].name;
            cell.detailTextLabel!.text = searchResults[indexPath.row].artistName;
        }
        return cell;
    }
    
}


extension SearchViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0{
            return nil;
        }else{
            return indexPath;
        }
    }
    
}































