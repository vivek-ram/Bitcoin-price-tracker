
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      finalURL = baseURL + currencyArray[row]
      currencySelected = currencySymbols[row]
        
      getBitcoinData(url: finalURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let BitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: BitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
        if let BitcoinResult = json["ask"].double {
            bitcoinPriceLabel.text = currencySelected + String(BitcoinResult)
        }else {
            bitcoinPriceLabel.text = "price unavailable"
        }
        
       
    }
    




}

