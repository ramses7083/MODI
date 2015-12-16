//
//  ConnectDB.swift
//  Modi
//
//  Created by Ramses Miramontes Meza on 02/06/15.
//  Copyright (c) 2015 RASOFT. All rights reserved.
//

import UIKit

class ConnectDB: NSObject {
    var databasePath = NSString()
    func consultDB()-> NSString{
        //Generar o comprobar base de datos SQLite
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        
        let docsDir = dirPaths[0] as NSString
        
        databasePath = docsDir.stringByAppendingPathComponent("modi.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let sesionDB = FMDatabase(path: databasePath as String)
            
            if sesionDB == nil {
                print("Error: \(sesionDB.lastErrorMessage())")
            }
            
            if sesionDB.open() {
                // Crear tabla de inicio de sesión
                let sql_stmt = "CREATE TABLE IF NOT EXISTS SESION (ID TEXT PRIMARY KEY, NOMBRE TEXT, FECHA TEXT, SESION TEXT, IMAGEN TEXT, TIPO TEXT, TOKEN TEXT, RESTAURANTID INT, MESA INT, TOTAL REAL)"
                //Para borrar table descomentar la siguiente linea y quitar el signo ! de la condicion filemgr
                //let sql_stmt = "DROP TABLE SESION"
                if !sesionDB.executeStatements(sql_stmt) {
                    print("Error: \(sesionDB.lastErrorMessage())")
                }
                // Crear tabla de inicio de ordenes
                //let sql_stmt2 = "CREATE TABLE IF NOT EXISTS MYORDER (RESTAURANTTAG INTEGER, PRODUCTTAG INTEGER, PRODUCTID INTEGER, COMMENT TEXT)"
                //
                let sql_stmt2 = "CREATE TABLE IF NOT EXISTS MYORDER (ID INTEGER PRIMARY KEY, PRODUCTID INTEGER, PRODUCTNAME TEXT, AMOUNT REAL, COMMENT TEXT)"
                //let sql_stmt2 = "DROP TABLE MYORDER"
                if !sesionDB.executeStatements(sql_stmt2) {
                    print("Error: \(sesionDB.lastErrorMessage())")
                }
                sesionDB.close()
            } else {
                print("Error: \(sesionDB.lastErrorMessage())")
            }
        }
        return databasePath
    }
    
    func checkSession(databasePath: String)->NSArray{
        //Buscar datos de sesion
        let sesionDB = FMDatabase(path: databasePath)
        var datosSesion : NSArray = []
        if sesionDB.open() {
            let querySQL = "SELECT id, nombre, fecha, sesion, imagen, tipo, token, restaurantid, mesa, total FROM SESION"
            
            let results:FMResultSet? = sesionDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            if results?.next() == true {
                print("Sesion encontrada")
                let sesionID = results!.stringForColumn("id")
                let sesionNombre = results!.stringForColumn("nombre")
                let sesionFecha = results!.stringForColumn("fecha")
                let sesionEstatus = results!.boolForColumn("sesion")
                let sesionImagen = results!.stringForColumn("imagen")
                let sesionTipo = results!.stringForColumn("tipo")
                let sesionToken = results!.stringForColumn("token")
                let sesionRestaurantId = results!.stringForColumn("restaurantid")
                let sesionMesa = results!.stringForColumn("mesa")
                let sesionTotal = results!.stringForColumn("total")
                datosSesion = ["\(sesionID)", "\(sesionNombre)", "\(sesionFecha)", "\(sesionEstatus)", "\(sesionImagen)", "\(sesionTipo)", "\(sesionToken)", "\(sesionRestaurantId)","\(sesionMesa)","\(sesionTotal)"]
                print("Valor de Array: id: \(sesionID), nombre: \(sesionNombre),fecha: \(sesionFecha),estatus: \(sesionEstatus), imagen: \(sesionImagen), tipo \(sesionTipo), token \(sesionToken), restaurantid \(sesionRestaurantId), mesa \(sesionMesa), total \(sesionTotal)")
                return datosSesion
                
            } else {
                print("Sesion NO encontrada")
                datosSesion = ["false", "false", "false", "false", "false", "false", "false", "false", "0", "0","0"]
                sesionDB.close()
                return datosSesion
            }
            // Al copiarla en el else anterior ya no se ejecutaria
            //sesionDB.close()
            
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
        //Tenia un "0" recomendado en este return
        return datosSesion
    }
    
    func addSession(databasePath:NSString, id:String, nombre:String, fecha:String, imagen:String, tipo:String, token:String){
        //Agregar sesión en base de datos
        let sesionDB = FMDatabase(path: databasePath as String)
        
        if sesionDB.open() {
            //limpiar tabla
            let deleteSQL = "DELETE FROM 'SESION'"
            var result = sesionDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            //agregar registro
            let insertSQL = "INSERT INTO SESION (id, nombre, fecha, sesion, imagen, tipo, token, restaurantid, mesa, total) VALUES ('\(id)','\(nombre)', '\(fecha)','1','\(imagen)','\(tipo)','\(token)',0,0,0)"
            //Para eliminar una tabla descomentar la siguiente linea
            //let insertSQL = "DROP TABLE SESION"
            
            
            result = sesionDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Failed to add sesion")
                print("Error: \(sesionDB.lastErrorMessage())")
            } else {
                print("Sesion Added")
            }
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
    }
    func updateRestaurant(databasePath:NSString, idRestaurant:Int, idMesa: Int){
        //Agregar sesión en base de datos
        let sesionDB = FMDatabase(path: databasePath as String)
        
        if sesionDB.open() {
            
            //agregar registro
            let insertSQL = "UPDATE SESION SET RESTAURANTID = \(idRestaurant), MESA = \(idMesa)"
            
            let result = sesionDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Failed to update restaurant")
                print("Error: \(sesionDB.lastErrorMessage())")
            } else {
                print("Restaurant actualizado")
            }
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
    }
    
    func closeSession(databasePath:String){
        //Agregar sesión en base de datos
        let sesionDB = FMDatabase(path: databasePath)
        
        if sesionDB.open() {
            //limpiar tabla
            let deleteSQL = "DELETE FROM 'SESION'"
            let result = sesionDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Failed to close sesion")
                print("Error: \(sesionDB.lastErrorMessage())")
            } else {
                print("Sesion Close")
            }
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
        
    }
    
    func addProduct(databasePath:NSString, ProductId:Int, ProductName:String, Amount:Double, Comment:String){
        //Agregar sesión en base de datos
        let sesionDB = FMDatabase(path: databasePath as String)
        
        if sesionDB.open() {
    
            //agregar registro
            let insertSQL = "INSERT INTO MYORDER (PRODUCTID, PRODUCTNAME, AMOUNT, COMMENT) VALUES ('\(ProductId)','\(ProductName)', '\(Amount)', '\(Comment)')"
            
            let result = sesionDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Failed to add product")
                print("Error: \(sesionDB.lastErrorMessage())")
            } else {
                print("Product added")
            }
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
    }
    
    func checkOrder(databasePath: String)->[[String]]{
        //Buscar datos de sesion
        let sesionDB = FMDatabase(path: databasePath)
        //var datosSesion : Array<Array<String>>!
        var datos : [[String]] = []
        if sesionDB.open() {
            let querySQL = "SELECT * FROM MYORDER"
            
            let results:FMResultSet? = sesionDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            var x=0
            while results?.next() == true {
                print("Orden encontrada")
                let Id = results?.stringForColumn("ID")
                let ProductId = results?.stringForColumn("PRODUCTID")
                let ProductName = results?.stringForColumn("PRODUCTNAME")
                let Amount = results?.stringForColumn("AMOUNT")
                let Comment = results?.stringForColumn("COMMENT")
                print("\(Id), \(ProductId), \(ProductName), \(Amount), \(Comment)")
                datos.append([Id!])
                //datos[x].append(Id!)
                datos[x].append(ProductId!)
                datos[x].append(ProductName!)
                datos[x].append(Amount!)
                datos[x].append(Comment!)
                
                //datosSesion[x]=["\(RestaurantTag)", "\(ProductTag)", "\(ProductID)", "\(Comment)"]]
                //print("Valor de Array: ProductId: \(ProductId), ProductName: \(ProductName), Amount: \(Amount), Comment: \(Comment)")
                x+=1
                
            }
            return datos
            
            // Al copiarla en el else anterior ya no se ejecutaria
            //sesionDB.close()
            
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
        //Tenia un "0" recomendado en este return
        return datos
    }
    func deleteProduct(databasePath:NSString, Id:Int){
        //Agregar sesión en base de datos
        let sesionDB = FMDatabase(path: databasePath as String)
        
        if sesionDB.open() {
            
            //agregar registro
            let insertSQL = "DELETE FROM 'MYORDER' WHERE ID = \(Id)"
            
            let result = sesionDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Failed to delete product")
                print("Error: \(sesionDB.lastErrorMessage())")
            } else {
                print("Product deleted")
            }
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
    }
    
    func cleanOrder(databasePath:NSString){
        //Agregar sesión en base de datos
        let sesionDB = FMDatabase(path: databasePath as String)
        
        if sesionDB.open() {
            
            //limpiar tabla
            let deleteSQL = "DELETE FROM 'MYORDER'"
            let result = sesionDB.executeUpdate(deleteSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Failed to clean table")
                print("Error: \(sesionDB.lastErrorMessage())")
            } else {
                print("ORDER table cleaned")
            }
        } else {
            print("Error: \(sesionDB.lastErrorMessage())")
        }
    }
    
    // METODOS MODI CLOUD
    func registerNewUser(username : String, password: String, email: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/accounts/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        let postValues = "username=\(username)&password=\(password)&email=\(email)"
        request.HTTPBody = postValues.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        return request
    }
    func loginModi(username : String, password: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/token-auth/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        let postValues = "username=\(username)&password=\(password)"
        request.HTTPBody = postValues.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func getProfile(token: String) -> JSON {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/app-profiles/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var respuestaServidor : JSON!
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //obtener respuesta del servidor
        let urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            urlData = nil
        }
        respuestaServidor = JSON(data: urlData!, options: [], error: nil)
        return respuestaServidor
    }
    func getPopular(token: String) -> JSON {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/popular-restaurants/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var respuestaServidor : JSON!
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //obtener respuesta del servidor
        let urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            urlData = nil
        }
        respuestaServidor = JSON(data: urlData!, options: [], error: nil)
        return respuestaServidor
    }
    func getCategories(token: String) -> JSON {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/restaurantcategories/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        var respuestaServidor : JSON!
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //obtener respuesta del servidor
        let urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        } catch let error1 as NSError {
            //error = error1
            print(error1)
            urlData = nil
        }
        respuestaServidor = JSON(data: urlData!, options: [], error: nil)
        return respuestaServidor
    }
    func getImage(imgURL: NSURL) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: imgURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func getRestaurantDetails(token: String, id : String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/restaurants/\(id)/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
    func getRestaurantSchedules(token: String, id : String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/horarios/?restaurant=\(id)")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
 
        return request
    }
    func getMenu(token: String, id : String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/menus/?restaurant=\(id)")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func getRestaurantRateByMe(token: String, idRestaurant : String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/rates/?restaurant=\(idRestaurant)")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func sendRestaurantRateByMe(token: String, idRestaurant : String, rate : String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/rates/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "POST"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postValues = "restaurant=http://modi.mx/api/restaurants/\(idRestaurant)/&rating=\(rate)"
        request.HTTPBody = postValues.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return request
    }
    func sendTicket(token: String, idRestaurant : String, Mesa : String, comanda : String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/tickets-app/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "POST"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postValues = "comanda=\(comanda)&restaurant=http://modi.mx/api/restaurants/\(idRestaurant)/&mesa=\(Mesa)"
        print (postValues)
        request.HTTPBody = postValues.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return request
    }
    func getTickets(token: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/tickets-app/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func getProfileData(token: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/user-profile/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "GET"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func sendProfileData(token: String, nombre: String, apellidos: String, email: String, nacimiento: String, genero: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/user-profile/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "POST"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postValues = "first_name=\(nombre)&last_name=\(apellidos)&email=\(email)&birthdate=\(nacimiento)&gender=\(genero)"
        print (postValues)
        request.HTTPBody = postValues.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return request
    }
    func sendPoll(token: String, idRestaurant: Int, ticket: Int, people: Int, process: Int, product: Int, comment: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/polls/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "POST"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print("restaurant=http://modi.mx/api/restaurants/\(idRestaurant)/&ticket=\(ticket)&people_evaluation=\(people)&process_evaluation=\(process)&product_evaluation=\(product)&comment=\(comment)")
        let postValues = "restaurant=http://modi.mx/api/restaurants/\(idRestaurant)/&ticket=\(ticket)&people_evaluation=\(people)&process_evaluation=\(process)&product_evaluation=\(product)&comment=\(comment)"
        print (postValues)
        request.HTTPBody = postValues.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        return request
    }
    func sendNoPoll(token: String, ticket: Int, idRestaurant : Int) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://modi.mx/api/skip-poll/\(ticket)/\(idRestaurant)/")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.HTTPMethod = "POST"
        request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
