# Témalabor(BMEVIAUAL00) [Csapat: Pénzfeldobás]
## iOS admin client

# Architecture

- Models:
  - Car
  - Rent
  - Customer
- Views:
  - CustomerTableView
  - CustomerDetailsView
  - RentTableView
  - RentDetailsView
  - CarTableView
  - CarDetailsView
- ViewControllers:
  - CustomerTableViewController
  - CustomerDetailsViewController
  - RentTableViewController
  - RentDetailsViewController
  - CarTableViewController
  - CarDetailsViewController


# Packages (Imported with Swift Package Manager)
- Moya[https://github.com/Moya/Moya]
  - Used for implementing networking
  - Implemented API endpoints:
    - /login/admin
    - /customers
    - /rents/unclosed
    - /cars
    - /cars/register
- KeychainAccess[https://github.com/kishikawakatsumi/KeychainAccess]
  - Keychain wrapper so it is easier to store the user's credentials in keychain
