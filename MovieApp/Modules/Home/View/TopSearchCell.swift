//
//  TopSearchCell.swift
//  MovieApp
//
//  Created by Mohamed Kotb on 22/07/2025.
//

import UIKit

class TopSearchCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieGener: UILabel!
    @IBOutlet weak var playBtn: UIButton!

    private let cardView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        setupContentLayout()
    }

    private func setupCardStyle() {
        selectionStyle = .none
        backgroundColor = .clear

        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 6
        cardView.layer.masksToBounds = false

        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func setupContentLayout() {
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true
        movieImage.layer.cornerRadius = 12

        movieImage.translatesAutoresizingMaskIntoConstraints = false
        movieName.translatesAutoresizingMaskIntoConstraints = false
        movieGener.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.tintColor = .systemPurple

        cardView.addSubview(movieImage)
        cardView.addSubview(movieName)
        cardView.addSubview(movieGener)
        cardView.addSubview(playBtn)

        NSLayoutConstraint.activate([
            movieImage.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            movieImage.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            movieImage.widthAnchor.constraint(equalToConstant: 60),
            movieImage.heightAnchor.constraint(equalToConstant: 60),

            playBtn.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            playBtn.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            playBtn.widthAnchor.constraint(equalToConstant: 30),
            playBtn.heightAnchor.constraint(equalToConstant: 30),

            movieName.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            movieName.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 12),
            movieName.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: -8),

            movieGener.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 4),
            movieGener.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 12),
            movieGener.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: -8),
            movieGener.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
