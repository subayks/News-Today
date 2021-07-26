//
//  SourceViewController.swift
//  News Today


import UIKit
import NVActivityIndicatorView
import DropDown

class SourceViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var categoryType: UIButton!
    @IBOutlet weak var sourceTableView: UITableView!
    var sourceViewModel: SourceViewModel?
    var countryDropDown = DropDown()
    var categoryDropDown = DropDown()
    var languageDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.sourceViewModel?.loadingClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let isLoading = self.sourceViewModel?.isLoading ?? false
                if isLoading {
                    let size = CGSize(width: 50, height: 50)
                    self.startAnimating(size, message: "Loading", messageFont: .none, type: .ballScaleRippleMultiple, color: .white, fadeInAnimation: .none)
                    
                } else {
                    self.stopAnimating()
                    
                }
            }
        }
        
        self.sourceViewModel?.showAlert = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: self.sourceViewModel?.articlesModel?.code ?? "", message: self.sourceViewModel?.articlesModel?.message ?? "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        self.sourceViewModel?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                guard let vc = self.storyboard?.instantiateViewController(identifier: "ArticlesListViewController") as? ArticlesListViewController else {
                    return
                }
                vc.articlesListViewModel = self.sourceViewModel?.viewModelForArtilceList()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        self.sourceViewModel?.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.sourceTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set up country name
        self.sourceViewModel?.setUpCountryList()
               self.sourceViewModel?.setUplanguageArray()
               self.sourceViewModel?.setUpCategoryArray()
        countryDropDown.dataSource = self.sourceViewModel?.countryListArray ?? [String]()
        self.countryCode.setTitle(self.sourceViewModel?.countryListArray[0] ?? "", for: .normal)
        //Set up category button values
        categoryDropDown.dataSource = self.sourceViewModel?.categoryArray ?? [String]()
        self.categoryType.setTitle(self.sourceViewModel?.categoryArray[0] ?? "", for: .normal)
        //Language Button
        languageDropDown.dataSource = self.sourceViewModel?.languageArray ?? [String]()
        self.languageButton.setTitle(self.sourceViewModel?.languageArray[0] ?? "", for: .normal)
        //Set border radius curve
        self.countryCode.layer.borderWidth = 1
        self.categoryType.layer.borderWidth = 1
        self.languageButton.layer.borderWidth = 1
        self.countryCode.layer.cornerRadius = 10
        self.categoryType.layer.cornerRadius = 10
        self.languageButton.layer.cornerRadius = 10
        self.countryCode.layer.borderColor = UIColor.gray.cgColor
        self.categoryType.layer.borderColor = UIColor.gray.cgColor
        self.languageButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func languageSelected(_ sender: UIButton) {
        languageDropDown.anchorView = sender
        languageDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        languageDropDown.show()
        languageDropDown.backgroundColor = .white
        
        languageDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.sourceViewModel?.updateSelectedLanguage(language: item)
            
        }
    }
    @IBAction func categorySelected(_ sender: UIButton) {
        categoryDropDown.anchorView = sender
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        categoryDropDown.show()
        categoryDropDown.backgroundColor = .white
        
        categoryDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.sourceViewModel?.updateSelectedCategory(category: item)
            
        }
        
    }
    
    @IBAction func countrySelected(_ sender: UIButton) {
        countryDropDown.anchorView = sender
        countryDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        countryDropDown.show()
        countryDropDown.backgroundColor = .white
        
        countryDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self?.sourceViewModel?.updateSelectedCountry(country: item)
            
        }
    }
}

extension SourceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceViewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sourceTableView.dequeueReusableCell(withIdentifier: "SourceListTableViewCell") as! SourceListTableViewCell
        cell.textLabel?.textColor = .white
        if self.sourceViewModel?.articlesModel?.sources?.count == 0 {
            cell.textLabel?.text = "No result found"
        } else {
        cell.textLabel?.text = sourceViewModel?.getSourceList(index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sourceViewModel?.updateSourceValue(index: indexPath.row)
        self.sourceViewModel?.channelSelected = true
        self.sourceViewModel?.makeApiCall()
    }
    
    
}
