//
//  EventDetailsViewController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 12/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    
    enum SectionType: String {
        case comics = "Comics"
        case stories = "Stories"
        case series = "Series"
        case characters = "Characters"
        case creators = "Creators"
    }
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var previousEventLabel: UILabel!
    @IBOutlet weak var nextEventLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections = [SectionType]()
    
    var eventSummary: EventSummary!
    fileprivate var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        loadEvent()
    }

    private func loadEvent() {
        
        guard let eventID = eventSummary.eventID else {
            setupEmptyState()
            return
        }
        
        let provider = MarvelProvider<Event>()
        provider.request(target: .event(id: eventID)) { (events, error) in
            
            if let event = events?.first, error == nil {
                self.event = event
                self.setupUI()
            }else {
                self.setupEmptyState()
            }
        }
        
    }
    
    private func setupEmptyState() {
        // TODO: show empty state ui
    }
    
    private func setupUI() {
        
        self.titleLabel.text = event?.title
        self.descriptionLabel.text = event?.description
        self.nextEventLabel.text = event?.next?.name
        self.previousEventLabel.text = event?.previous?.name
        
        self.startDateLabel.text = event?.start?.localizedString(withDateStyle: .short, andTimeStyle: .none)
        self.endDateLabel.text = event?.end?.localizedString(withDateStyle: .short, andTimeStyle: .none)
    }
    
    private func setupSections() {
        
        if let comics = event?.comics, !comics.isEmpty { sections.append(.comics) }
        if let stories = event?.stories, !stories.isEmpty { sections.append(.stories) }
        if let series = event?.series, !series.isEmpty { sections.append(.series) }
        if let characters = event?.characters, !characters.isEmpty { sections.append(.characters) }
        if let creators = event?.creators, !creators.isEmpty { sections.append(.creators) }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EventDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
        case .comics:
            return event?.comics?.count ?? 0
        case .stories:
            return event?.stories?.count ?? 0
        case .series:
            return event?.series?.count ?? 0
        case .characters:
            return event?.characters?.count ?? 0
        case .creators:
            return event?.creators?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        
        switch section {
        case .comics:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = event?.comics?[indexPath.row].name
            return cell
            
        case .stories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            let story = event?.stories?[indexPath.row]
            cell.textLabel?.text = story?.name
            cell.detailTextLabel?.text = story?.type
            return cell
            
        case .series:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = event?.series?[indexPath.row].name
            return cell
            
        case .characters:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = event?.characters?[indexPath.row].name
            return cell
            
        case .creators:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            let creator = event?.creators?[indexPath.row]
            cell.textLabel?.text = creator?.name
            cell.detailTextLabel?.text = creator?.role
            return cell
        }
        
    }
    
}
