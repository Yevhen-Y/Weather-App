//
//  ViewController.swift
//  Weather App
//
//  Created by Admin on 05.01.17.
//  Copyright © 2017 AppEvan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!

    @IBAction func submitButton(_ sender: Any) {
        
        self.view.endEditing(true)

        
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + textField.text!.replacingOccurrences(of: " ", with: "%20") + "&appid=de4ced2e2547330fcc10bc405dddc049") {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print(jsonResult)
                        
                        
                        if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String,
                            let pressure = (jsonResult["main"] as? NSDictionary)?["pressure"] as? Float,
                            let humidity = (jsonResult["main"] as? NSDictionary)?["humidity"] as? Float,
                            let temp = (jsonResult["main"] as? NSDictionary)?["temp"] as? Float,
                            let wind = (jsonResult["wind"] as? NSDictionary)?["speed"] as? Float
                            {
                            
                            DispatchQueue.main.sync(execute: {
                                print(temp)
                                self.resultLabel.text = description + "\nTemp: " +
                                    String( Int(temp - 273.0)) + "°C" + "\nPressure: " +
                                    String(pressure) + "\nHumidity: " + String(humidity) + "\nWind speed: " + String(wind)
                                
                                
                            })
                            
                        } else {
                            
                            DispatchQueue.main.sync(execute: {
                                
                                self.resultLabel.text = "Not found city"
                                
                            })
                            
                        }
                        
                        
                    } catch {
                        
                        print("JSON Processing Failed")
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
            
        } else {
            
            resultLabel.text = "Couldn't find that city - please try another"
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// some properties for keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
}

