//
//  ViewController.swift
//  HW25
//
//  Created by Дмитрий Цветков on 01.12.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonForSearch: UIButton!
    
    @IBOutlet weak var textFieldForSerach: UITextField!
    
    
    let uiImage1 = UIImageView()
    
    
    var items: [MyEntity]?

    
    let managedObject = MyEntity(entity: CoreDataManager.instance.entityForName(entityName: "MyEntity"), insertInto: CoreDataManager.instance.context)
    
    var elementsAfterSearch: [String]? = []
    
    
    
    func addInCoreData(index: Int) { // Функция добавления элементов в БД
        let newMyEntity = MyEntity(context: CoreDataManager.instance.context)
        newMyEntity.setValue(heroes[index].name, forKey: "name")
        do {
            try CoreDataManager.instance.saveContext()
            print("Сохранен элемент: \(newMyEntity.name!)")
        } catch {
            CoreDataManager.instance.context.rollback()
        }
    }

    
    func deleteAllFromCoreData() { // Функция удаления всех элементов из БД
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEntity")

        
        do {
            let results = try CoreDataManager.instance.context.fetch(request)
            for result in results as! [NSManagedObject]{
                CoreDataManager.instance.context.delete(result)
            }
            
        } catch {
            print(error)
        }

    }
    
    
    func findElement(text: String) { // Функция поиска элемента в БД

        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEntity")
        request.fetchOffset = 0
        request.fetchLimit = 10
        
        request.predicate = NSPredicate(format: "ANY name CONTAINS %@", "\(text)")
        
        
        do {
            let result = try CoreDataManager.instance.context.fetch(request)
            
            print("Найдено элементов: \(result.count)")
            
            
            
            for _ in 0..<(elementsAfterSearch?.count ?? 0) {
                elementsAfterSearch?.removeFirst()
            }
            
            for i in result as! [NSManagedObject] {
                print("found name - \(i.value(forKey: "name")!)")
                elementsAfterSearch?.append(i.value(forKey: "name")! as! String)
            }
  
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    var heroes = [Hero]()
    
    let mas = ["https://img3.akspic.ru/previews/9/6/1/9/6/169169/169169-ty_zasluzhivaesh_vsyacheskogo_schastya-schaste-strah-voda-polety_na_vozdushnom_share-500x.jpg", "https://avatars.mds.yandex.net/i?id=1de86bec0b29cc17d5367e336943cd3fcc70045e-5332070-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=d78da4217b732cc1f02b14c414bcefb8c2c22756-5234859-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=76eaad2e18d0f55bb2473ad21a21b85e-5349329-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=4fd21f52672b06636f7ce1d8c300659e-5436735-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=c220cebda8eb7b6207326d772f1308bea231c45c-5711615-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=6d680f0a41aceb085172066243526f07a316fb6c-6212678-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=84e68b572a9c10656112249811baf8dde53023a8-3584141-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=fc7a0b9cbc34c0d1f82a50acafa1da26-4118910-images-thumbs&n=13", "https://avatars.mds.yandex.net/i?id=3eb79a7a0038200bb38a51619b42324031330a95-5869855-images-thumbs&n=13"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        deleteAllFromCoreData()

        downloadJSON {
            print("success")
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
    }

var mas3 = [UIImageView]()
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                do {
                    self.heroes = try JSONDecoder().decode([Hero].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("JSON error")
                }
            }
            for i in 0..<10 {
                self.addInCoreData(index: i) // Сохранение в CoreData 10 элементов
            }
            
            for j in 0..<10 {
                let photo = Photo(context: CoreDataManager.instance.context)
                photo.title = "\(j)"
                
                    photo.content?.downloaded(from: self.mas[j])
            }
            
        }.resume()

    }

    
    @IBAction func onButtonTapped(_ sender: Any) {
        findElement(text: textFieldForSerach.text ?? "")
        let alert = UIAlertController(title: "Поиск", message: "Найденные элементы: ", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Закрыть", style: .cancel)
        
        for i in 0..<(elementsAfterSearch?.count ?? 0) {
            alert.addTextField()
            alert.textFields?[i].text = self.elementsAfterSearch?[i]
        }
        
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 10 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            
            cell.textLabel?.text = heroes[indexPath.row].name

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 10 {
            performSegue(withIdentifier: "identify", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SecondVCViewController {
            destination.hero = heroes[(tableView.indexPathForSelectedRow?.row)!]
            destination.urlString = mas[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

