//
//  ViewController.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 30/03/21.
//

import UIKit

class IntradayViewController: UIViewController {
    
    var intradayManager = IntradayManager()
    var result: IntradayModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: "IntradayViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        intradayManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.definesPresentationContext = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Symbol Here, ex: Ibm, Usd"
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
}

// MARK: - UISEARCH

extension IntradayViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Pressed")
        
        intradayManager.fetchData(symbol: searchBar.text!)

    }
    
}

// MARK: - TABLEVIEW

extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let safeResult = result else { return 1}
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
        }
        
        
        return cell
    }
    
}

extension IntradayViewController: IntradayManagerDelegate {
    
    func didReceiveTableData(intraday: IntradayModel?) {
        if let action = intraday {
            DispatchQueue.main.async {
                self.result = action
                self.tableView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}


