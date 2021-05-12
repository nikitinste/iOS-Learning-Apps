//
//  ViewController.swift
//  Sstoks
//
//  Created by Степан Никитин on 22.01.2021.
//


import UIKit

class ViewController: UIViewController {

    // UI
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var currentStateLabel: UILabel!
    @IBOutlet weak var companyLogoImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Private
    private let token = "pk_a24e298701c34206a8ff77c5c3a5f339"
    private let companiesListTypes = [
        "FAANG",
        "mostactive",
        "gainers",
        "losers"
    ]
    private let faang = [
        ["Apple": "AAPL"],
        ["Netflix": "NFLX"],
        ["Google": "GOOG"],
        ["Amazon": "AMZN"],
        ["Facebook": "FB"]
    ]
    private lazy var companies: [[String: String]] = []
    enum JsonParsingError: Error {
        case jsonIsEmpty
        case invalidJSON
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControlTabChanged(_ sender: Any) {
        companyPickerView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.companyPickerView.alpha = 0.0
        }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            updateCompanyPickerView(from: faang)
        default:
            requestStockCompanies(for: companiesListTypes[segmentedControl.selectedSegmentIndex])
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameLabel.text = "Tinkoff"
        currentStateLabel.isHidden = true
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        
        updateCompanyPickerView(from: faang)
    }
    
    // MARK: - Private
    
    private func requestStockCompanies(for listType: String) {
        currentStateLabel.isHidden = true
        activityIndicator.startAnimating()
        resetStockInfo()
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/\(listType)?token=\(token)")
        else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                DispatchQueue.main.async { [weak self] in
                    if let selectedTabIndex = self?.segmentedControl.selectedSegmentIndex {
                        if listType == self?.companiesListTypes[selectedTabIndex] {
                            self?.parseCompanies(from: data)
                        }
                    }
                }
            } else {
                print("List! Network error!")
                self?.showNetworkErrorAlert()
            }
        }
        
        dataTask.resume()
    }
    
    private func parseCompanies(from data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard
                let json = jsonObject as? [Any] else { return print("Invalid JSON") }
            
            if json.isEmpty {
                throw JsonParsingError.jsonIsEmpty
            }
            var list: [[String: String]] = []
            for dictionary in json {
                guard let company = dictionary as? [String: Any],
                      let companyName = company["companyName"] as? String,
                      let companySymbol = company["symbol"] as? String else {
                    return print("Invalid JSON")
                }
                let dictionary = [companyName: companySymbol]
                list.append(dictionary)
            }
            
            updateCompanyPickerView(from: list)
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
            currentStateLabel.text = "No data for list"
            resetStockInfo()
            activityIndicator.stopAnimating()
            currentStateLabel.isHidden = false
        }
    }
    
    private func updateCompanyPickerView(from list: [[String: String]]) {
        DispatchQueue.main.async { [weak self] in
            self?.currentStateLabel.isHidden = true
            self?.companies = list
            self?.companyPickerView.reloadAllComponents()
            self?.companyPickerView.selectRow(0, inComponent: 0, animated: false)
            self?.requestQuoteUpdate()
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.companyPickerView.alpha = 1.0
            }
            self?.companyPickerView.isUserInteractionEnabled = true
        }
    }
    
    private func requestQuoteUpdate() {
        activityIndicator.startAnimating()
        resetStockInfo()
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies[selectedRow].values)[0]
        requestQuote(for: selectedSymbol)
    }
    
    private func requestQuote(for symbol: String) {
        guard let dataURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)")
        else {
            return
        }
        guard let logoPathURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?&token=\(token)")
        else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: dataURL) { [weak self] (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self?.parseQuote(from: data)
            } else {
                print("Data! Network error!")
                self?.showNetworkErrorAlert()
            }
        }
        
        let imageURLTask = URLSession.shared.dataTask(with: logoPathURL) { [weak self] (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self?.parseLogoURL(from: data)
            } else {
                print("Image url! Network error!")
            }
        }
        
        dataTask.resume()
        imageURLTask.resume()
    }
    
    private func requestLogoImage(for url: String) {
        guard let dataURL = URL(string: url)
        else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: dataURL) { [weak self] (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self?.setSymbolLogoImage(from: data)
            } else {
                print("Image! Network error!")
            }
        }
        
        dataTask.resume()
    }
    
    private func parseLogoURL(from data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let logoURL = json["url"] as? String else { return print("Invalid JSON (Logo url)") }
            requestLogoImage(for: logoURL)
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func parseQuote(from data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double,
                let percentageChange = json["changePercent"] as? Double else { throw JsonParsingError.invalidJSON }
            
            DispatchQueue.main.async { [weak self] in
                self?.displayStockInfo(companyName: companyName,
                                       companySymbol: companySymbol,
                                       price: price,
                                       priceChange: priceChange,
                                       percentageChange: percentageChange)
            }
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
            showDataErrorAlert()
        }
    }
    
    private func resetStockInfo() {
        priceChangeLabel.textColor = UIColor.label
        percentageChangeLabel.textColor = UIColor.label
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        percentageChangeLabel.text = "-"
        companyLogoImage.image = nil
        companyLogoImage.isHidden = true
    }
    
    private func displayStockInfo(companyName: String,
                                  companySymbol: String,
                                  price: Double,
                                  priceChange: Double,
                                  percentageChange: Double) {
        activityIndicator.stopAnimating()
        companyNameLabel.text = companyName
        companySymbolLabel.text = companySymbol
        priceLabel.text = "\(price)"
        priceChangeLabel.text = "\(priceChange)"
        percentageChangeLabel.text = "\(percentageChange)%"
        if priceChange > 0 {
            priceChangeLabel.textColor = UIColor.green
            percentageChangeLabel.textColor = UIColor.green
        } else if priceChange < 0 {
            priceChangeLabel.textColor = UIColor.red
            percentageChangeLabel.textColor = UIColor.red
        }
        companyLogoImage.isHidden = false
    }
    
    private func setSymbolLogoImage(from data: Data) {
        let image = UIImage(data: data)
        DispatchQueue.main.async {  [weak self] in
                    self?.companyLogoImage.image = image
                }
    }
    
    private func showDataErrorAlert() {
        DispatchQueue.main.async {  [weak self] in
            self?.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Data Error!",
                                          message: "There is currently no data on the stock symbol.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                print("Retry...(data)")
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true)
        }
    }
    
    private func showNetworkErrorAlert() {
        DispatchQueue.main.async {  [weak self] in
            self?.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Network Error!",
                                          message: "Please check the connection.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                print("Retry...(connection)")
            }))
            
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.count
    }
}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(companies[row].keys)[0]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
    }
}

