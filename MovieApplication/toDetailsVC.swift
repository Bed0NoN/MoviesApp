//
//  toDetailsVC.swift
//  MovieApplication
//
//  Created by Bedirhan Altun on 26.07.2022.
//

import UIKit
import Kingfisher
class toDetailsVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedTypeLabel = ""
    var selectedImdbLabel = ""
    var selectedYearLabel = ""
    var selectedTitleLabel = ""
    var selectedPoster = ""
    var selectedResults = ""
    var selectedResponse = ""
    var selectedImage = ""
    
    
    //var getMovies = [Search]()
    
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        setSpinner()
        
        removeSpinner()
        
        typeLabel.text = "Type : \(selectedTypeLabel)".capitalized
        imdbLabel.text = "Imdb ID : \(selectedImdbLabel)"
        yearLabel.text = "Year : \(selectedYearLabel)"
        titleLabel.text = "Movie Name : \(selectedTitleLabel)"
        resultsLabel.text = "Total Results : \(selectedResults)"
        responseLabel.text = "Response : \(selectedResponse)"
        
        titleLabel.textColor = .white
        imdbLabel.textColor = .white
        yearLabel.textColor = .white
        typeLabel.textColor = .white
        resultsLabel.textColor = .white
        responseLabel.textColor = .white
        
        imageView.kf.setImage(with: URL(string: selectedImage))
        
        
        //navigationController?.navigationItem.titleView?.backgroundColor = .white
        
        
    }
    
    func setSpinner(){
        activityIndicator.startAnimating()
        activityIndicator.style = .medium
        activityIndicator.color = .white
        loading.textColor = .white
        loading.text = "Loading"
    }
    

    func removeSpinner(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.loading.isHidden = true
        }
    }

    
    @IBAction func clearButton(_ sender: Any) {
        
        typeLabel.text = ""
        imdbLabel.text = ""
        yearLabel.text = ""
        titleLabel.text = ""
        resultsLabel.text = ""
        responseLabel.text = ""
        
        view.backgroundColor = .darkText
        
        imageView.image = UIImage(named: "clickme")
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToFirstViewController))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func goToFirstViewController(){
        self.navigationController?.popViewController(animated: true)
    }
     

}
     
