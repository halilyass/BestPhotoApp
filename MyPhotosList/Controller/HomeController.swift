//
//  HomeController.swift
//  MyPhotosList
//
//  Created by Halil YAŞ on 29.12.2022.
//

import UIKit
import CoreData

class HomeController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - Properties
    
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    //persistenConteiner ---- burası appdelegate ' a ulaşmak için.
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        frc = getFRC()
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print(error)
            return
        }
        self.tableView.reloadData()

    }
    
    //MARK: - Helpers
    
    // Veri tabanından verileri getirecek..
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        
        let sorter = NSSortDescriptor(key: "titleText", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        
        return fetchRequest
        
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: pc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            let selectedCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
            
            let vc : AddPhotoController = segue.destination as! AddPhotoController
            let selectedItem : Entity = frc.object(at: indexPath!) as! Entity
            vc.selectedItem = selectedItem
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = frc.sections?[section].numberOfObjects
        
        return numberOfRows!
    }
    
    //MARK: - CELL FOR ROW AT
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        let dataRow = frc.object(at: indexPath) as! Entity
        
        cell.titleLabel.text = dataRow.titleText
        cell.descriptionLabel.text = dataRow.descriptionText
        
        //NSData yı Data ya çevirmemiz gerekli
        cell.myPhotos.image = UIImage(data: (dataRow.image)! as Data)
        
        return cell
    }
    
    //Veriler Geldiyse TableView güncellensin
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    //MARK: - UITABLEVİEW EDİTİNG STYLE
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedObject : NSManagedObject = frc.object(at: indexPath) as! NSManagedObject
        pc.delete(managedObject)
        
        do {
            try pc.save()
        } catch {
            print(error)
            return
        }
    }
}

