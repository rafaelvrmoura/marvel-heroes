//
//  StoryDetailsViewController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 12/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Kingfisher

class StoryDetailsViewController: UIViewController {

    
    fileprivate enum SectionType: String {
        case comics = "Comics"
        case series = "Series"
        case events = "Events"
        case characters = "Characters"
        case creators = "Creators"
    }
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var originalIssueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionView: UITextView!
    
    var storySummary: StorySummary!
    fileprivate var story: Story?
    
    fileprivate var sections = [SectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        loadStory()
    }
    
    private func loadStory(){
        
        guard let storyID = storySummary.storyID else {
            setupEmptyState()
            return
        }
        
        let provider = MarvelProvider<Story>()
        provider.request(target: .story(id: storyID)) { (stories, error) in
            
            if let story = stories?.first, error == nil {
                self.story = story
                self.setupUI()
            }else {
                self.setupEmptyState()
            }
        }
    }
    
    private func setupUI() {
        
        setupSections()
        
        if let thumbnailURL = story?.thumbnail?.url(with: .portraitXLarge) {
            self.thumbnailView.kf.setImage(with: thumbnailURL)
        }
        
        self.titleLabel.text = story?.title
        self.originalIssueLabel.text = story?.originalIssue?.name ?? "There's no information"
        self.typeLabel.text = story?.type
        self.descriptionView.text = story?.description
    }
    
    private func setupEmptyState() {
        // TODO: Show empty state
    }
    
    private func setupSections() {
        
        if let comics = story?.comics, !comics.isEmpty { sections.append(.comics) }
        if let series = story?.series, !series.isEmpty { sections.append(.series) }
        if let events = story?.events, !events.isEmpty { sections.append(.events) }
        if let characters = story?.characters, !characters.isEmpty { sections.append(.characters) }
        if let creators = story?.creators, !creators.isEmpty { sections.append(.creators) }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension StoryDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
        case .comics:
            return story?.comics?.count ?? 0
        case .series:
            return story?.series?.count ?? 0
        case .events:
            return story?.events?.count ?? 0
        case .characters:
            return story?.characters?.count ?? 0
        case .creators:
            return story?.creators?.count ?? 0
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
            cell.textLabel?.text = story?.comics?[indexPath.row].name
            return cell
            
        case .series:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = story?.series?[indexPath.row].name
            return cell
            
        case .events:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = story?.events?[indexPath.row].name
            return cell
            
        case .characters:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = story?.characters?[indexPath.row].name
            return cell
            
        case .creators:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            let creator = story?.creators?[indexPath.row]
            cell.textLabel?.text = creator?.name
            cell.detailTextLabel?.text = creator?.role
            return cell
        }
    }
    
}
