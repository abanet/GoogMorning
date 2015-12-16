//
//  CollectionViewController.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 26/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

// TODO:
// La caché de las imágenes hacen que la app ocupe cada vez más espacio. ¿Cómo corregir esto?

import UIKit
import ParseUI

class CollectionViewController: UICollectionViewController, protocoloParseFotos {

    private let reuseIdentifier = "Cell"
    private var objetosFotos = []
    private var parseFotos: ParseFotos!
    private var listaFotos: [UIImage] = []
    private var diaActual: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Ajustamos ancho de la celda
        let ancho = CGRectGetWidth(collectionView!.frame)/3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: ancho, height: ancho*1.5)
        
        // Ponemos el título
        self.navigationItem.title = NSLocalizedString("Elige cómo dar los buenos días!", comment: "Título del navigation controller en el collection view controller.")
        
        // Día actual
        let dia = Dia()
        diaActual = dia.hoyEsDiaDeNombre() //día del nombre actual
        
        // Cargar las fotografías del día actual
        parseFotos = ParseFotos()
        parseFotos.delegate = self
        self.objetosFotos = parseFotos.arrayFotos
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Oculto la barra de herrientas al mostrar esta pantalla
        self.navigationController?.setToolbarHidden(true, animated: true)
        // Si ha cambiado de día hay que volver a cargar las fotografías
        let dia = Dia()
        if dia.hoyEsDiaDeNombre() != diaActual {
            parseFotos = ParseFotos()
            parseFotos.delegate = self
            self.objetosFotos = parseFotos.arrayFotos
            self.diaActual = dia.hoyEsDiaDeNombre()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Al irnos volvemos a mostrar la barra de herramientas
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("número de objetosFotos: \(parseFotos.numFotos)")
        return parseFotos.numFotos
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)as! GoodMorningViewCell
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Descargar la imagen a mostrar
        let buenosDiasActual = objetosFotos[indexPath.row] as! PFObject
        
        // 1.- Cargamos imágenes como PFFile
//        let imagenFile = buenosDiasActual["foto"] as! PFFile
//        imagenFile.getDataInBackgroundWithBlock {
//            (imageData: NSData!, error: NSError!)->() in
//            if error == nil {
//                if let imagen = UIImage(data:imageData) {
//                    cell.imagenView.image = imagen
//                }
//            }
//        }
        
        // 2.- Cargamos imágenes como PFImageView()
        let imagenView = PFImageView()
        imagenView.image = UIImage(named: buenosDiasActual.objectId)
        
        let imagenFile: PFFile = buenosDiasActual.objectForKey("foto") as! PFFile
        imagenView.file = imagenFile
        imagenView.loadInBackground {(imagen: UIImage!, error: NSError!)->Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                 cell.imagenView.image = imagen
                }
                }
        }
        return cell
    }
    
    func fotosCargadas() {
        if let coleccion = self.collectionView {
                self.objetosFotos = self.parseFotos.arrayFotos
                coleccion.reloadData()
        }
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let buenosDiasActual = objetosFotos[indexPath.row] as? PFObject {
            performSegueWithIdentifier("MasterToDetail", sender: buenosDiasActual)
        }
        }
    
    // MARK: Preparando Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.fotoSegue = sender as? PFObject
        }
    }
}
