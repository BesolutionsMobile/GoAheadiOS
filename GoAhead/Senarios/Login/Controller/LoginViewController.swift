//
//  ViewController.swift
//  GoAhead
//
//  Created by Mostafa on 11/20/19.
//  Copyright © 2019 Maged. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

@available(iOS 13.0, *)
class LoginViewController: UIViewController ,NVActivityIndicatorViewable{
    var login:Login?
    var failure:Failure?
    @IBOutlet weak var userNameTf: UITextField!{
        didSet{
            userNameTf.delegate = self
            userNameTf.isSecureTextEntry = false
        }
        
    }
    @IBOutlet weak var passwordTf: UITextField!{
        didSet{
            passwordTf.delegate = self
        }
        
    }
    @IBOutlet weak var signInBtn: UIButton!{
        didSet{
            signInBtn.layer.cornerRadius = 20
            signInBtn.layer.borderWidth = 2
            signInBtn.layer.borderColor = UIColor.white.cgColor
            signInBtn.clipsToBounds = true
        }
        
    }
    @IBOutlet weak var dontHaveAccount: UIButton!
    @IBOutlet weak var forgetPassBtn: UIButton!
    @IBOutlet weak var animationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDesign()
    }
    
    
    //MARK: - Func Login
    func getLogin(){
        self.startAnimating()
        if let mail = userNameTf.text , let pass = passwordTf.text {
            APIClient.login(mail: mail, password: pass) { (Result) in
                switch Result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        self.login = response
                        print(response)
                        self.setData()
                        self.clearText()
                        self.animationView.isHidden = false
                        let view = StartAnimationView.showLottie(view: self.animationView, fileName: "success", contentMode: .scaleAspectFit)
                        view.play { (finished) in
                            if finished {
                                if let vc = self.storyboard?.instantiateViewController(identifier: "TabBar"){
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        print(error.localizedDescription)
                        APIClient.loginfailure(mail: mail, password: pass) { (Result) in
                            switch Result {
                            case .success(let response):
                                DispatchQueue.main.async {
                                    self.failure = response
                                    self.stopAnimating()
                                    self.animationView.isHidden = false
                                    let view = StartAnimationView.showLottie(view: self.animationView, fileName: "fail", contentMode: .scaleAspectFit)
                                    view.animationSpeed = 2
                                    view.play { (finished) in
                                        if finished {
                                            view.isHidden = true
                                             self.animationView.isHidden = true
                                            Alert.show(NSLocalizedString("Error", comment: ""), massege: self.failure!.message, context: self)
                                        }
                                    }
                                    
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    self.stopAnimating()
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func updateDesign() {
        dontHaveAccount.setTitle(NSLocalizedString("Don't Have  Account", comment: ""), for: .normal)
        forgetPassBtn.isHidden = true
        animationView.isHidden = true
    }
    
    
    func setData() {
        UserDefault.setId((self.login?.userData.id)!)
        UserDefault.setName((self.login?.userData.name)!)
        UserDefault.setEmail((self.login?.userData.mail)!)
        UserDefault.setPhone((self.login?.userData.phone)!)
    }
    //MARK: - Func to Empty TextFaild
    func clearText()  {
        userNameTf.text = ""
        passwordTf.text = ""
    }
    
    
    
    
    
    @IBAction func forgetPasswordBtnPressed(_ sender: UIButton) {
        //        if let vc = storyboard?.instantiateViewController(identifier: "ForgetPasswordViewController") as? ForgetPasswordViewController {
        //            vc.modalPresentationStyle = .fullScreen
        //            present(vc, animated: true, completion: nil)
        //        }
        
    }
    
    @IBAction func signInbtnPressed(_ sender: UIButton) {
        getLogin()
        
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController {
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    
}
