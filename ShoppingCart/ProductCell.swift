//
//  ProductCell.swift
//  ShoppingCart
//
//  Created by Mac on 19/10/24.
//

import UIKit
import CoreData
protocol ProductCellDelegate: AnyObject {
    func updateQuantity(for product: Product, newQty: Int)
}
class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var product: Product! {
        didSet {
            guard let product = product else {
                return
            }
            quantityLabel.text = "\(product.qty)"
            productNameLabel.text = product.productName
            priceLabel.text = "\(product.price)"
        }
    }
    weak var delegate: ProductCellDelegate?
    private var maxQty: Int {
        switch product.productName {
        case "Cow Milk(1L)":
            return 5
        case "A2 Cow Milk(1L)":
            return 10
        default:
            return 1
        }
    }
    @IBAction func increaseQuantity(_ sender: UIButton) {
        if product.qty < maxQty {
            product.qty += 1
            quantityLabel.text = "\(product.qty)"
            delegate?.updateQuantity(for: product, newQty: product.qty)
        } else {
            showAlert(message: "Maximum quantity reached.")
        }
    }
    
    @IBAction func decreaseQuantity(_ sender: UIButton) {
        if product.qty > 1 {
            product.qty -= 1
            quantityLabel.text = "\(product.qty)"
            delegate?.updateQuantity(for: product, newQty: product.qty)
        } else {
            showAlert(message: "At least 1 quantity is required.")
        }
    }
    func showAlert(message: String) {
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            if topController.presentedViewController is UIAlertController {
                topController.dismiss(animated: false) // Dismiss the current alert without animation
            }
        }
    
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
    
       
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true)
        }
    }
}

