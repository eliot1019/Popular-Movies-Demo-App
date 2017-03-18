//
//  MovieTableViewCell.swift
//  Make School Code Challenge
//
//  Created by Eliot Han on 3/17/17.
//  Copyright © 2017 Eliot Han. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    private var artView: UIImageView!
    private var titleLabel: UILabel!
    private var dateLabel: UILabel!
    private var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    //Initializes the subviews of the cell.
    func initUI() {
        let height = contentView.frame.height
        let width = contentView.frame.width
        
        artView = UIImageView(frame: CGRect(x: 0, y: 0, width: height * 2/3, height: height))
        artView.image = UIImage(named: "defaultArt")
        contentView.addSubview(artView)
        
        titleLabel = UILabel(frame: CGRect(x: artView.frame.maxX + 10, y: height * (1/5), width: (width - artView.frame.maxX) * (4/5), height: height * (1/3)))
        titleLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        contentView.addSubview(titleLabel)
        
        dateLabel = UILabel(frame:  CGRect(x: artView.frame.maxX + 10, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height: height * (1/5)))
        dateLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        dateLabel.textColor = UIColor.gray
        contentView.addSubview(dateLabel)
        
        priceLabel = UILabel(frame: CGRect(x: titleLabel.frame.maxX + 5, y: height * 1/3, width: 40, height: height * 1/3))
        priceLabel.font = UIFont(name: "Avenir-Medium", size: 13)
        contentView.addSubview(priceLabel)
        
        
    }
    
    //Pass in a model, the cell will fill its UI. Cells should be stupid
    func updateWithModel(movie: Movie) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        priceLabel.text = movie.price
   
    }

    //Updates the album art of the cell
    func updateArt(art: UIImage) {
        artView.image = art
    }

}
