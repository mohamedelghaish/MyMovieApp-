//
//  MovieCell.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import UIKit

class GenresCell: UICollectionViewCell {

    @IBOutlet weak var movieGener: UILabel!
    @IBOutlet weak var movieView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        movieView.layer.cornerRadius = 6
        movieView.layer.borderWidth = 1
        movieView.layer.borderColor = UIColor.gray.cgColor
    }
    override func layoutSubviews() {
            super.layoutSubviews()
            contentView.layoutIfNeeded()
        }
}
