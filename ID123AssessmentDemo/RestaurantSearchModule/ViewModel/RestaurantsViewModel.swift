
import Foundation

protocol RestaurantsViewProtocol : AnyObject {
   func showActIndicator()
   func hideActIndicator()
   func showAlertView(message:String)
   func showListBottomLoader()
   func hideListBottomLoader()
}

class RestaurantsViewModel {
        
    private var restaurantsModel:RestaurantsModel = RestaurantsModel()
    
    var restData: RestaurantData = RestaurantData() {
           didSet {
               self.bindRestaurantsViewModelToController()
           }
       }
    
    var bindRestaurantsViewModelToController:(() -> ()) = {}
    
    private weak var view: RestaurantsViewProtocol?
    
    init(view: RestaurantsViewProtocol) {
        self.view = view
    }
    
    
    func callAPIToGetRestaurantData(radius: Int, offset: Int, showBottomLoader:Bool = false) {
        
       // self.view?.showActIndicator()
        if showBottomLoader {
            self.view?.showListBottomLoader()
        }
        
        restaurantsModel.fetchRestaurantsData(radius: radius, offset: offset, completion: {[weak self] allData, error in
            
           // self.view?.hideActIndicator()
            if showBottomLoader {
                self?.view?.hideListBottomLoader()
            }
            
            if error != nil {
                self?.view?.showAlertView(message: "\(String(describing: error?.localizedDescription))")
                
            } else if allData != nil {
                self?.restData = allData ?? RestaurantData()
            }
            
        })
        
    }
    
}
