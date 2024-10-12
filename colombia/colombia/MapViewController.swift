//
//  MapViewController.swift
//  colombia
//
//  Created by Developer Wolf on 12/10/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toggleCenteringButton: UIButton!  // Botón para activar/desactivar centrado
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    let locationManager = CLLocationManager()
    
    var hasCenteredMap = false  // Controla si el mapa ya se centró la primera vez
    var isAutoCenteringEnabled = true  // Centrado automático está activado por defecto
    var isFirstLoad = true  // Controla si es la primera vez que cargan los paraderos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar la administración de la ubicación
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Mostrar la ubicación del usuario en el mapa
        mapView.showsUserLocation = true
        
        // Configurar el spinner
        configureSpinner()
        
        // Inicializar el botón con el título correcto
        toggleCenteringButton.setTitle("Desactivar Auto Center", for: .normal)
    }
    
    // Configuración del spinner de carga
    func configureSpinner() {
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
    }

    // Delegado para actualizar la ubicación del usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Controlar si debe centrarse automáticamente el mapa
            if isAutoCenteringEnabled {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
                hasCenteredMap = true  // Indicar que ya se centró el mapa
            }
            
            // Mostrar el spinner solo la primera vez que se cargan los paraderos
            if isFirstLoad {
                spinner.startAnimating()
                isFirstLoad = false
                // Llamar a la API para obtener los paraderos cercanos
                fetchNearbyStops(latitude: 4.609710, longitude: -74.081750)
            }

            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
    
    // Llamada a la API para obtener paraderos cercanos
    func fetchNearbyStops(latitude: Double, longitude: Double) {
        let urlString = "https://sisuotp.tullaveplus.gov.co/otp/routers/default/index/stops?lat=\(latitude)&lon=\(longitude)&radius=1000"
        
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Token si es necesario (puedes quitarlo si no es requerido)
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJjYXJsb3MucGVyZXoiLCJpc3MiOiJyYnNhcy5jbyIsImNvbXBhbnkiOiIxMDEwIiwiZXhwIjoxNzU2MjUxOTAyLCJpYXQiOjE3Mjc0NTE5MDIsIkdydXBvcyI6IltcIlVuaXZlcnNhbFJlY2hhcmdlclwiXSJ9.ZBNTJtOT_bRIUJsiOzveZ7VIaMC0DbU2lIKPIhTrGuJP0kagDStboofVKUQy3MR7cJEaJOIALOjrOeBedcl25Wkh2A56ivHcJuRC0cMIltpsxn6rMAGZpQc6rYHAq_o5gsN1WvlLX0Iv-PBcmvvrySR1CKt-JZH8Vxstx1gKbUWOY0c3kdJefjarxoX9W219Fqaij5teiu2nlayvo6iOeJo7BDbpRAl_wZpK8G7rJ3RXE5ZuUpHd4fPTm2od7r8L8eiWBypgB6wNOZ4Vx9WQwfcsQBc7A-qL9_2mTPyo4OhwLGb61i3gVluBdEh4Fwe-KBQqUrIpbR4Xcr3_T_k6Dw"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.spinner.stopAnimating() // Detener el spinner si ocurre un error
                }
                return
            }
            
            guard let data = data else {
                print("No se recibió data")
                DispatchQueue.main.async {
                    self.spinner.stopAnimating() // Detener el spinner si no hay datos
                }
                return
            }
            
            do {
                // Decodificar los datos
                let stops = try JSONDecoder().decode([Stop].self, from: data)
                print("Paraderos recibidos: \(stops.count)")
                // Mostrar los paraderos en el mapa
                DispatchQueue.main.async {
                    self.addStopsToMap(stops: stops)
                    self.spinner.stopAnimating() // Detener el spinner cuando se carguen los paraderos
                }
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.spinner.stopAnimating() // Detener el spinner si ocurre un error
                }
            }
        }
        
        task.resume()
    }
    
    // Estructura del paradero (Stop)
    struct Stop: Codable {
        let id: String
        let name: String
        let lat: Double
        let lon: Double
    }

    // Añadir los paraderos obtenidos al mapa
    func addStopsToMap(stops: [Stop]) {
        for stop in stops {
            print("Nombre: \(stop.name), Latitud: \(stop.lat), Longitud: \(stop.lon)")
            let annotation = MKPointAnnotation()
            annotation.title = stop.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: stop.lat, longitude: stop.lon)
            mapView.addAnnotation(annotation)
        }
    }

    // Manejar la interacción al tocar los pines
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "stopAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Añadir un botón de información en los pines
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = annotation
        }
        
        // Personalizar el color de los pines (puedes cambiarlo según el tipo)
        annotationView?.pinTintColor = UIColor.blue
        
        return annotationView
    }

    // Acción al tocar el botón de información en el pin
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotationTitle = annotationView.annotation?.title ?? "" {
            let alert = UIAlertController(title: annotationTitle, message: "Información de \(annotationTitle)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // Botón para activar/desactivar el centrado automático
    @IBAction func toggleCentering(_ sender: UIButton) {
        isAutoCenteringEnabled.toggle()  // Cambia el estado del centrado automático
        
        let title = isAutoCenteringEnabled ? "Desactivar Auto Center" : "Activar Auto Center"
        toggleCenteringButton.setTitle(title, for: .normal)
        
        // Si el centrado automático está activado, centrar el mapa inmediatamente
        if isAutoCenteringEnabled, let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}
