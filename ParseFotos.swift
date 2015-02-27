//
//  ParseFotos.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 26/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import UIKit

protocol protocoloParseFotos
{
     func fotosCargadas()
}

class ParseFotos {
    
    var arrayFotos: [PFObject] = []
    var numFotos: Int {
        get {
            return arrayFotos.count
        }
    }
    var delegate:protocoloParseFotos?
    
    init (){
        cargarFotos()
    }
    
    // Cargamos la tabla de fotos
    // De momento cargamos todas. Después habrá que parametrizar para cargar las de un día, o un año, etc
    func cargarFotos() {
        var query = PFQuery(className:"GoodMorning");
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!)->() in
            
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
                    self.arrayFotos.append(object as PFObject)
                }
                self.delegate?.fotosCargadas()
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        
        }
        
    }
    
    func goodMorningForIndexPath(indexPath: NSIndexPath) -> PFObject {
        return arrayFotos[indexPath.row]
    }
    
}
