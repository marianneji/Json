//
//  ViewController.swift
//  Json
//
//  Created by Graphic Influence on 23/07/2019.
//  Copyright © 2019 marianne massé. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredItems = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchItem)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))]
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Can't load the page", message: "Please check your connection", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func searchItem() {
        let ac = UIAlertController(title: "Enter what you're looking for", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitSearch = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submitItem(item.lowercased())
        }
        ac.addAction(submitSearch)
        present(ac, animated: true)
    }
    
    @objc func refreshTableView() {
        
        filteredItems = petitions
        tableView.reloadData()
    }
    
    func submitItem(_ item: String) {
        
        filteredItems = filteredItems.filter() { $0.title.contains(item.lowercased()) || $0.body.contains(item.lowercased()) }
        tableView.reloadData()
    }
    
//    func containWord(word: String) -> Bool {
//
//        for words in petitions {
//            if words.title.contains(word) || words.body.contains(word) {
//                filteredItems.append(contentsOf: petitions)
//            } else {
//                return false
//            }
//        }
//        return true
//    }
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredItems = petitions
            tableView.reloadData()
            
        }
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Credits", message: "This is from the WhiteHouse API", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredItems[indexPath.row]
        cell.textLabel?.text = petition.title.lowercased()
        cell.detailTextLabel?.text = petition.body.lowercased()
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredItems[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

