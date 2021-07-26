//
//  ViewController.swift
//  News Today


import UIKit
import DropDown
import NVActivityIndicatorView
import SDWebImage
import AlamofireImage
import Alamofire

class ViewController: UIViewController, UIAlertViewDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var countryName: UIButton!
    
    @IBOutlet weak var categoryType: UIButton!
    
    @IBOutlet weak var sourceType: UIButton!
    
    @IBOutlet weak var buttonGo: UIButton!
    
    var countryDropDown = DropDown()
    var categoryDropDown = DropDown()
    var dashboardViewModel = DashboardViewModel()
    var categoryArray = ["Select Category","Business", "Entertainment", "General", "Health", "Science","Technology"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dashboardViewModel.setUpCountryDetails()
        
        self.dashboardViewModel.loadingClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let isLoading = self.dashboardViewModel.isLoading
                if isLoading {
                    let size = CGSize(width: 50, height: 50)
                    self.startAnimating(size, message: "Loading", messageFont: .none, type: .ballScaleRippleMultiple, color: .white, fadeInAnimation: .none)
                    
                } else {
                    self.stopAnimating()
                    
                }
            }
        }
        
        self.dashboardViewModel.showAlert = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: self.dashboardViewModel.articlesModel?.code ?? "", message: self.dashboardViewModel.articlesModel?.message ?? "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        self.dashboardViewModel.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                if self.dashboardViewModel.sourceClicked {
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "SourceViewController") as? SourceViewController else {
                        return
                    }
                    vc.sourceViewModel = self.dashboardViewModel.viewModelForSourceViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    guard let vc = self.storyboard?.instantiateViewController(identifier: "ArticlesListViewController") as? ArticlesListViewController else {
                        return
                    }
                    vc.articlesListViewModel = self.dashboardViewModel.viewModelForArtilceList()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set up country name
        countryDropDown.dataSource = self.dashboardViewModel.countryNameArray
        self.dashboardViewModel.updateCountryName(countryName: self.dashboardViewModel.countryNameArray[0])
        self.countryName.setTitle(self.dashboardViewModel.countryNameArray[0], for: .normal)
        //Set up category button values
        categoryDropDown.dataSource = categoryArray
        self.dashboardViewModel.updateCategory(category: categoryArray[0])
        self.categoryType.setTitle(categoryArray[0], for: .normal)
        //Set border radius curve
        self.countryName.layer.borderWidth = 1
        self.categoryType.layer.borderWidth = 1
        self.sourceType.layer.borderWidth = 1
        self.countryName.layer.cornerRadius = 25
        self.categoryType.layer.cornerRadius = 25
        self.sourceType.layer.cornerRadius = 25
        self.countryName.layer.borderColor = UIColor.gray.cgColor
        self.categoryType.layer.borderColor = UIColor.gray.cgColor
        self.sourceType.layer.borderColor = UIColor.gray.cgColor
        
        
    }
    
    @IBAction func actionCountryName(_ sender: UIButton) {
        
        countryDropDown.anchorView = sender
        countryDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        countryDropDown.show()
        countryDropDown.backgroundColor = .white
        
        countryDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.dashboardViewModel.updateCountryName(countryName: item)
        }
    }
    
    @IBAction func actionCategory(_ sender: UIButton) {
        
        categoryDropDown.anchorView = sender
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        categoryDropDown.show()
        categoryDropDown.backgroundColor = .white
        
        categoryDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.dashboardViewModel.updateCategory(category: item)
            
        }
    }
    
    @IBAction func actionSource(_ sender: Any) {
        self.dashboardViewModel.sourceClicked = true
        self.dashboardViewModel.makeSourceApiCall()
    }
    
    
    @IBAction func actionGo(_ sender: Any) {
        self.dashboardViewModel.makeApiCall()
    }
    
    
}

