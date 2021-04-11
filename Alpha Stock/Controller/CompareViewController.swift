//
//  CompareViewController.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 11/04/21.
//

import UIKit

class CompareViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var textFieldOne = UITextField()
    var textFieldTwo = UITextField()
    var textFieldThree = UITextField()
    
    var dailyManager = DailyManager()
    var resultOne: DailyModel?
    var resultTwo: DailyModel?
    var resultThree: DailyModel?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CompareViewCell", bundle: nil), forCellReuseIdentifier: "compareCellIdentifier")
        tableView.rowHeight = 110
        tableView.separatorStyle = .none
        
        dailyManager.delegate = self
    }
   
    
}



// MARK: - TABLEVIEW DELEGATE

extension CompareViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "compareCellIdentifier", for: indexPath) as! CompareViewCell
            
        if let safeResultOne = resultOne, let safeResultTwo = resultTwo, let safeResultThree = resultThree {
            switch indexPath.row {
                case 0:
                    if !textFieldOne.text!.isEmpty {
                        cell.stockLabel.text = textFieldOne.text?.uppercased()
                        cell.highValue.text = safeResultOne.high
                        cell.lowValue.text = safeResultOne.low
                        cell.dateValue.text = safeResultOne.date.last
                    } else {
                        cell.stockLabel.text = "Stock Label"
                        cell.highValue.text = "High Value"
                        cell.lowValue.text = "Low Value"
                        cell.dateValue.text = "Date Value"
                    }
                    
                case 1:
                    if !textFieldTwo.text!.isEmpty {
                        cell.stockLabel.text = textFieldTwo.text?.uppercased()
                        cell.highValue.text = safeResultTwo.high
                        cell.lowValue.text = safeResultTwo.low
                        cell.dateValue.text = safeResultTwo.date.last
                    } else {
                        cell.stockLabel.text = "Stock Label"
                        cell.highValue.text = "High Value"
                        cell.lowValue.text = "Low Value"
                        cell.dateValue.text = "Date Value"
                    }
                    
                case 2:
                    if !textFieldThree.text!.isEmpty {
                        cell.stockLabel.text = textFieldThree.text?.uppercased()
                        cell.highValue.text = safeResultThree.high
                        cell.lowValue.text = safeResultThree.low
                        cell.dateValue.text = safeResultThree.date.last
                    } else {
                        cell.stockLabel.text = "Stock Label"
                        cell.highValue.text = "High Value"
                        cell.lowValue.text = "Low Value"
                        cell.dateValue.text = "Date Value"
                    }
                    
                default:
                    break
                }
        }
        
    
        return cell
        
    }
    
}


// MARK: - Button Pressed

extension CompareViewController {
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Insert Symbol", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            print("Done Pressed")

            self.dailyManager.fetchData(symbol: self.textFieldOne.text!, params: 1)
            self.dailyManager.fetchData(symbol: self.textFieldTwo.text!, params: 2)
            self.dailyManager.fetchData(symbol: self.textFieldThree.text!, params: 3)
            // Added a function to get value from three symbol
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            self.textFieldOne = field
            self.textFieldOne.placeholder = "Enter First Symbol"
        }
        alert.addTextField { (field) in
            self.textFieldTwo = field
            self.textFieldTwo.placeholder = "Enter Second Symbol"
        }
        alert.addTextField { (field) in
            self.textFieldThree = field
            self.textFieldThree.placeholder = "Enter Third Symbol"
        }
        
       
        
        
        present(alert, animated: true, completion: nil)
    }
}

extension CompareViewController: DailyManagerDelegate {
    
    
    func didReceiveTableDataOne(daily: DailyModel?) {
        if let action = daily {
            DispatchQueue.main.async {
                self.resultOne = action
                self.tableView.reloadData()
            }
        }
    }
    
    func didReceiveTableDataTwo(daily: DailyModel?) {
        if let action = daily {
            DispatchQueue.main.async {
                self.resultTwo = action
                self.tableView.reloadData()
            }
        }
    }
    
    func didReceiveTableDataThree(daily: DailyModel?) {
        if let action = daily {
            DispatchQueue.main.async {
                self.resultThree = action
                self.tableView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}



