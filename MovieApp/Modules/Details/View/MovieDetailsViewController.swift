//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 23/07/2025.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var movieLength: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var viewerAge: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBOutlet weak var generesCollectionView: UICollectionView!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var movieId: Int!
    var isMovieSaved : Bool = false
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private let viewModel = MovieDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.fetchMovieDetails(by: movieId)
        checkAndUpdateSavedStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setupUI() {
        // Register nibs
        castCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        setupCastCollectionView()
        
        generesCollectionView.register(UINib(nibName: "GenresCell", bundle: nil), forCellWithReuseIdentifier: "GenresCell")
        
        generesCollectionView.dataSource = self
        generesCollectionView.delegate = self
        setupGenresCollectionView()
        
        detailsView.layer.cornerRadius = 20
    }
    private func setupCastCollectionView(){
        let horizontalInset: CGFloat = 20
        let spacing: CGFloat = 16
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 120, height: 190)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        
        castCollectionView.collectionViewLayout = flowLayout
        castCollectionView.showsHorizontalScrollIndicator = false
    }
    private func setupGenresCollectionView() {
        let horizontalInset: CGFloat = 16
        let spacing: CGFloat = 8
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        // Fixed size for all genre pills
        let itemWidth: CGFloat = 85
        let itemHeight: CGFloat = 28
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(
            top: 0,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
        
        // Disable automatic sizing
        flowLayout.estimatedItemSize = .zero
        
        generesCollectionView.collectionViewLayout = flowLayout
        generesCollectionView.showsHorizontalScrollIndicator = false
        generesCollectionView.showsVerticalScrollIndicator = false
    }

    private func bindViewModel() {
        viewModel.$movieDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieDetails in
                guard let self = self, let movie = movieDetails else { return }
                
                
                
                self.movieName.text = movie.title
                self.movieRate.text = "⭐️ \(String(format: "%.1f", movie.voteAverage ?? 0))/10"

                self.movieLength.text = "\(movie.runtime ?? 0) min"
                self.movieLanguage.text = movie.originalLanguage?.uppercased()
                self.viewerAge.text = movie.adult == true ? "+18" : "PG"
                self.descriptionTextView.text = movie.overview
                
                if let url = URL(string: movie.fullPosterURL ?? "") {
                    self.movieImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
                }
                
                self.castCollectionView.reloadData()
                self.generesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    private func checkAndUpdateSavedStatus() {
        if let movieId = movieId {
            isMovieSaved = viewModel.isMovieSavedInCoreData(movieId: movieId)
            updateSaveButton()
        }
    }

    private func updateSaveButton() {
        if isMovieSaved {
            saveBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            saveBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        saveBtn.layer.cornerRadius = 8
        
    }

    @IBAction func saveBtn(_ sender: Any) {
        guard let movieId = movieId else { return }
        if isMovieSaved {
            viewModel.deleteMovieFromCoreData(by: movieId)
            isMovieSaved = false
        } else {
            viewModel.saveCurrentMovie()
            isMovieSaved = true
        }
        updateSaveButton()
    }
    
    
    @IBAction func playTrailer(_ sender: Any) {
        showAlert(title: "Trailer Not Found", message: "No trailer is available for this movie.")
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension MovieDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == generesCollectionView {
            return viewModel.movieDetails?.genres?.count ?? 0
        } else {
            return viewModel.movieDetails?.productionCompanies?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == generesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCell", for: indexPath) as? GenresCell,
                  let genre = viewModel.movieDetails?.genres?[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.movieGener.text = genre.name
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell,
                  let company = viewModel.movieDetails?.productionCompanies?[indexPath.item] else {
                return UICollectionViewCell()
            }
            cell.movieName.text = company.name
            cell.movieGener.text = ""
            if let logoPath = company.logoPath {
                let urlString = "https://image.tmdb.org/t/p/w200\(logoPath)"
                cell.movieImage.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "placeholder-image"))
            } else {
                cell.movieImage.image = UIImage(named: "placeholder-image")
            }
            return cell
        }
    }
}
