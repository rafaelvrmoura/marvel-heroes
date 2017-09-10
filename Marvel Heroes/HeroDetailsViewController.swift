//
//  HeroDetailsViewController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 09/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Kingfisher

enum Participation: String {
    case comics = "Comics"
    case stories = "Stories"
    case events = "Events"
    case series = "Series"
}

class HeroDetailsViewController: UIViewController {

    weak var delegate: HeroDetailsViewControllerDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var sectionsTypes = [Participation]()
    
    var hero: Hero!
    
    private let heroDAO = HeroDAO(with: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = hero?.name
        descriptionLabel.text = hero?.description ?? "No description was found for this character."
        thumbnailView.kf.setImage(with: hero?.thumbnail?.url(with: .portraitXLarge))
        favoriteButton.setImage(try? heroDAO.isFavorite(hero) ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "non_favorite"), for: .normal)
        
        setupSectionsTypes()
    }
    
    private func setupSectionsTypes() {
        
        if let comics = hero.comics, !comics.isEmpty { sectionsTypes.append(Participation.comics)}
        
        if let stories = hero.stories, !stories.isEmpty { sectionsTypes.append(Participation.stories)}
        
        if let events = hero.events, !events.isEmpty { sectionsTypes.append(Participation.events)}
        
        if let series = hero.series, !series.isEmpty { sectionsTypes.append(Participation.series)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func toggleFavoriteStatus(_ sender: UIButton) {
        delegate?.detailsController(self, didToggleFavoriteStatusFor: hero)
        sender.setImage(try? heroDAO.isFavorite(hero) ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "non_favorite") , for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - TableView DataSource implementation
extension HeroDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let participation = sectionsTypes[section]
        
        switch participation {
        case .comics:
            return hero.comics!.count <= 3 ? hero.comics!.count : 3
        case .events:
            return hero.events!.count <= 3 ? hero.events!.count : 3
        case .series:
            return hero.series!.count <= 3 ? hero.series!.count : 3
        case .stories:
            return hero.stories!.count <= 3 ? hero.stories!.count : 3
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTypes[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        
        let text: String?
        
        let participation = sectionsTypes[indexPath.section]
        
        switch participation {
        case .comics:
            text = hero.comics?[indexPath.row].name
        case .series:
            text = hero.series?[indexPath.row].name
        case .events:
            text = hero.events?[indexPath.row].name
        case .stories:
            text = hero.stories?[indexPath.row].name
        }
        
        cell.textLabel?.text = text
        
        return cell
    }
}

protocol HeroDetailsViewControllerDelegate: class {
    
    func detailsController(_ controller: HeroDetailsViewController, didToggleFavoriteStatusFor hero: Hero)
    
}

