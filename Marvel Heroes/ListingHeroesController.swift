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

enum DisplayMode: String {
    case all = "All"
    case favorites = "Favorites"
    
    mutating func toggle() {
        switch self {
        case .all:
            self = .favorites
        case .favorites:
            self = .all
        }
    }
}

class ListingHeroesController: UICollectionViewController {

    fileprivate let favoriteImage = #imageLiteral(resourceName: "favorite")
    fileprivate let nonFavoriteImage = #imageLiteral(resourceName: "non_favorite")
    fileprivate var isLoading = false
    fileprivate let reuseIdentifier = "HeroCell"
    
    fileprivate var heroes = [Hero]()
    fileprivate var favoriteHeroes = [Hero]()
    
    fileprivate let heroProvider = MarvelProvider<Marvel, Hero>()
    fileprivate let heroDAO = HeroDAO(with: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    fileprivate var displayMode: DisplayMode = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    // MARK: - Actions
    
    @IBAction func toggleDisplayingPrefferences(_ sender: UIBarButtonItem) {
        
        self.displayMode.toggle()
        
        switch displayMode {
        case .all:
            sender.title = "Favorites"
            self.favoriteHeroes.removeAll()
        case .favorites:
            sender.title = "All"
        }
        
        self.collectionView?.reloadData()
    }
    
    
    // MARK: - API Fetches stack 
    fileprivate func loadHeroes(from offset: Int, limit: Int) {
        
        guard !isLoading else { return }
        
        isLoading = true
        heroProvider.request(target: .characters(limit: limit, offset: offset, name: nil, nameStartsWith: nil)) { (heroes, error) in
            
            self.isLoading = false
            if let heroes = heroes, heroes.count > 0, error == nil {
                self.insertCollectionViewItems(for: heroes)
            }
        }
    }
    
    fileprivate func fetchFavoriteHeroes(from offset: Int, limit: Int) {

        guard let fetchResults = try? heroDAO.fetch(from: offset, to: limit), let favorites = fetchResults else { return }
        self.insertCollectionViewItems(for: favorites)
    }
    
    fileprivate func hero(at index: Int) -> Hero {
        let hero: Hero
        
        switch displayMode {
        case .all:
            hero = heroes[index]
        case .favorites:
            hero = favoriteHeroes[index]
        }
        
        return hero
    }
    
    private func insertCollectionViewItems(for heroes: [Hero]) {
        
        let currentNumberOfHeroes = ((displayMode == .all) ? self.heroes.count : self.favoriteHeroes.count)
        let numberOfHeroesToAdd = heroes.count
        
        let newIndexPaths = (currentNumberOfHeroes..<(currentNumberOfHeroes + numberOfHeroesToAdd)).map{IndexPath(item: $0, section: 0)}
        
        self.displayMode == .all ? self.heroes.append(contentsOf: heroes) : self.favoriteHeroes.append(contentsOf: heroes)
        collectionView?.insertItems(at: newIndexPaths)
    }
    
    // MARK: - UICollectionViewDelegate
    
}

// MARK: - UICollectionViewDataSource
extension ListingHeroesController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch displayMode {
        case .all:
            return heroes.count
        case .favorites:
            return favoriteHeroes.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeroCell
        
        let hero = self.hero(at: indexPath.item)
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
            
            switch displayMode {
            case .all:
                loadHeroes(from: heroes.count, limit: 20)
            case .favorites:
                fetchFavoriteHeroes(from: favoriteHeroes.count, limit: 20)
            }
            return loadingIndicatorView
        }
        
        return UICollectionReusableView(frame: .zero)
    }
}

// MARK: - HeroCell Delegate implementation

extension ListingHeroesController: HeroCellDelegate {
    
    func toggleFavoriteStatusForHero(at cell: HeroCell) {
        
        guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
        
        let hero = self.hero(at: indexPath.item)
        
        do {
            if try heroDAO.isFavorite(hero) {
                try heroDAO.unFavorite(hero)
                cell.favoriteButton.setImage(nonFavoriteImage, for: .normal)
                
                // If displaying favorites the cell must be deleted from collectionview
                if displayMode == .favorites {
                    favoriteHeroes.remove(at: indexPath.item)
                    self.collectionView?.deleteItems(at: [indexPath])
                }
                
            }else {
                try heroDAO.favorite(hero)
                cell.favoriteButton.setImage(favoriteImage, for: .normal)
            }
            
        } catch {
            // TODO: Handle error
        }
    }
}

