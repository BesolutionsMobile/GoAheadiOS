//
//  RegisterViewController.swift
//  GoAhead
//
//  Created by Mustafa on 11/21/19.
//  Copyright © 2019 Maged. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

@available(iOS 13.0, *)
class RegisterViewController: UIViewController  ,NVActivityIndicatorViewable {
    var register:Register?
    let basedUrl = "http://www.goaheadho.com/goahead_en/User/register/82984218/951735"
    let  parms : [String : String] = ["image" : "0" ]
    @IBOutlet weak var userNameRegTf: DesignableUITextField!
    @IBOutlet weak var emailRegTf: DesignableUITextField!
    @IBOutlet weak var phoneRegTf: DesignableUITextField!
    @IBOutlet weak var passwordRegTf: DesignableUITextField!
    @IBOutlet weak var singUpBtn: UIButton!{
        didSet{
            singUpBtn.layer.cornerRadius = 20
            singUpBtn.layer.borderWidth = 2
            singUpBtn.layer.borderColor = UIColor.white.cgColor
            singUpBtn.clipsToBounds = true
        }
    }
    @IBOutlet weak var animationView: UIView!{
        didSet{
            animationView.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func getRegister(url : String , parameters : [String : String] )  {
        self.startAnimating()
        AF.request(url, method:.post, parameters: parameters).responseJSON {
            response  in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    self.stopAnimating()
                    if let JSON = value as? [String: Any] {
                        print(JSON)
                        let status = JSON["status"] as! Int
                        let msg = JSON["message"] as! String
                        if status == 1 {
                            self.register?.status = JSON["status"] as! Int
                            self.register?.message = JSON ["message"] as! String
                            self.register?.userID = JSON ["user_id"] as! Int
                            self.register?.name =  JSON ["name"] as! String
                            self.clearText()
                            self.animationView.isHidden = false
                            let view = StartAnimationView.showLottie(view: self.animationView, fileName: "success", contentMode: .scaleAspectFit)
                            view.play { (finished) in
                                if finished {
                                    if let vc = self.storyboard?.instantiateViewController(identifier: "TabBar") as? NewTab {
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                        }else if status == 2 {
                            self.register?.status = JSON["status"] as! Int
                            self.register?.message = JSON ["message"] as! String
                            self.animationView.isHidden = false
                            let view = StartAnimationView.showLottie(view: self.animationView, fileName: "fail", contentMode: .scaleAspectFit)
                            view.animationSpeed = 2
                            view.play { (finished) in
                                if finished {
                                    self.animationView.isHidden = true
                                    Alert.show("Error", massege: msg, context: self)
                                }
                            }
                        }
                        print(status)
                    }
                }
            case .failure(let error):
                self.stopAnimating()
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Func to Empty TextFaild
    func clearText()  {
        userNameRegTf.text = ""
        emailRegTf.text = ""
        phoneRegTf.text = ""
        passwordRegTf.text = ""
    }
    
    
    
    
    func completeUrl() -> String {
        if let name = userNameRegTf.text , let email = emailRegTf.text ,let phone = phoneRegTf.text ,let pass = passwordRegTf.text{
            let finalUrl = "\(basedUrl)/\(name)/\(email)/\(phone)/\(pass)"
            print(finalUrl)
            return finalUrl
        }
          return "Erorr In Url"
    }
        
       
    @IBAction func tackImageBtnPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
      getRegister(url: completeUrl(), parameters: parms)

    }
    @IBAction func goToLoginBtnPressed(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
    }
}
