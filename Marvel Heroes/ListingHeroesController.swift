//
//  ListingHeroesController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 07/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

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

    fileprivate let PAGE_LIMIT = 20
    fileprivate let favoriteImage = #imageLiteral(resourceName: "favorite")
    fileprivate let nonFavoriteImage = #imageLiteral(resourceName: "non_favorite")
    fileprivate var isLoading = false
    fileprivate let reuseIdentifier = "HeroCell"
    
    fileprivate var heroes = [Hero]()
    fileprivate var favoriteHeroes = [Hero]()
    fileprivate var searchDataSource = [Hero]()
    
    fileprivate var searchText: String?
    fileprivate var disposeBag = DisposeBag()
    
    fileprivate let heroProvider = MarvelProvider<Hero>()
    fileprivate let heroDAO = HeroDAO(with: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    fileprivate var displayMode: DisplayMode = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController, let heroDetailsController = navController.topViewController as? HeroDetailsViewController {
            segue.destination.transitioningDelegate = self
            heroDetailsController.hero = sender as! Hero
            heroDetailsController.delegate = self
        }
    }
 

    // MARK: Actions
    
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
    
    fileprivate func toggleFavoriteStatusForHero(at index: Int) {
        
        let hero = self.hero(at: index)
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath) as? HeroCell
        
        do {
            if try heroDAO.isFavorite(hero) {
                try heroDAO.unFavorite(hero)
                
                // If displaying favorites the cell must be deleted from collectionview
                if displayMode == .favorites {
                    favoriteHeroes.remove(at: index)
                    self.collectionView?.deleteItems(at: [indexPath])
                }
                
            }else {
                try heroDAO.favorite(hero)
            }
            
            cell?.favoriteButton.setImage(try? heroDAO.isFavorite(hero) ? favoriteImage : nonFavoriteImage, for: .normal)
        } catch {
            // TODO: Handle the error
        }
    }
    
    // MARK: API Fetches stack
    fileprivate func loadHeroesWhere(nameStartsWith characters: String? = nil, from offset: Int, limit: Int) {
        
        guard !isLoading else { return }
        
        isLoading = true
        heroProvider.request(target: .characters(limit: limit, offset: offset, name: nil, nameStartsWith: characters)) { (heroes, error) in
            
            self.isLoading = false
            if let heroes = heroes, heroes.count > 0, error == nil {
                self.insertCollectionViewItems(for: heroes)
            }
        }
    }
    
    fileprivate func fetchFavoriteHeroesWhere(nameStartsWith characters: String? = nil, from offset: Int, limit: Int) {

        guard let fetchResults = try? heroDAO.fetch(whereNameStartsWith: characters, from: offset, to: limit), let favorites = fetchResults else { return }
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
    
    fileprivate func index(for hero: Hero) -> Int {
        
        switch displayMode {
        case .all:
            return heroes.index(where: { $0.id == hero.id })!
        case .favorites:
            return favoriteHeroes.index(where: { $0.id == hero.id })!
        }
    }
    
    private func insertCollectionViewItems(for heroes: [Hero]) {
        
        let currentNumberOfHeroes = ((displayMode == .all) ? self.heroes.count : self.favoriteHeroes.count)
        let numberOfHeroesToAdd = heroes.count
        
        let newIndexPaths = (currentNumberOfHeroes..<(currentNumberOfHeroes + numberOfHeroesToAdd)).map{IndexPath(item: $0, section: 0)}
        
        self.displayMode == .all ? self.heroes.append(contentsOf: heroes) : self.favoriteHeroes.append(contentsOf: heroes)
        collectionView?.insertItems(at: newIndexPaths)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hero = self.hero(at: indexPath.item)
        self.performSegue(withIdentifier: "heroDetails", sender: hero)
    }
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
        
        cell.favoriteButton.setImage(try? heroDAO.isFavorite(hero) ? favoriteImage : nonFavoriteImage, for: .normal)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let loadingIndicatorView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingIndicatorView", for: indexPath)
            
            switch displayMode {
            case .all:
                loadHeroesWhere(nameStartsWith: searchText, from: heroes.count, limit: PAGE_LIMIT)
            case .favorites:
                fetchFavoriteHeroesWhere(nameStartsWith: searchText, from: favoriteHeroes.count, limit: PAGE_LIMIT)
            }
            return loadingIndicatorView
            
        } else if kind == UICollectionElementKindSectionHeader {
            let searchBarView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchBarView", for: indexPath)
            let searchBar = searchBarView.subviews.first as! UISearchBar
            searchBar.text = searchText
            
            searchBar.rx.text.orEmpty
                .changed
                .asObservable()
                .throttle(0.3, scheduler: MainScheduler.instance)
                .subscribe { event in
                    self.search(with: event.element ?? "", completion: {
                        searchBar.becomeFirstResponder()
                    })
                }
                .disposed(by: disposeBag)
            
            return searchBarView
        }
        
        return UICollectionReusableView(frame: .zero)
    }
}

// MARK: - SearchBar Delegate implementation

extension ListingHeroesController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        search(with: searchBar.text ?? "", completion: {
            searchBar.resignFirstResponder()
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        search(with: searchBar.text ?? "") {
            searchBar.resignFirstResponder()
        }
    }
    
    fileprivate func search(with text: String, completion: @escaping ()->()) {
        
        self.searchText = text.isEmpty ? nil : text
        
        switch displayMode {
        case .all:
            let indexPaths = (0..<heroes.count).map{IndexPath(item: $0, section: 0)}
            heroes.removeAll()
            
            collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: indexPaths)
            },  completion: { _ in
                completion()
                self.loadHeroesWhere(nameStartsWith: self.searchText, from: self.heroes.count, limit: self.PAGE_LIMIT)
            })
            
            
        case .favorites:
            let indexPaths = (0..<favoriteHeroes.count).map{IndexPath(item: $0, section: 0)}
            favoriteHeroes.removeAll()
            
            collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: indexPaths)
            }, completion: { _ in
                completion()
                self.fetchFavoriteHeroesWhere(nameStartsWith: self.searchText, from: self.favoriteHeroes.count, limit: self.PAGE_LIMIT)
            })
            
        }
    }
}

// MARK: - HeroCell Delegate implementation

extension ListingHeroesController: HeroCellDelegate {
    
    func toggleFavoriteStatusForHero(at cell: HeroCell) {
        
        guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
        toggleFavoriteStatusForHero(at: indexPath.item)
    }
}

// MARK: - HeroDetailsViewController Delegate implementation

extension ListingHeroesController: HeroDetailsViewControllerDelegate {
    func detailsController(_ controller: HeroDetailsViewController, didToggleFavoriteStatusFor hero: Hero) {
        
        let index = self.index(for: hero)
        toggleFavoriteStatusForHero(at: index)
    }
}

// MARK: - TransitioningDeltegate stack

extension ListingHeroesController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(with: 0.3, for: .dismissing, sender: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let selectedIndex = collectionView?.indexPathsForSelectedItems?.first
        let cell = collectionView?.cellForItem(at: selectedIndex!)
        
        return AnimationController(with: 0.5, for: .presenting, sender: cell)
    }
}


