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
    
    var isLoading:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0);
        searchBar.delegate = self;
        tableView.dataSource = self;
        tableView.delegate = self;
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil);
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell);
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil);
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell);
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil);
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell);
        searchBar.becomeFirstResponder();
    }
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell";
        static let nothingFoundCell = "NothingFoundCell";
        static let loadingCell = "LoadingCell";
    }
    
    func urlWithSearchText(searchText:String) -> NSURL{
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet());
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText!);
        let url = NSURL(string: urlString);
        return url!;
    }
    
    func performStoreRequestWithURL(url: NSURL) -> String!{
        do{
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding);
        }catch{
            print("Download Error: \(error)", separator: "", terminator: "\n");
            return nil;
        }
    }
    
    func parseJSON(jsonString: String) -> [String: AnyObject]!{
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) else{
            return nil;
        }
        do{
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject];
        }catch{
            print("JSON Error \(error)", separator: "", terminator: "\n");
            return nil;
        }
    }
    
    func showNetworkError(){
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again", preferredStyle: UIAlertControllerStyle.Alert);
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
        alert.addAction(action);
        presentViewController(alert, animated: true, completion: nil);
    }
    
    func parseDictionary(dictionary : [String: AnyObject]) -> [SearchResult]{
        guard let array  = dictionary["results"] as? [AnyObject] else {
            print("Expected results array", separator: "", terminator: "\n");
            return [];
        }
        var searchResults = [SearchResult]();
        for resultDict in array{
            var searchResult:SearchResult!;
            if let wrapperType = resultDict["wrapperType"] as? String{
                switch wrapperType{
                case "track":
                    searchResult = parseTrack( resultDict as! [String : AnyObject] );
                case "audiobook":
                    searchResult = parseAudioBook(resultDict as! [String : AnyObject]);
                case "sotfware":
                    searchResult = parseSoftware(resultDict as! [String : AnyObject]);
                default:
                    break;
                }
            }else if let kind = resultDict["kind"] as? String {
                searchResult = parseEBook(resultDict as! [String : AnyObject]);
            }
            if let result = searchResult {
                searchResults.append(result);
            }
        }
        return searchResults;
    }
    
    func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult();
        searchResult.name = dictionary["trackName"] as! String;
        searchResult.artistName = dictionary["artistName"] as! String;
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String;
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String;
        searchResult.storeURL = dictionary["trackViewUrl"] as! String;
        searchResult.kind = dictionary["kind"] as! String;
        searchResult.currency = dictionary["currency"] as! String;
        if let price = dictionary["trackPrice"] as? Double{
            searchResult.price = price;
        }
        if let genre = dictionary["primaryGenreName"] as? String{
            searchResult.genre = genre;
        }
        return searchResult;
    }
    
    func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult();
        searchResult.name = dictionary["collectionName"] as! String;
        searchResult.artistName = dictionary["artistName"] as! String;
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String;
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String;
        searchResult.storeURL = dictionary["collectionViewUrl"] as! String;
        searchResult.kind = "audiobook"
        searchResult.currency = dictionary["currency"] as! String;
        if let price = dictionary["collectionPrice"] as? Double{
            searchResult.price = price;
        }
        if let genre = dictionary["primaryGenreName"] as? String{
            searchResult.genre = genre;
        }
        return searchResult;
    }
    
    func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult();
        searchResult.name = dictionary["trackName"] as! String;
        searchResult.artistName = dictionary["artistName"] as! String;
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String;
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String;
        searchResult.storeURL = dictionary["trackViewUrl"] as! String;
        searchResult.kind = dictionary["kind"] as! String;
        searchResult.currency = dictionary["currency"] as! String;
        if let price = dictionary["price"] as? Double{
            searchResult.price = price;
        }
        if let genre = dictionary["primaryGenreName"] as? String{
            searchResult.genre = genre;
        }
        return searchResult;
    }
    
    func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult();
        searchResult.name = dictionary["trackName"] as! String;
        searchResult.artistName = dictionary["artistName"] as! String;
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String;
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String;
        searchResult.storeURL = dictionary["trackViewUrl"] as! String;
        searchResult.kind = dictionary["kind"] as! String;
        searchResult.currency = dictionary["currency"] as! String;
        if let price = dictionary["trackPrice"] as? Double{
            searchResult.price = price;
        }
        if let genres = dictionary["genres"]{
            searchResult.genre = (genres as! [String]).joinWithSeparator(", ");
        }
        return searchResult;
    }
    
    func kindForDisplay(kind: String) -> String{
        switch kind{
        case "album":
            return "Album";
        case "audiobook":
            return "Audio Book";
        case "book":
            return "Book";
        case "ebook":
            return "E-Book";
        case "feature-movie":
            return "Movie";
        case "music-video":
            return "Music Video";
        case "podcast":
            return "Podcast";
        case "software":
            return "Software";
        case "song":
            return "Song";
        case "tv-episode":
            return "TV Episode";
        default:
            return kind;
        }
    }

}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder();
            hasSearched = true;
            isLoading = true;
            searchResults.removeAll();
            tableView.reloadData();
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0);
            dispatch_async(queue, { () -> Void in
                let url = self.urlWithSearchText(searchBar.text!);
                if let jsonString = self.performStoreRequestWithURL(url){
                    let dictionary = self.parseJSON(jsonString);
                    self.searchResults = self.parseDictionary(dictionary);
                    self.searchResults.sortInPlace({ $0 < $1 });
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.isLoading = false;
                        self.tableView.reloadData();
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showNetworkError();
                });
            });
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
}

extension SearchViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 1;
        }else if !hasSearched{
            return 0;
        }else if searchResults.count == 0 {
            return 1;
        }else{
            return searchResults.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading{
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath);
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView;
            spinner.startAnimating();
            return cell;
        }else if searchResults.count == 0{
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath);
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell;
            if searchResults.count == 0 {
                cell.nameLable.text = "(Nothing found)";
                cell.artistNameLabel.text = "";
            }else{
                cell.nameLable.text = searchResults[indexPath.row].name;
                if searchResults[indexPath.row].artistName.isEmpty{
                    cell.artistNameLabel.text = "Unknown";
                }else{
                    cell.artistNameLabel.text = String(format: "%@ (%@)", searchResults[indexPath.row].artistName, kindForDisplay(searchResults[indexPath.row].kind));
                }
            }
            return cell;
        }
    }
    
}


extension SearchViewController:UITableViewDelegate{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 || isLoading{
            return nil;
        }else{
            return indexPath;
        }
    }
    
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool{
    return lhs.name.localizedStandardCompare(rhs.name) == NSComparisonResult.OrderedAscending;
}






























