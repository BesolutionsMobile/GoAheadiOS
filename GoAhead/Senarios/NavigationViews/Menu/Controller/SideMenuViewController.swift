//
//  TotalMenuViewController.swift
//  GoAhead
//
//  Created by Mustafa on 11/21/19.
//  Copyright © 2019 Maged. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
@available(iOS 13.0, *)
class SideMenuViewController: UIViewController ,NVActivityIndicatorViewable{
    var cat:Categories?

    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet{
            Rounded.roundedImage(imageView: profileImage)            
        }
    }
    @IBOutlet weak var langFlag: UIImageView!
    @IBOutlet weak var myNameLbl: UILabel!
    @IBOutlet weak var changLang: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         getAllCategories()
    }
    
    func getAllCategories(){
        self.startAnimating()
        APIClient.getAllCategories() { (Result) in
            switch Result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.stopAnimating()
                    self.cat = response
                    self.menuTableView.reloadData()
                    print(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.stopAnimating()
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func changeLangPressed(_ sender: UIButton) {
        
    }
    
}

@available(iOS 13.0, *)
extension SideMenuViewController : UITableViewDataSource , UITableViewDelegate {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  cat?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "menuBtnTableViewCell", for: indexPath) as! menuBtnTableViewCell
        cell.categoryLbl.text = cat?.categories[indexPath.row].name
        cell.menuIcon.sd_setImage(with: URL(string: cat?.categories[indexPath.item].icon ?? ""), placeholderImage: UIImage(named: "logo GoAhead"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        let vc = storyboard?.instantiateViewController(identifier: "CatagogryViewController") as! CatagogryViewController
        vc.catId = cat?.categories[indexPath.item].id
        vc.index = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
 

 
    }
    
    
    
}
