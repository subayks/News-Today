//
//  ArticlesListViewController.swift
//  News Today


import UIKit
import AlamofireImage
import Alamofire
import NVActivityIndicatorView


class ArticlesListViewController: UIViewController,NVActivityIndicatorViewable,UITextFieldDelegate {
    
    @IBOutlet weak var tableViewArticleList: UITableView!
    @IBOutlet weak var searchBarTextField: UITextField!
    
    var articlesListViewModel: ArticlesListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewArticleList.delegate = self
        self.tableViewArticleList.dataSource = self
        searchBarTextField.delegate = self
        searchBarTextField.placeholder = "Search news here"
        searchBarTextField.autocorrectionType = .no
        
        self.articlesListViewModel?.loadingClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let isLoading = self.articlesListViewModel?.isLoading ?? false
                if isLoading {
                    let size = CGSize(width: 50, height: 50)
                    self.startAnimating(size, message: "Loading", messageFont: .none, type: .ballScaleRippleMultiple, color: .white, fadeInAnimation: .none)
                    
                } else {
                    self.stopAnimating()
                    
                }
            }
        }
        
        self.articlesListViewModel?.showAlert = { [weak self] (errorMessage, errorCode)in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: errorCode , message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.articlesListViewModel?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.tableViewArticleList.reloadData()
                
            }
        }
    }
    
    @IBAction func actionLoadMore(_ sender: Any) {
        self.articlesListViewModel?.pageNo += 1
        self.articlesListViewModel?.makeApiCall()
    }
}

extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesListViewModel?.numberofRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.articlesListViewModel?.articlesModel?.articles?.count ?? 0 > .zero {
            let cell = tableViewArticleList.dequeueReusableCell(withIdentifier: "ArticleItemTableViewCell") as! ArticleItemTableViewCell
            let articleInfo = self.articlesListViewModel?.getArticleInfo(index: indexPath.row)
            cell.titleLabel.text = articleInfo?.title
            let htmlText = articleInfo?.content ?? ""
            let encodedData = htmlText.data(using: String.Encoding.utf8)!
            var attributedString: NSAttributedString?
            
            do {
                attributedString = try NSAttributedString(data: encodedData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            } catch {
                print("error")
            }
            cell.contentLabel.attributedText = attributedString
            cell.authorLabel.text = articleInfo?.author
            if let imageURl = articleInfo?.urlToImage {
                let url = URL(string: imageURl)!
                
                DispatchQueue.global().async {
                    // Fetch Image Data
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            // Create Image and Update Image View
                            cell.articleImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
            return cell
            
        }  else {
            let cell = tableViewArticleList.dequeueReusableCell(withIdentifier: "NoResultTableViewCell") as! NoResultTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "DisplayNewsView") as? DisplayNewsView else {
            return
        }
        vc.displayNewsViewModel = self.articlesListViewModel?.viewmodelForDisplayNewsViewModel(index: indexPath.row)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
}
extension ArticlesListViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        self.articlesListViewModel?.isSearchEnabled = true
        self.articlesListViewModel?.pageNo = 0
        if let text = self.searchBarTextField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,with: string)
            self.articlesListViewModel?.searchText = updatedText
            self.articlesListViewModel?.makeApiCall()
        }
        return true
    }
    
    private func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        self.articlesListViewModel?.isSearchEnabled = false
        
        return true
    }
}
