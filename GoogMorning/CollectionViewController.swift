//
//  CollectionViewController.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 26/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, protocoloParseFotos {

    private let reuseIdentifier = "Cell"
    private var objetosFotos = []
    private var parseFotos: ParseFotos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Ajustamos ancho de la celda
        let ancho = CGRectGetWidth(collectionView!.frame)/3
        let layout = collectionViewLayout as UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: ancho, height: ancho*1.5)
        
        
        parseFotos = ParseFotos()
        parseFotos.delegate = self
        self.objetosFotos = parseFotos.arrayFotos
        
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("número de objetosFotos: \(parseFotos.numFotos)")
        return parseFotos.numFotos
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as GoodMorningViewCell
        
        // Descargar la imagen a mostrar
        let buenosDiasActual = objetosFotos[indexPath.row] as PFObject
        let imagenFile = buenosDiasActual["foto"] as PFFile
        imagenFile.getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!)->() in
            if error == nil {
                let imagen = UIImage(data:imageData)
                cell.imagenView.image = imagen
            }
        }
        return cell
    }
    
    func fotosCargadas() {
        if let coleccion = self.collectionView? {
            dispatch_async(dispatch_get_main_queue()) {
                self.objetosFotos = self.parseFotos.arrayFotos
                coleccion.reloadData()
        }
        }
    }
}
