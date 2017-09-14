//
//  ComicDetailsViewController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 12/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import Kingfisher

class ComicDetailsViewController: UIViewController {

    fileprivate enum SectionType: String {
        case prices = "Prices"
        case creators = "Creators"
        case characters = "Characters"
    }
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections = [SectionType]()
    var comicSummary: ComicSummary!
    fileprivate var comic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        loadComic()
    }
    
    private func loadComic(){
        
        guard let comicID = comicSummary.comicID else {
            setupEmptyState()
            return
        }
        
        let provider = MarvelProvider<Comic>()
        provider.request(target: .comic(id: comicID)) { (comics, error) in
            
            if let comic = comics?.first, error == nil {
                self.comic = comic
                self.setupUI()
            }else {
                self.setupEmptyState()
            }
        }
    }
    
    private func setupUI() {
        
        setupSections()
        
        if let thumbnailURL = comic?.thumbnail?.url(with: .portraitXLarge) {
            self.thumbnailView.kf.setImage(with: thumbnailURL)
        }
        
        self.titleLabel.text = comic?.title
        self.descriptionView.text = comic?.description
        self.pageCountLabel.text = "\(comic?.pageCount ?? 0)"
        self.formatLabel.text = comic?.format
    }
    
    private func setupEmptyState() {
        // TODO: Show empty state
    }
    
    private func setupSections() {
    
        if let prices = comic?.prices, !prices.isEmpty { sections.append(.prices) }
        if let creators = comic?.creators, !creators.isEmpty { sections.append(.creators) }
        if let characters = comic?.characters, !characters.isEmpty { sections.append(.characters) }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ComicDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        switch sectionType {
        case .prices:
            return self.comic?.prices?.count ?? 0
        case .creators:
            return self.comic?.creators?.count ?? 0
        case .characters:
            return self.comic?.characters?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let section = sections[indexPath.section]
        
        switch section {
            
        case .prices:
            let price = self.comic?.prices?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            cell.textLabel?.text = price?.type?.string
            cell.detailTextLabel?.text = price?.formatedPrice
            return cell
            
        case .creators:
            let creator = self.comic?.creators?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitledCell", for: indexPath)
            cell.textLabel?.text = creator?.name
            cell.detailTextLabel?.text = creator?.role
            return cell
            
        case .characters:
            let character = self.comic?.characters?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "titledCell", for: indexPath)
            cell.textLabel?.text = character?.name
            return cell
        }
    }
}
