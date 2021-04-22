//
//  ViewController.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 30/03/21.
//

import UIKit

class IntradayViewController: UIViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    let userDefaults = UserDefaults.standard
    
    var intradayManager = IntradayManager()
    var result: IntradayModel?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "IntradayViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = 155
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        intradayManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.definesPresentationContext = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        if let stockLabel = userDefaults.string(forKey: "stockLabel") {
            searchController.searchBar.placeholder = "Your Latest Search: \(stockLabel)"
        } else {
            searchController.searchBar.placeholder = "Search by Symbol Here, ex: Ibm, Usd"
        }
        
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Low", "High"]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            // Search bar will visible all the time.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
}

// MARK: - UISEARCH

extension IntradayViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let symbolData = searchBar.text!
        if !symbolData.isEmpty {
            userDefaults.setValue(symbolData, forKey: "stockLabel")
        }
        
        
        intradayManager.fetchData(symbol: symbolData)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let stockLabel = userDefaults.string(forKey: "stockLabel") {
            searchController.searchBar.placeholder = "Your Latest Search: \(stockLabel)"
        } else {
            searchController.searchBar.placeholder = "Search by Symbol Here, ex: Ibm, Usd"
        }
    }
    
}

// MARK: - TABLEVIEW

extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let safeResult = result else { return 1 }
        return safeResult.date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! IntradayViewCell
        
        if let safeResult = result {
            cell.dateLabel.text = safeResult.date[indexPath.row]
            cell.closeLabel.text = safeResult.close[indexPath.row]
            cell.openLabel.text = safeResult.open[indexPath.row]
            cell.lowLabel.text = safeResult.low[indexPath.row]
            cell.highLabel.text = safeResult.high[indexPath.row]
            cell.stockLabel.text = userDefaults.string(forKey: "stockLabel")?.uppercased()
        } else {
            cell.isHidden = true
        }
        
    
        return cell
    }
    
}


// MARK: - INTRADAY MANAGER DELEGATE
extension IntradayViewController: IntradayManagerDelegate {
    
    func didReceiveTableData(intraday: IntradayModel?) {
        if let action = intraday {
            
            DispatchQueue.main.async {
                self.result = action
//                self.result!.date.sort(by: {$0 > $1})
                self.tableView.reloadData()
            }
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - ACTION PRESSED

extension IntradayViewController {
    
    @IBAction func segmentedControllPressed(_ sender: UISegmentedControl) {
        
        print("Pressed")
    }
    

    
    
    
}
