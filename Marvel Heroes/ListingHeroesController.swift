//
//  ListingHeroesController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 07/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
import CoreData

class ListingHeroesController: UICollectionViewController {

    fileprivate let favoriteImage = #imageLiteral(resourceName: "favorite")
    fileprivate let nonFavoriteImage = #imageLiteral(resourceName: "non_favorite")
    private var isLoading = false
    private let reuseIdentifier = "HeroCell"
    
    var heroes = [Hero]()
    let provider = MoyaProvider<Marvel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHeroes(from: 0, limit: 20)   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - API Fetches stack 
    private func loadHeroes(from offset: Int, limit: Int) {
        
        guard !isLoading else { return }
        
        isLoading = true
        provider.request(.characters(limit: limit, offset: offset, name: nil, nameStartsWith: nil)) { (result) in
            
            self.isLoading = false
            switch result {
            case .success(let response):
                
                guard let marvelResponse = try? MarvelResponse<Hero>(with: response.data) else {return}
                guard let heroesContainer = marvelResponse.data else {return}
                guard let heroes = heroesContainer.results else {return}
                
                self.insertCollectionViewItems(for: heroes)
                
            case .failure(let error):
                // TODO: Handle the error
                print(error)
            }
        }
    }
    
    private func insertCollectionViewItems(for heroes: [Hero]) {
        
        let currentNumberOfHeroes = self.heroes.count
        let numberOfHeroesToAdd = heroes.count
        
        let newIndexPaths = (currentNumberOfHeroes..<(currentNumberOfHeroes + numberOfHeroesToAdd)).map{IndexPath(item: $0, section: 0)}
        
        self.heroes.append(contentsOf: heroes)
        collectionView?.insertItems(at: newIndexPaths)
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeroCell
        
        let hero = heroes[indexPath.item]
        cell.heroNameLabel.text = hero.name
        cell.delegate = self
        
        
        if let heroPictureURL = hero.thumbnail?.url(with: .portraitXLarge) {
            cell.heroThumbnailView.kf.setImage(with: heroPictureURL)
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let heroDAO = HeroDAO(with: context)
        
        cell.favoriteButton.setImage(try? heroDAO.isFavorite(hero) ? favoriteImage : nonFavoriteImage, for: .normal)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let loadingIndicatorView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingIndicatorView", for: indexPath)
            
            loadHeroes(from: heroes.count, limit: 20)
            return loadingIndicatorView
        }
        
        return UICollectionReusableView(frame: .zero)
    }
    
    // MARK: - UICollectionViewDelegate
    
}

// MARK: - HeroCell Delegate implementation

extension ListingHeroesController: HeroCellDelegate {
    
    func toggleFavoriteStatusForHero(at cell: HeroCell) {
        
        guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let heroDAO = HeroDAO(with: context)
        
        let hero = heroes[indexPath.item]
        
        do {
            
            if try heroDAO.isFavorite(hero) {
                try heroDAO.unFavorite(hero)
                cell.favoriteButton.setImage(nonFavoriteImage, for: .normal)
            }else {
                try heroDAO.favorite(hero)
                cell.favoriteButton.setImage(favoriteImage, for: .normal)
            }
            
        } catch {
            // TODO: Handle error
        }
    }
}

