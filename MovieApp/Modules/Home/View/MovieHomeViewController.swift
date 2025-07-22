//
//  MovieHomeViewController.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import UIKit
import Combine
import Kingfisher


class MovieHomeViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var topSearchTableView: UITableView!

    private let viewModel = MovieHomeViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.fetchHomeData()
    }

    private func setupUI() {
        // Register nibs
        recommendedCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        topSearchTableView.register(UINib(nibName: "TopSearchCell", bundle: nil), forCellReuseIdentifier: "TopSearchCell")

        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        topSearchTableView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 120, height: 184)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            
            recommendedCollectionView.collectionViewLayout = flowLayout
            recommendedCollectionView.showsHorizontalScrollIndicator = false

     

    }

    private func bindViewModel() {
        viewModel.$recommendedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                print("Recommended movies updated: \(movies.count)")
                    self?.recommendedCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$topSearchItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.topSearchTableView.reloadData()
                self?.topSearchTableView.layoutIfNeeded()
            }
            .store(in: &cancellables)
    }
}

extension MovieHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("viewModel.recommendedMovies.count\(viewModel.recommendedMovies.count)")
        return viewModel.recommendedMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.recommendedMovies[indexPath.item]
        print("movieeeeeeeeee\(movie)")
        cell.movieName.text = movie.title
        cell.movieGener.text = "Drama"
        if let urlString = movie.fullPosterURL, let url = URL(string: urlString) {
            cell.movieImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
        } else {
            cell.movieImage.image = UIImage(named: "placeholder-image")
        }
    
        return cell
    }
    
}

extension MovieHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topSearchItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopSearchCell", for: indexPath) as? TopSearchCell else {
            return UITableViewCell()
        }

        let item = viewModel.topSearchItems[indexPath.row]
        cell.movieName.text = item.displayTitle
        cell.movieGener.text = "Drama"

       

        if let urlString = item.fullImageURL, let url = URL(string: urlString) {
            cell.movieImage.kf.setImage(with: url)
        }

        return cell
    }
    
    
    
}
