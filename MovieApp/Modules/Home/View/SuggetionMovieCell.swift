//
//  SuggetionMovieCell.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import UIKit

class SuggetionMovieCell: UICollectionViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription : UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        movieDescription.numberOfLines = 2
        movieDescription.lineBreakMode = .byTruncatingTail
        movieDescription.textAlignment = .left
        
        movieTitle.numberOfLines = 1
        
        movieImage.contentMode = .scaleToFill
           
    }

}
