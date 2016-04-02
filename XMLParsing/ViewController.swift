//
//  ViewController.swift
//  XMLParsing
//
//  Created by Naga Praveen Kumar Pendyala on 2/8/16.
//  Copyright (c) 2016 Naga Praveen Kumar Pendyala. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, NSXMLParserDelegate {
    
    //create an array of data objects of type entry
    var objects = [Entry]()
    
    // create an instance of ImageProvider class to download the images
    let imageProvider = ImageProvider()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start an NSURL Shared Session
        
        let session = NSURLSession.sharedSession()
        
        //set the url for the XML file
        if let url = NSURL(string: "https://itunes.apple.com/us/rss/toptvepisodes/limit=25/genre=4008/xml" )
        {
            
            //weak var weakSelf = self
            
            let task = session.dataTaskWithURL(url){
                (data, response, error) in
                
                //check for unexpected status codes
                
                let httpResponse = response as? NSHTTPURLResponse
                
                if httpResponse!.statusCode == 500 {
                    
                    let alert = UIAlertView(title: "Error", message: "Internal Server Error", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    return
                    
                    
                } else if (data == nil && error != nil){
                    
                    let alert = UIAlertView(title: "Error", message: "No data found", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    return
                    
                } else {
                    //parse the XML data
                    
                    let parser = NSXMLParser(data: data)
                    
                    parser.delegate = self
                    
                    if !parser.parse(){
                        
                        println("Error: XML data not parsed")
                        
                    } else {
                        
                        //call the main queue update the table View
                        dispatch_async(dispatch_get_main_queue()){
                            
                            self.tableView.reloadData()
                        }
                        
                        println("XML data parsed")
                        
                    }

                }
                
            }
            
            task.resume()

            
                    }
        else
        {
            let alert = UIAlertView(title: "Error", message: "Unable to download XML data", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
    // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var text = ""
    var found = "No"
    var felement = "No"
    var otitle = ""
    var osummary = ""
    var oimage = ""
    
    
    func parser(parser: NSXMLParser, foundCharacters: String?) {
        //append the strings found between elements' open and closing tags
        if (felement == "Yes" && found == "Yes")
        {
            text = text+foundCharacters!
        }

    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        if elementName == "entry" {
            //mark that the entry tag is started
            found = "Yes"
        }
        if found == "Yes"{
        
            //mark that the required element is started
            if elementName == "title" || elementName == "summary" || elementName == "im:image"{
                felement = "Yes"
        }
        
        }
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
            if found == "Yes"
            {
                //read the corresponding set of element values
                if elementName == "title" {
                    felement = "No"
                    otitle = text
                    
                }
                else if elementName == "summary" {
                    osummary = text
                }
                else if elementName == "im:image" {
                    felement = "No"
                    oimage = text
                }
                
                text = ""
            }
        //create an entry object with the collected values once the entry is closed
        if elementName == "entry"{
            
            self.objects.append(Entry(title: otitle,summary: osummary,image: oimage))
            
            //reset to look for next entry object
            found = "No"
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! XMLCell
        
        //set the object to the table view cell
        let object = objects[indexPath.row]
        cell.XMLentry = object
        
        imageProvider.imageWithName(object.image){
            (image: UIImage) in
            
            //set the thumbnail images in the table view
            
            cell.episodeImageView.image = image
            
        }
        
        return cell
    }

}

