//
//  SourceViewController.swift
//  News Today


import UIKit
import NVActivityIndicatorView

class SourceViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var sourceTableView: UITableView!
    var sourceViewModel: SourceViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func makeApiCall() {
        if let sourceViewModel = self.sourceViewModel {
            let finalURL = sourceViewModel.getFinalUrl()
            
            if Reachability.isConnectedToNetwork() {
                let size = CGSize(width: 50, height: 50)
                self.startAnimating(size, message: "Loading", messageFont: .none, type: .ballScaleRippleMultiple, color: .white, fadeInAnimation: .none)
                sourceViewModel.getArticleResponse(withBaseURl: finalURL, withParameters: "", completionHandler: { (status: Bool?, errorMessage: String?, errorCode: String?)  -> Void in
                    DispatchQueue.main.async {
                        if status == true {
                            self.stopAnimating()
                            
                            guard let vc = self.storyboard?.instantiateViewController(identifier: "ArticlesListViewController") as? ArticlesListViewController else {
                                return
                            }
                            vc.articlesListViewModel = self.sourceViewModel?.viewModelForArtilceList()
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else {
                            let alert = UIAlertController(title: errorCode , message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    }
}

extension SourceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sourceViewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sourceTableView.dequeueReusableCell(withIdentifier: "SourceListTableViewCell") as! SourceListTableViewCell
        cell.textLabel?.text = sourceViewModel?.getSourceList(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sourceViewModel?.updateSourceValue(index: indexPath.row)
        makeApiCall()
    }
    
    
}
