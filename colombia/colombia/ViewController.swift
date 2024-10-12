//
//  ViewController.swift
//  colombia
//
//  Created by Developer Wolf on 12/10/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // Arreglo para almacenar las tarjetas
    var cards: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cargar las tarjetas guardadas
        loadCards()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func btnMapa(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
                present(mapVC, animated: true, completion: nil)
            }
    }
   
    
    // Acción del botón para agregar la tarjeta
    @IBAction func addCard(_ sender: UIButton) {
        if let cardNumber = cardNumberTextField.text, !cardNumber.isEmpty {
            // Agregar el número de tarjeta al arreglo
            cards.append(cardNumber)
            tableView.reloadData()  // Recargar la tabla
            cardNumberTextField.text = ""  // Limpiar el campo de texto
            // Guardar las tarjetas en UserDefaults
            saveCards()
        } else {
            // Mostrar alerta si el campo está vacío
            let alert = UIAlertController(title: "Error", message: "Por favor ingresa un número de tarjeta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Métodos de UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reutilizar la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        // Asignar el número de tarjeta a la etiqueta de la celda
        cell.cardNumberLabel.text = cards[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveCards()  // Guardar las tarjetas después de eliminar
        }
    }
    
    func saveCards() {
        UserDefaults.standard.set(cards, forKey: "savedCards")
    }

    func loadCards() {
        if let savedCards = UserDefaults.standard.array(forKey: "savedCards") as? [String] {
            cards = savedCards
        }
    }
    
}

