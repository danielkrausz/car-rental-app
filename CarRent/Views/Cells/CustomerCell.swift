//
//  Customer.swift
//  CarRent
//
//  Created by Dániel Krausz on 2019. 10. 27..
//  Copyright © 2019. Dániel Krausz. All rights reserved.
//

import UIKit

class CustomerCell: UITableViewCell {
    public static let reuseIdentifier = "CustomerCell"

    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureWith(customer : Customer) {
        customerName.text = customer.firstName +  " " + customer.lastName
        customerEmail.text = customer.emailAddress
    }

}
