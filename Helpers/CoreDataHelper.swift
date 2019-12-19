import CoreData
import UIKit
import UserNotifications


let objDataHelper = CoreDataHelper()

class CoreDataHelper: NSObject, UNUserNotificationCenterDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    
    func openDatabse(VC: UIViewController,arrKeys : [String],arrValues : [String]) {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipes", in: context)
        let newTask = NSManagedObject(entity: entity!, insertInto: context)
        
        if UserDefaults.standard.value(forKey: "id") == nil {
            UserDefaults.standard.set(1, forKey: "id")
        } else if UserDefaults.standard.value(forKey: "id") != nil {
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "id") as! Int + 1, forKey: "id")
        }
        
        newTask.setValue(UserDefaults.standard.value(forKey: "id"), forKey: "id")
        
        for i in 0..<arrKeys.count {
            newTask.setValue(arrValues[i], forKey: arrKeys[i])
        }
        
        toastMessage("Saviing..")
        do {
            try context.save()
            if UserDefaults.standard.value(forKey: "firstTime") != nil {

            let alertController = UIAlertController(title: "Done", message: "Saved Successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (Action) in
                VC.popToBack()
            })
            alertController.addAction(OKAction)
            VC.present(alertController, animated: true, completion: nil)
            }
            fetchData()
        } catch {
            VC.alert(message: "Something went wrong, Please try again.", title: "Failed")
        }
    }
    
    //MARK:- Constants and Variables
    var arrExplore = [Dictionary<String, Any>]()
    var arrMyRecipes = [Dictionary<String,Any>]()
    var arrFavourites = [Dictionary<String,Any>]()
    
    //MARK:- Custom Functions
    func fetchData() {
        arrExplore.removeAll()
        arrMyRecipes.removeAll()
        arrFavourites.removeAll()
        
        context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                let id = data.value(forKey: "id") as! Int
                let type = data.value(forKey: "type") as! String
                let name = data.value(forKey: "name") as! String
                let image = data.value(forKey: "image") as! String
                let preparation = data.value(forKey: "preparation") as! String
                let ingrediants = data.value(forKey: "ingrediants") as! String
                let favStatus = data.value(forKey: "favStatus") as! String
                let note = data.value(forKey: "note") as! String
                
                let dict = ["image":image, "id": id,"type":type,"favStatus" : favStatus,"preparation":preparation,"ingrediants":ingrediants,"name":name,"note":note] as [String : Any]
                
                if dict["type"] as! String == "0"{
                    arrExplore.append(dict)
                    if dict["favStatus"] as! String == "1" {
                        arrFavourites.append(dict)
                    }
                } else {
                    arrMyRecipes.append(dict)
                    if dict["favStatus"] as! String == "1" {
                        arrFavourites.append(dict)
                    }
                }
            }
        } catch {
            toastMessage("\(error.localizedDescription)")
        }
    }
    
    func delete(VC: UIViewController, selected: Int) {
        context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        var fetchedEntities = NSArray()
        let predicate = NSPredicate(format: "id == %d", selected)
        fetchRequest.predicate = predicate
        fetchedEntities = try! context.fetch(fetchRequest) as NSArray
        do {
            for sequence in fetchedEntities {
                context?.delete(sequence as! NSManagedObject)
                do {
                    try context.save()
                    toastMessage("Deleted Successfully")
                    VC.popToBack()
                } catch {
                    VC.alert(message: "Something went wrong, Please try again.", title: "Updating data Failed")
                }
            }
        }
    }
    
    func update(VC: UIViewController,arrKeys : [String],arrValues : [String], selectedID: Int) {
        context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        var fetchedEntities = NSArray()
        let predicate = NSPredicate(format: "id == %d", selectedID)
        fetchRequest.predicate = predicate
        fetchedEntities = try! context.fetch(fetchRequest) as NSArray
        for i in 0..<arrKeys.count {
            fetchedEntities.setValue(arrValues[i], forKey: arrKeys[i])
        }
        toastMessage("Saving..")
        do {
            try context.save()
            fetchData()
            let alertController = UIAlertController(title: "Done", message: "Updated Successfully.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (Action) in
                VC.pushTo(VC: "ListVC")
            })
            alertController.addAction(OKAction)
            VC.present(alertController, animated: true, completion: nil)
        } catch {
            VC.alert(message: "Something went wrong, Please try again.", title: "Updating data Failed")
        }
    }
    
    func updateStatus(id: Int, status: String) {
        context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        var fetchedEntities = NSArray()
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        fetchedEntities = try! context.fetch(fetchRequest) as NSArray
        fetchedEntities.setValue(status, forKey: "favStatus")
        do {
            try context.save()
            fetchData()
        } catch {
            toastMessage("Something went wrong, Please try again later")
        }
    }
    
    func addNote(id: Int, note: String) {
        context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        var fetchedEntities = NSArray()
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        fetchedEntities = try! context.fetch(fetchRequest) as NSArray
        fetchedEntities.setValue(note, forKey: "note")
        do {
            try context.save()
            fetchData()
        } catch {
            toastMessage("Something went wrong, Please try again later")
        }
    }
}
