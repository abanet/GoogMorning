//
//  DetailViewController.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 27/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import UIKit
import ParseUI
//import GoogleMobileAds

class DetailViewController: UIViewController, protocoloParseFrases { // , GADBannerViewDelegate

    @IBOutlet var viewFotoBuenosDias: UIImageView!
    @IBOutlet var frase: UILabel!
    @IBOutlet weak var btnCompartir: UIBarButtonItem!
    //@IBOutlet var bannerView: GADBannerView!
    
    //@IBOutlet var bannerViewBottonSpaceConstrain: NSLayoutConstraint!
    
    var fotoSegue: PFObject?
    private var parseFrases: ParseFrases!
    private var animacionMarcha: Bool!
    private var siguienteAnimacionTextoOn: Bool!
    private var autorFrase: String?
    
    
    override func viewDidLoad() {
        parseFrases = ParseFrases()
        parseFrases.delegate = self
        animacionMarcha = false
        siguienteAnimacionTextoOn = true
        self.frase.text = ""
        
        // Publicidad
        // TODO: el id es el de raywenderlich
//        bannerView.adUnitID = "ca-app-pub-3455028088714350/4838990629"
//        bannerView.delegate = self
//        bannerView.rootViewController = self
//        bannerView.loadRequest(GADRequest())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        self.btnCompartir.enabled = false
        self.frase.alpha = 0
        self.viewFotoBuenosDias.alpha = 0
        
        if let objetoSegue = fotoSegue {
           // frase.text = objetoSegue["fraseEng"] as String!
            
            // 1.- Carga de imagen como PFFile
//            let imagenPFFile = objetoSegue["foto"] as! PFFile
//            imagenPFFile.getDataInBackgroundWithBlock {
//                (imageData: NSData!, error: NSError!)->() in
//                if error == nil {
//                    if let imagen = UIImage(data:imageData) {
//                         self.viewFotoBuenosDias.image = imagen
//                        
//                    }
//                }
//            }
            // 2.- Carga de imágen como PFImageView().- Realiza caché local en móvil.
            let imagenView = PFImageView()
            imagenView.image = UIImage(named: objetoSegue.objectId)
            let imagenFile: PFFile = objetoSegue.objectForKey("foto") as! PFFile
            imagenView.file = imagenFile
            imagenView.loadInBackground {(imagen: UIImage!, error: NSError!)->Void in
                if error == nil {
                    self.viewFotoBuenosDias.image = imagen
                }
            }

        }
        
}
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    // Compartir imagen y frase con las redes sociales
    @IBAction func compartirRedesSociales(sender: AnyObject) {
        
        let wsActivity = MMMWhatsAppActivity() // actividad de whatsapp
        
        let fraseYautor: String = self.frase.text! + " [\(autorFrase!)]"
        let objetosACompartir: [AnyObject!] = [fraseYautor, self.viewFotoBuenosDias.image, NSURL(string: NSLocalizedString("appURL", comment:"url de la app en el applestore"))]
        let activityController = UIActivityViewController(activityItems: objetosACompartir, applicationActivities: [wsActivity])
        activityController.excludedActivityTypes =  [
            UIActivityTypePostToWeibo,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList]
        self.presentViewController(activityController, animated: true, completion: nil)    }
    
    
    func animarTextoDurante(segundos: NSTimeInterval, delay: NSTimeInterval, alfaFinal: CGFloat){
        self.animacionMarcha = true
        UIView.animateWithDuration(segundos, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.frase.alpha = alfaFinal
            }, completion: {(completed: Bool) in
                if(completed){
                    self.animacionMarcha = false
                }
                return
        })
    }
    
    func animarImagenDurante(segundos: NSTimeInterval, delay: NSTimeInterval, alfaFinal: CGFloat){
        self.animacionMarcha = true
        UIView.animateWithDuration(segundos, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.viewFotoBuenosDias.alpha = alfaFinal
            }, completion: {(completed: Bool) in
                if(completed){
                    self.animacionMarcha = false
                }
                return
        })
    }
    
    // Se han cargado las frases. Elegimos una y la mostramos.
    func frasesCargadas() {
        //let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        //blur.frame = view.frame
        //view.addSubview(blur)
        (self.frase.text, autorFrase) = parseFrases.escogerUnaFraseAlAzar()
        
        // Cuando ya tenemos la frase ya podemos compartir.
        self.btnCompartir.enabled = true
        
        animarTextoDurante(3.0, delay:0.0, alfaFinal: 1.0)
        animarImagenDurante(3.0, delay: 3.0, alfaFinal: 1.0)
        animarTextoDurante(3.0, delay: 3.0, alfaFinal: 0.0)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!self.animacionMarcha){
            if(!self.siguienteAnimacionTextoOn){
                animarTextoDurante(3.0, delay: 0.0 , alfaFinal: 0.0)
                animarImagenDurante(3.0, delay: 0.0, alfaFinal: 1.0)
            } else {
                animarTextoDurante(3.0, delay: 0.0 , alfaFinal: 1.0)
                animarImagenDurante(3.0, delay: 0.0, alfaFinal: 0.0)
            }
            siguienteAnimacionTextoOn = !siguienteAnimacionTextoOn
        }
    }
    
    // MARK: AdGoogle
//    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
//        if bannerViewBottonSpaceConstrain.constant == 0 {
//            UIView.animateWithDuration(0.25, animations: { () -> Void in
//                self.bannerViewBottonSpaceConstrain.constant = -CGRectGetHeight(self.bannerView.bounds)
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
//    
//    
//    func adViewDidReceiveAd(view: GADBannerView!) {
//        if bannerViewBottonSpaceConstrain.constant != 0 {
//            UIView.animateWithDuration(0.25, animations: { ()->Void in
//                self.bannerViewBottonSpaceConstrain.constant = 0
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
    
    
    
   }
