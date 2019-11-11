//
//  ViewController.swift
//  Swifty-Companion
//
//  Created by Zolile SIGABI on 2019/10/23.
//  Copyright © 2019 Zolile SIGABI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation


class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var jsonData: JSON?
    var search = Search()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        search.makeToken()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func editText(_ sender: UITextField) {
        if sender.text != ""
        {
            searchButton.isEnabled = true
        }
        else
        {
            searchButton.isEnabled = false
        }
        
    }
    
    @IBAction func search(_ sender: UIButton) {
        if let login = textField.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil) {
            search.checkUser(login) {
                completion in
                if completion != nil {
                    self.jsonData = completion
                    self.performSegue(withIdentifier: "Profile", sender: nil)
                    self.searchButton.isEnabled = true
                } else {
                    let alert = UIAlertController(title: "Error", message: "This login doesn't exists", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.searchButton.isEnabled = true
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile" {
            let new = segue.destination as! secondViewController
            new.data = jsonData
        }
    }
}
    
  




