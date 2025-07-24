//
//  FavoriteViewController.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 24/07/2025.
//

import UIKit
import Combine

class FavoriteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = FavoriteViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchSavedMovies()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = "Favorite Movies"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
      

       private func setupTableView() {
           tableView.register(UINib(nibName: "TopSearchCell", bundle: nil), forCellReuseIdentifier: "TopSearchCell")
           tableView.dataSource = self
           tableView.delegate = self
       }

       private func bindViewModel() {
           viewModel.$savedMovies
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in
                   self?.tableView.reloadData()
               }
               .store(in: &cancellables)
       }
   }

   extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.savedMovies.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopSearchCell", for: indexPath) as? TopSearchCell else {
               return UITableViewCell()
           }

           let movie = viewModel.savedMovies[indexPath.row]
           cell.movieName.text = movie.title
           cell.movieGener.text = movie.overview
           if let urlString = movie.posterURL, let url = URL(string: urlString) {
               cell.movieImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-image"))
           }
           cell.playBtn.isHidden = true

           return cell
       }
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
               if editingStyle == .delete {
                   viewModel.deleteMovie(at: indexPath.row)
               }
           }
    
   }
