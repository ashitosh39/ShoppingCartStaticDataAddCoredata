//
//  ViewController.swift
//  ShoppingCart
//
//  Created by Mac on 19/10/24.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProductCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPay: UILabel!
    @IBOutlet weak var totalItem: UILabel!
    
    var products: [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSONData()
        calculateTotal()
        fetchProductQuantities()
       
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func CheckOutBtn(_ sender: Any) {
       
    }
    
    
    func updateQuantity(for product: Product, newQty: Int) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].qty = newQty
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            calculateTotal()
        }
    }
    
    
    func loadJSONData() {
        let jsonData = """
            [
                {
                    "id": 5810,
                    "productID": 12,
                    "productName": "Cow Milk(1L)",
                    "price": 130,
                    "qty": 1,
                    "segmentPrice": 130,
                    "maxQty": 5,
                    "image": "https://csm.augtrans.com:4043/ovino/a2_cowmilk.jpg"
                   
                },
                {
                    "id": 5809,
                    "productID": 15,
                    "productName": "A2 Cow Milk(1L)",
                    "price": 150,
                    "qty": 1,
                    "segmentPrice": 150,
                    "maxQty": 10,
                    "image": "https://csm.augtrans.com:4043/ovino/cowmilk.jpg"
                }
            ]
            """.data(using: .utf8)!
        
        do {
            products = try JSONDecoder().decode([Product].self, from: jsonData)
            tableView.reloadData()
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    func fetchProductQuantities() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        do {
            let productEntities = try context.fetch(fetchRequest)
            for entity in productEntities {
                let product = Product(
                    id: Int(entity.id),
                    productID: Int(entity.productID),
                    productName: entity.productName ?? "",
                    price: entity.price,
                    qty: Int(entity.qty),
                    segmentPrice: entity.price,
                    maxQty: Int(entity.maxQty),
                    image: entity.image ?? ""
                )
                products.append(product)
            }
            tableView.reloadData()
        } catch {
            print("Failed to fetch products: \(error)")
        }
        print(products)

    }


    func calculateTotal() {
        let total = products.reduce(0) { $0 + ($1.price * Double($1.qty)) }
        totalLabel.text = "₹\(total)"
        let totalCount = products.reduce(0) { $0 + $1.qty }
        totalItem.text = "\(totalCount)"
        let totalpay = products.reduce(0) { $0 + ($1.price * Double($1.qty)) }
        totalPay.text = "₹\(total)"
        
    }
    
    func saveProductQuantities() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for product in products {
            let entity = ProductEntity(context: context)
            entity.id = Int32(product.id)
            entity.productID = Int32(product.productID)
            entity.productName = product.productName
            entity.price = product.price
            entity.qty = Int32(product.qty)
            entity.maxQty = Int32(product.maxQty)
            entity.image = product.image
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell .product = product
        cell.productNameLabel.text = product.productName
        cell.priceLabel.text = "₹\(product.price)"
        cell.quantityLabel.text = "\(product.qty)"
        cell.productImageView.loadImage(from: product.image)
        cell.delegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150.00
    }
    
}




extension UIImageView {
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }
        
       
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                      
                        self?.image = image
                    }
                }
            } else {
               
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "placeholder")
                }
            }
        }
    }
}

