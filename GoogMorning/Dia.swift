//
//  Dia.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 13/4/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import Foundation


class Dia {
    
    func getDayOfWeek()->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.NSWeekdayCalendarUnit, fromDate: NSDate())
        let weekDay = myComponents?.weekday
        return weekDay!
    }
    
    func nombreDiaSemanaNumero(numerodia:Int)->String {
        switch numerodia{
        case 1:
            return "domingo"
        case 2:
            return "lunes"
        case 3:
            return "martes"
        case 4:
            return "miércoles"
        case 5:
            return "jueves"
        case 6:
            return "viernes"
        case 7:
            return "sábado"
        default:
            return "error"
        }
    }

    func hoyEsDiaDeNombre()->String {
        return self.nombreDiaSemanaNumero(self.getDayOfWeek())
    }
}