
import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var movies : [Search]?
    var filteredMovies : [Search]?
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let loadingView = UIView()
    
    var segmentType: SegmentType? {
        didSet {
            switch segmentType {
            case .all:
                filteredMovies = movies
                tableView.reloadData()
            case .movies:
                guard let movies = movies else {
                    return
                }

                filteredMovies = movies.filter {
                    $0.type == "movie"
                }
                
                tableView.reloadData()
                
            case .series:
                guard let movies = movies else {
                    return
                }

                filteredMovies = movies.filter {
                    $0.type == "series"
                }
                
                tableView.reloadData()
                
            default:
                break
            }
        }
    }
    //let searchController = UISearchController()
    //let getTrailer = ["4YvNVqf2at0","K9WNBO3szgQ","H0IgfAs3tWg","si5C-3F9Pw4","imbA6Nkb8e8","5IPyv4KgTAA","yNLaTtpovys",""]
    
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDetailsVC")
        title = "Movie Paradise"
        
        
        //To-Do : Kullanıcıya mesaj göster.
        userLabel.text = "Search For Any Movies"
        userLabel.textColor = .white
        
        searchBar()
        
    }
    
    func searchBar(){
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        
        searchBar.scopeButtonTitles = [
            SegmentType.all.title,
            SegmentType.movies.title,
            SegmentType.series.title
        ]
        
        //To-Do Movies Series ayrı ayrı TableView'da reload edilecek.
        self.tableView.tableHeaderView = searchBar
                                    
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        segmentType = SegmentType.init(rawValue: selectedScope)
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            userLabel.isHidden = false
        }
        else{
            
        }
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let takeResponse = getError?.response
        loadingLabel.isHidden = false
        guard let searchText = searchBar.text else{
            return
        }
        //Burayı sor.
        if searchText == ""{
            userLabel.text = "You searched nothing. Please try again!"
            userLabel.textColor = .red
        }
        /*
        else if takeResponse == "False"{
            userLabel.text = "No Movies Found."
        }
         */
        else{
            getData(keyword: searchText.replacingOccurrences(of: " ", with: ""))
            userLabel.isHidden = true
            setLoadingScreen()
        }
    }
    
    func getData(keyword: String){
        //To-Do --> Show Activity Indicator
        let urlString = "https://www.omdbapi.com/?s=\(keyword)&page=3&apikey=9893101c"
        guard let url = URL(string: urlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error{
                self.showError(message: error.localizedDescription)
                return
            }
            
            guard let data = data else{
                self.showError(message: "Error")
                return
            }
            
            guard let decode = try? JSONDecoder().decode(Movie.self, from: data) else {
                self.showError(message: "Error")
                return
            }
            
            if let error = decode.error {
                self.showError(message: error)
                return
            }
            
            self.movies = decode.search
            self.filteredMovies = decode.search
            
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
                removeLoadingScreen()
                //To-Do --> Hide Activity Indicator - Label Gizlenecek.
            }
            
        }.resume()
        
    }
    
    func showError(message : String?){
        DispatchQueue.main.async {
            let error = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            error.addAction(okButton)
            self.present(error, animated: true, completion: nil)
            
            //To-Do Hide Activity Indicator
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies?[indexPath.row]
        performSegue(withIdentifier: "detailsMovies", sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Geri Dön"
        backItem.tintColor = .white
        backItem.style = .done
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "detailsMovies"{
            guard let movie = sender as? Search else{
                return
            }
            
            let destination = segue.destination as! toDetailsVC
            
            destination.selectedTitleLabel = movie.title
            destination.selectedYearLabel = movie.year
            destination.selectedTypeLabel = movie.type
            destination.selectedImdbLabel = movie.imdbID
            destination.selectedImage = movie.poster
            
            // TODO -> Action
            destination.selectedResults = "730"
            destination.selectedResponse = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDetailsVC",for: indexPath)
        cell.textLabel?.text = filteredMovies?[indexPath.row].title
        return cell
    }
    
    func setLoading(){
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = (CGRect(x: 0, y: 0, width: 140, height: 30))
        
        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        spinner.color = .white
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
    }
    
      func setLoadingScreen() {

            
            let width: CGFloat = 120
            let height: CGFloat = 30
            let x = (tableView.frame.width / 2) - (width / 2)
            let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
            loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

            
            loadingLabel.textColor = .black
            loadingLabel.textAlignment = .center
            loadingLabel.text = "Loading..."
            loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

            spinner.style = .medium
            spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            spinner.startAnimating()
            spinner.color = .black

            loadingView.addSubview(spinner)
            loadingView.addSubview(loadingLabel)

            tableView.addSubview(loadingView)

        }

          func removeLoadingScreen() {

            spinner.stopAnimating()
            spinner.isHidden = true
            loadingLabel.isHidden = true

        }
    

    }


/*
extension String{
    public func toImage() -> UIImage?{
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
 */


