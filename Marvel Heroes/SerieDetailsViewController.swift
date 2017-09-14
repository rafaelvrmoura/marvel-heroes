//
//  SerieDetailsViewController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 12/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Kingfisher

class SerieDetailsViewController: UIViewController {

    enum SectionType: String {
        case comics = "Comics"
        case stories = "Stories"
        case events = "Events"
        case characters = "Characters"
        case creators = "Creators"
    }
    
    @IBOutlet weak var nextSeriesLabel: UILabel!
    @IBOutlet weak var previousSeriesLabel: UILabel!
    @IBOutlet weak var startYearLabel: UILabel!
    @IBOutlet weak var endYearLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var serieSummary: SerieSummary!
    fileprivate var serie: Serie?
    
    fileprivate var sections = [SectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSerie()
    }

    
    private func loadSerie() {
        
        guard let serieID = serieSummary.serieID else {
            setupEmptyState()
            return
        }
        
        let provider = MarvelProvider<Serie>()
        provider.request(target: .serie(id: serieID)) { (series, error) in
            
            if let serie = series?.first, error == nil {
                self.serie = serie
                self.setupUI()
            }else {
                self.setupEmptyState()
            }
        }
        
    }
    
    private func setupUI() {
        
        self.titleLabel.text = serie?.title
        self.descriptionView.text = serie?.description
        self.previousSeriesLabel.text = serie?.previous?.name ?? "No information"
        self.nextSeriesLabel.text = serie?.next?.name ?? "No information"
        
        if let startYear = serie?.startYear {
            self.startYearLabel.text = "\(startYear)"
        }else {
            self.startYearLabel.text = "no start year"
        }
        
        if let endYear = serie?.endYear {
            self.startYearLabel.text = endYear == 2099 ? "ongoing" : "\(endYear)"
        }
        
        if let thumbnailURL = serie?.thumbnail?.url(with: .portraitXLarge) {
            self.thumbnailView.kf.setImage(with: thumbnailURL)
        }
        
        loadSections()
    }
    
    private func loadSections() {
        
        if let comics = serie?.comics, !comics.isEmpty { sections.append(.comics) }
        if let stories = serie?.stories, !stories.isEmpty { sections.append(.stories) }
        if let events = serie?.events, !events.isEmpty { sections.append(.events) }
        if let characters = serie?.characters, !characters.isEmpty { sections.append(.characters) }
        if let creators = serie?.creators, !creators.isEmpty { sections.append(.creators) }
        
        tableView.reloadData()
    }
    
    private func setupEmptyState() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SerieDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
        case .comics:
            return serie?.comics?.count ?? 0
        case .stories:
            return serie?.stories?.count ?? 0
        case .events:
            return serie?.events?.count ?? 0
        case .characters:
            return serie?.characters?.count ?? 0
        case .creators:
            return serie?.creators?.count ?? 0
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
            cell.textLabel?.text = serie?.comics?[indexPath.row].name
            return cell
            
        case .stories:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            let story = serie?.stories?[indexPath.row]
            cell.textLabel?.text = story?.name
            cell.detailTextLabel?.text = story?.type
            return cell
            
        case .events:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = serie?.events?[indexPath.row].name
            return cell
            
        case .characters:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = serie?.characters?[indexPath.row].name
            return cell
            
        case .creators:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            let creator = serie?.creators?[indexPath.row]
            cell.textLabel?.text = creator?.name
            cell.detailTextLabel?.text = creator?.role
            return cell
        }
    }
}
