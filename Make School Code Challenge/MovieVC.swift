//
//  MovieVC.swift
//  Make School Code Challenge
//
//  Created by Eliot Han on 3/17/17.
//  Copyright © 2017 Eliot Han. All rights reserved.
//

//A detail screen for Movies

import Foundation
import UIKit

class MovieVC: UIViewController {
    var movie: Movie!   // We will hold a reference to the movie
    
    private var artView: UIImageView!
    private var dateLabel: UILabel!
    private var priceLabel: UILabel!
    private var itunesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    //Setups the screen. We pass in an image so we don't have to redownload anything
    func setup(movie: Movie, image: UIImage) {
        self.movie = movie
        
        navigationItem.title = movie.title
        
        let width = view.frame.width
    
        artView = UIImageView(frame: CGRect(x: width * 1/5, y: 70, width: width * 3/5, height: (width * 3/5) * 1.4))
        artView.image = image
        view.addSubview(artView)
        
        dateLabel = UILabel(frame: CGRect(x: width * 1/5, y: artView.frame.maxY + 10, width: width * 3/5, height: 35))
        dateLabel.textAlignment = .center
        dateLabel.text = "Release date: " + movie.releaseDate
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(dateLabel)
        
        priceLabel = UILabel(frame: CGRect(x: width * 1/5, y: dateLabel.frame.maxY + 5, width: width * 3/5, height: 30))
        priceLabel.textAlignment = .center
        priceLabel.text = "Price: " + movie.price
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(priceLabel)

        itunesButton = UIButton(frame: CGRect(x: width * 1/3, y: priceLabel.frame.maxY + 10, width: width * 1/3, height: (width * 1/3) * 0.55))
        itunesButton.setImage(UIImage(named: "itunesIcon"), for: .normal)
        itunesButton.addTarget(self, action: #selector(itunesButtonPressed), for: .touchUpInside)
        view.addSubview(itunesButton)
    }
    
    func itunesButtonPressed() {
        let url = URL(string: movie.contentLinkString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)

    }
    
    
    
    

}
