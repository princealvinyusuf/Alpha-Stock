//
//  CustomViewController.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 12/04/21.
//

import UIKit
import Security

class CustomViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let pickerView = UIPickerView()
    
    // UI COMPONENT
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var apiKeyPicker: UITextField!
    @IBOutlet weak var intervalPicker: UITextField!
    @IBOutlet weak var outputsizePicker: UITextField!
    
    // VARIABLE
    let apiKey = [
        "", "U9UEIDBB9SG2DHLV", "B26W8O4HTXWMIWLW", "GNMNBT7IFTJUVDZK",
    ]
    let interval = [
        "", "1min", "5min", "15min", "30min", "60min",
    ]
    let outputsize = [
        "", "compact", "full",
    ]
    
    let userDefaults = UserDefaults.standard
    
    
    // Object
    var customManager = CustomManager()
    var result: CustomModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "customCellIdentifier")
        tableView.rowHeight = 155
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        
        pickerView.delegate = self
        apiKeyPicker.inputView = pickerView
        intervalPicker.inputView = pickerView
        outputsizePicker.inputView = pickerView
        dismissPickerView()
        
        
        if let saveApi = userDefaults.string(forKey: "apiChooser") {
            apiKeyPicker.placeholder = saveApi
        }
        if let saveInterval = userDefaults.string(forKey: "intervalChooser") {
            intervalPicker.placeholder = saveInterval
        }
        if let saveOutputsize = userDefaults.string(forKey: "outputsizeChooser") {
            outputsizePicker.placeholder = saveOutputsize
        }
        
        customManager.delegate = self
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
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        toolBar.setItems([flexButton, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        apiKeyPicker.inputAccessoryView = toolBar
        intervalPicker.inputAccessoryView = toolBar
        outputsizePicker.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    
    
    
}



// MARK: PICKER DELEGATE

extension CustomViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if apiKeyPicker.isFirstResponder {
            return apiKey.count
        }
        if intervalPicker.isFirstResponder {
            return interval.count
        }
        if outputsizePicker.isFirstResponder {
            return outputsize.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if apiKeyPicker.isFirstResponder {
            switch apiKey[row] {
            case "U9UEIDBB9SG2DHLV":
                return "API Key 1 [Encrypted]"
            case "B26W8O4HTXWMIWLW":
                return "API Key 2 [Encrypted]"
            case "GNMNBT7IFTJUVDZK":
                return "API Key 3 [Encrypted]"
            default:
                return ""
            }
        }
        if intervalPicker.isFirstResponder {
            return interval[row]
        }
        if outputsizePicker.isFirstResponder {
            return outputsize[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if apiKeyPicker.isFirstResponder {

            if row != 0 {
                
                switch apiKey[row] {
                case "U9UEIDBB9SG2DHLV":
                    apiKeyPicker.text = "API Key 1 [Encrypted]"
                case "B26W8O4HTXWMIWLW":
                    apiKeyPicker.text = "API Key 2 [Encrypted]"
                case "GNMNBT7IFTJUVDZK":
                    apiKeyPicker.text = "API Key 3 [Encrypted]"
                default:
                    return
                }
                
                let dataString = Data(from: apiKey[row])
                let dataStatus = KeyChain.save(key: "apiChooser", data: dataString)
                print("Data Status: \(dataStatus)")
            } else {
                apiKeyPicker.text = "Use Default Value"
                let dataString = Data(from: "U9UEIDBB9SG2DHLV")
                let dataStatus = KeyChain.save(key: "apiChooser", data: dataString)
                print("Data Status: \(dataStatus)")
            }
            
        }
        if intervalPicker.isFirstResponder {
            intervalPicker.text = interval[row]
            return userDefaults.setValue(interval[row], forKey: "intervalChooser")
        }
        if outputsizePicker.isFirstResponder {
            outputsizePicker.text = outputsize[row]
            return userDefaults.setValue(outputsize[row], forKey: "outputsizeChooser")
        }
        
    }
    
    
}




// MARK: - TABLE VIEW DELEGATE & DATA SOURCE

extension CustomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let safeResult = result else { return 1 }
        return safeResult.date.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellIdentifier", for: indexPath) as! CustomViewCell
        
        if let safeResult = result {
            cell.stockLabel.text = userDefaults.string(forKey: "stockLabel")?.uppercased()
            cell.dateValue.text = safeResult.date[indexPath.row]
            cell.openValue.text = safeResult.open[indexPath.row]
            cell.closeValue.text = safeResult.close[indexPath.row]
            cell.lowValue.text = safeResult.low[indexPath.row]
            cell.highValue.text = safeResult.high[indexPath.row]
        } else {
            cell.isHidden = true
        }
        
        return cell
    }
    
    
    
}


// MARK: - SEARCHBAR DELEGATE

extension CustomViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
//        let apiData = userDefaults.string(forKey: "apiChooser") ?? "U9UEIDBB9SG2DHLV"
 
        guard let receiveData = KeyChain.load(key: "apiChooser") else { fatalError() }
        let resultAPI = receiveData.to(type: String.self)
        
        let intervalData = userDefaults.string(forKey: "intervalChooser") ?? "5min"
        let outputsizeData = userDefaults.string(forKey: "outputsizeChooser") ?? "compact"
        let symbolData = searchBar.text!
        
        
        if !symbolData.isEmpty {
            userDefaults.setValue(symbolData, forKey: "stockLabel")
        }
        
        if apiKeyPicker.text != "" {
            print("API: \(resultAPI)")
            print("Interval: \(intervalData)")
            print("Output: \(outputsizeData)")
            print("Symbol: \(symbolData)")
            
            // Call the funtion to fetch data
            customManager.fetchData(symbol: symbolData, apiKey: resultAPI, interval: intervalData, outputsize: outputsizeData)
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
            if intervalPicker.text == "" && outputsizePicker.text == "" {
                alert.message = "You don't configure the Interval & Outputsize field, Default System Setting was used"
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            customManager.fetchData(symbol: symbolData, apiKey: "U9UEIDBB9SG2DHLV", interval: intervalData, outputsize: outputsizeData)
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Oke", style: .default, handler: nil)
            
            if searchBar.text != "" {
                if apiKeyPicker.text == "" && intervalPicker.text == "" && outputsizePicker.text == "" {
                    alert.message = "You don't configure the request field, Default System Setting was used"
                }
                else if apiKeyPicker.text == "" && intervalPicker.text == "" {
                    alert.message = "You don't configure the API & Interval field, Default System Setting was used"
                }
                else if apiKeyPicker.text == "" && outputsizePicker.text == "" {
                    alert.message = "You don't configure the API & Outputsize field, Default System Setting was used"
                }
                else if intervalPicker.text == "" {
                    alert.message = "You don't configure the Interval field, Default System Setting was used"
                } else {
                    alert.message = "You don't configure the Outputsize field, Default System Setting was used"
                }
            } else {
                alert.message = "You don't configure the Outputsize field, Default System Setting was used"
            }
            
            
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let stockLabel = userDefaults.string(forKey: "stockLabel") {
            searchController.searchBar.placeholder = "Your Latest Search: \(stockLabel)"
        } else {
            searchController.searchBar.placeholder = "Search by Symbol Here, ex: Ibm, Usd"
        }
    }
    
}



// MARK: - CUSTOM MANAGER DELEGATE

extension CustomViewController: CustomManagerDelegate {
    
    func didReceiveTableData(custom: CustomModel?) {
        if let action = custom {
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
