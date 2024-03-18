import UIKit

struct Constants {
    //MARK: Defaults Networking Managers
    static var apodNetworkingManager = NetworkingManager<APODModel>(baseURL: "https://api.nasa.gov/")
    static var marsRoverNetworkingManager = NetworkingManager<MarsRoverModel>(baseURL: "https://api.nasa.gov/")
    
    //MARK: API KEYS
    static let nasaApiKey: String = ProcessInfo.processInfo.environment["NASA_API_KEY"] ?? "DEMO_KEY"
    
    //MARK: Images
    static let nasaLogo: UIImage? = UIImage(named: "NasaLogo")
    
    //MARK: Common properties
    static let buttonBackgroundColor: UIColor = .systemBlue
    static let buttonCornerRadius: CGFloat = 10
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    static let defaultFontName: String = "System"
    static let defaultTitleText: String = "Título"
    
    //MARK: MainViewController
    static let MainViewControllerAPODButtonTitle: String = "Foto astronômica do dia"
    static let MainViewControllerMarsRoverButtonTitle: String = "Fotos pelo Mars Rover"
    
    //MARK: APODViewController
    static let APODViewTitle: String = "Foto astronômica do dia"
    static let APODDatePickerLabelText: String = "Selecione uma data:"
    static let APODSearchButtonTitle: String = "Mostrar imagem"
    static let APODImageDescriptionDefaultText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce quis purus sem. Proin ac erat odio. In rutrum bibendum tempor. Etiam ac nisl sapien. Nunc porttitor vehicula tortor, a cursus nunc hendrerit eu. Quisque elit orci, volutpat sed vehicula ac, posuere vel sapien. Morbi faucibus tortor in est viverra fringilla. Aliquam ullamcorper sollicitudin urna auctor commodo. Sed ultricies interdum purus vitae eleifend. Quisque venenatis dolor vitae arcu interdum lacinia. Curabitur ac dui volutpat augue sagittis luctus in quis magna. Vestibulum felis sapien, venenatis sit amet dictum eget, tempus nec sem."
    
    static let APODMinimumDate: String = "1995-06-20"
    
    //MARK: MarsRoverViewController
    static let initialPageNumber: Int = 1
    
    static let marsRoverViewTitle: String = "Fotos pelo Mars Rover"
    static let marsRoverSearchButtonTitle: String = "Filtrar"
    static let marsRoverDatePickerLabelText: String = "Selecione uma data:"
    static let marsRoverSelectCameraLabelText: String = "Selecione a camera:"
    static let marsRoverPageDefaultText: String = "Página \(initialPageNumber)"
    
    static let componentsOfGaleryViewUIPicker: Int = 1
    
    static let allCamerasOption: String = "All"
    static let marsRoverAllCamerasOption: MarsRoverCameraModel = MarsRoverCameraModel(name: Constants.allCamerasOption, full_name: Constants.allCamerasOption)
}
