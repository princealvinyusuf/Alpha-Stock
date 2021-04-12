//
//  CustomViewController.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 12/04/21.
//

import UIKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "customCellIdentifier")
        tableView.rowHeight = 115
        tableView.separatorStyle = .none
        
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.definesPresentationContext = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Symbol Here, ex: Ibm, Usd"
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
            return apiKey[row]
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
            apiKeyPicker.text = apiKey[row]
            return userDefaults.setValue(apiKey[row], forKey: "apiChooser")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellIdentifier", for: indexPath) as! CustomViewCell
        return cell
    }
    
    
    
}


// MARK: - SEARCHBAR DELEGATE

extension CustomViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("User Default API \(userDefaults.string(forKey: "apiChooser"))")
        print("User Default Interval \(userDefaults.string(forKey: "intervalChooser"))")
        print("User Default Outputsize \(userDefaults.string(forKey: "outputsizeChooser"))")
       
        // Call the funtion to fetch data
        
        
        
        
    }
    
}
