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
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topSearchTableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!


    private let viewModel = MovieHomeViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        viewModel.fetchHomeData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setupUI() {
       
        recommendedCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        popularCollectionView.register(UINib(nibName: "SuggetionMovieCell", bundle: nil), forCellWithReuseIdentifier: "SuggetionMovieCell")
        topSearchTableView.register(UINib(nibName: "TopSearchCell", bundle: nil), forCellReuseIdentifier: "TopSearchCell")

        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        topSearchTableView.dataSource = self
        topSearchTableView.delegate = self
        
        
        
        setupPopularCollectionView()
        setupRecomendedCollectionView()
        setupTopSearchTableView()
    }

    private func setupRecomendedCollectionView(){
        let horizontalInset: CGFloat = 20
        let spacing: CGFloat = 16

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 120, height: 190)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        
        recommendedCollectionView.collectionViewLayout = flowLayout
        recommendedCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupPopularCollectionView() {
        let horizontalInset: CGFloat = 20
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        
        let availableWidth = view.bounds.width - (horizontalInset * 2) - spacing
        let itemWidth = availableWidth * 0.90
        layout.itemSize = CGSize(width: itemWidth, height: 160)
        
        popularCollectionView.collectionViewLayout = layout
        popularCollectionView.decelerationRate = .fast
        popularCollectionView.showsHorizontalScrollIndicator = false
        popularCollectionView.isPagingEnabled = false
    }
    
    private func setupTopSearchTableView() {
        topSearchTableView.separatorStyle = .none
        topSearchTableView.showsVerticalScrollIndicator = false
        topSearchTableView.rowHeight = 80
        topSearchTableView.tableFooterView = UIView()
        
        topSearchTableView.allowsSelection = true
        topSearchTableView.bounces = true
        topSearchTableView.alwaysBounceVertical = false
        
        topSearchTableView.showsHorizontalScrollIndicator = false
        topSearchTableView.alwaysBounceHorizontal = false
        
        topSearchTableView.separatorInset = .zero
        topSearchTableView.layoutMargins = .zero
        topSearchTableView.cellLayoutMarginsFollowReadableWidth = false

    }
    
    private func bindViewModel() {
        viewModel.$recommendedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                    self?.recommendedCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$popularMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.popularCollectionView.reloadData()
                self?.pageControl.numberOfPages = movies.count
                DispatchQueue.main.async {
                    if movies.count > 1 {
                        let indexPath = IndexPath(item: 1, section: 0)
                        self?.popularCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    }
                }
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
    
    @IBAction func favoriteBtn(_ sender: Any) {
        let favoriteVC = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
            navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
}


extension MovieHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recommendedCollectionView {
            return viewModel.recommendedMovies.count
        } else if collectionView == popularCollectionView {
            return viewModel.popularMovies.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendedCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
                return UICollectionViewCell()
            }
            let movie = viewModel.recommendedMovies[indexPath.item]
            cell.movieName.text = movie.title
            cell.movieGener.text = "Drama"
            cell.movieImage.kf.setImage(with: URL(string: movie.fullPosterURL ?? ""), placeholder: UIImage(named: "placeholder-image"))
            return cell
        } else if collectionView == popularCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggetionMovieCell", for: indexPath) as? SuggetionMovieCell else {
                return UICollectionViewCell()
            }
            let movie = viewModel.popularMovies[indexPath.item]
            cell.movieTitle.text = movie.title
            cell.movieDescription.text = movie.overview
            cell.movieImage.kf.setImage(with: URL(string: movie.fullBackdropURL ?? ""), placeholder: UIImage(named: "placeholder-image"))
            return cell
        }
        return UICollectionViewCell()
    }
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == popularCollectionView {
            let pageWidth = scrollView.frame.size.width
            let page = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = page
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            var movieId: Int?

            if collectionView == recommendedCollectionView {
                movieId = viewModel.recommendedMovies[indexPath.item].id
            } else if collectionView == popularCollectionView {
                movieId = viewModel.popularMovies[indexPath.item].id
            }

            guard let id = movieId else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
                detailsVC.movieId = id
                navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
}

extension MovieHomeViewController: UITableViewDataSource,UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = viewModel.topSearchItems[indexPath.row].id
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            detailsVC.movieId = id
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

    
}
