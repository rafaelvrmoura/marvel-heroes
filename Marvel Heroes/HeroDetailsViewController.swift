//
//  HeroDetailsViewController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 09/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Kingfisher


class HeroDetailsViewController: UIViewController {

    fileprivate enum SectionType: String {
        case comics = "Comics"
        case stories = "Stories"
        case events = "Events"
        case series = "Series"
    }
    
    weak var delegate: HeroDetailsViewControllerDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var sections = [SectionType]()
    
    var hero: Hero!
    
    private let heroDAO = HeroDAO(with: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = hero?.name
        descriptionLabel.text = hero?.description ?? "No description was found for this character."
        thumbnailView.kf.setImage(with: hero?.thumbnail?.url(with: .portraitXLarge))
        favoriteButton.setImage(try? heroDAO.isFavorite(hero) ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "non_favorite"), for: .normal)
        
        setupSections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    private func setupSections() {
        
        if let comics = hero.comics, !comics.isEmpty { sections.append(SectionType.comics)}
        
        if let stories = hero.stories, !stories.isEmpty { sections.append(SectionType.stories)}
        
        if let events = hero.events, !events.isEmpty { sections.append(SectionType.events)}
        
        if let series = hero.series, !series.isEmpty { sections.append(SectionType.series)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func toggleFavoriteStatus(_ sender: UIButton) {
        delegate?.detailsController(self, didToggleFavoriteStatusFor: hero)
        sender.setImage(try? heroDAO.isFavorite(hero) ? #imageLiteral(resourceName: "favorite") : #imageLiteral(resourceName: "non_favorite") , for: .normal)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let comicDetailsController = segue.destination as? ComicDetailsViewController {
            comicDetailsController.comicSummary = sender as! ComicSummary
            
        }else if let storyDetailsController = segue.destination as? StoryDetailsViewController {
            storyDetailsController.storySummary = sender as! StorySummary
            
        }else if let eventDetailsController = segue.destination as? EventDetailsViewController {
            eventDetailsController.eventSummary = sender as! EventSummary
            
        }else if let serieDetailsController = segue.destination as? SerieDetailsViewController {
            serieDetailsController.serieSummary = sender as! SerieSummary
        }
    }
}

// MARK: - TableView Delegate implementation

extension HeroDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = sections[indexPath.section]
        switch section {
        case .comics:
            let comicSummary = hero.comics?[indexPath.row]
            performSegue(withIdentifier: "comicDetails", sender: comicSummary)
        case .events:
            let eventSummary = hero.events?[indexPath.row]
            performSegue(withIdentifier: "eventDetails", sender: eventSummary)
        case .series:
            let serieSummary = hero.series?[indexPath.row]
            performSegue(withIdentifier: "serieDetails", sender: serieSummary)
        case .stories:
            let storySummary = hero.stories?[indexPath.row]
            performSegue(withIdentifier: "storyDetails", sender: storySummary)
        }
    }
}

// MARK: - TableView DataSource implementation
extension HeroDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
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
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        
        let text: String?
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
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

