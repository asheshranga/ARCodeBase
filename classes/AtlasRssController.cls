/*********************************************************************************
Name            : AtlasRss
Created By      : Rahul Kumar Sharma
Modified BY     : Rahul Kumar Sharma
Company Name    : NTT Data
Project         : ViaSat Atlas, Bangalore
Created Date    : 21 November 2013
Modified Date   : 28 November 2013
Usages          : Controller to read XML file of RssFeed 
*********************************************************************************/
public class AtlasRssController{
    //Creating a Map Object for referencing the Map of RssBlogInner Class which store the title and Image of Exede Blog
    public Map<String,String> blog=new Map<String,String>();
     
    //Declaring the InnerRssBlog class
    AtlasRssController.RssBlog rssBlogObject;
    
    //This variable is responsible for showing all contents w.r.t to blog 
    public String content{get{return showmsg;}set;}  
    
    
    //To hold Title of Each Feed  
    String title='';
    
     
    //To show overall Content of Feed.Including Title,Link,Content and Image 
    String showmsg='<table>';
    
        
    //To Set the CountLimit for the RssFeed Entries 
    Integer count=1;
    
    
    //This Hardcoded URL is used for Testing Purpose 
     public String URL=AtlasTestConstants.getValue('RSS_FEED_URL');
     
           
     public String toParse;  
    /**
    * @author Rahul Kumar Sharma  
    * @description To Make a CallOut to RssFeed from Zero Parameterized Constructor
    * @input param  - null
    * @return null
    */   
    public AtlasRssController(){
        rssBlogObject=new AtlasRssController.RssBlog(); 
        blog=rssBlogObject.title_Image;  
        if (!Test.isRunningTest()) 
        URL=AtlasUtility.getURL(AtlasConstants.RSS_FEED);    
        HttpRequest  req=new HttpRequest();
        req.setEndpoint(URL); 
        req.setMethod('GET');
        Http h=new Http();
         
        if (!Test.isRunningTest()){   
            HttpResponse res = h.send(req); 
         toParse=res.getBody();}  
         else{toParse=AtlasTestConstants.getMetadata('RSS_CON_RES');}     
        XmlStreamReader reader = new XMLStreamReader(toParse.trim());   
        //Reading the XML file
        while(reader.hasNext()){
            //To Check Whether Limit has reached to Five or Less   
            if(count<=5){           
                
                //To Fetch the Title
                if(reader.getEventType()==XmlTag.START_ELEMENT && reader.getLocalName()=='title'){
                    reader.next();
                    if(reader.getEventType()==XmlTag.CHARACTERS)
                    title=reader.getText();
                    if(count==1 && title.contains('Exede'))title='';
                }
                
                //To Fetch the Link
                else if(reader.getEventType()==XmlTag.START_ELEMENT && reader.getLocalName()=='link'){
                    reader.next();
                    if(reader.getEventType()==XmlTag.CHARACTERS){
                      
                    showmsg+='<tr><td width=100%><strong><a style="font-size:18px" target="_blank" href="'+reader.getText()+'">'+title+'</a></strong></td></tr>'; 
                     }
                }
                
                //To Fetch the Content of Feed Includes Content and Image  
                else if(reader.getEventType()==XmlTag.START_ELEMENT && reader.getLocalName()=='encoded'){
                    reader.next();
                    
                    if(reader.getEventType()==XmlTag.CHARACTERS){
                        String Div='';  //To Store <div></div> tag which contain Image and Other Stuff for Each Feed.
                        String ImageLink='';//To Store ImageLink <img> which is under <div></div> tag. 
                        String ContentMSG='';//To Store the Content of Each Feed.
                        String finalMsg=''; //To Store the Combination of Div or ImageLink and Content.   
                        String temp=reader.getText();
                        
                        
                            if(blog.size()>0 && blog.containsKey('title="'+title+'"')){ 
                                for(String objImg:blog.keySet()){   
                                    if(objImg=='title="'+title.trim()+'"'){  
                                   
                                    ImageLink=blog.get('title="'+title+'"'); 
                             
                              
                                    }
                            }
                            }
                            else{ 
                                Integer startIndex=temp.indexOf('<div');
                                Integer endIndex=temp.indexOf('v>');  
                        
                                //To Check Whether div got encountered or not.
                                if(startIndex!= -1 && endIndex != -1){ 
                                Div=temp.substring(startIndex,endIndex+2); //Extracting the div
                                Integer startImageIndex=Div.indexOf('<img');
                                Integer endImageIndex=Div.indexOf('/>');  
                            
                                if(startImageIndex != -1 &&  endImageIndex!= -1){
                                ImageLink=Div.substring(startImageIndex,endImageIndex+2);//Extracting the img 
                                
                                Pattern dimension=Pattern.compile('width=\\"([0-9])*\\" height=\\"([0-9])*\\" '); 
                                Matcher m=dimension.matcher(ImageLink);
                                String newDimension='width="100" height="100" ';
                                try{
                                if(m.find()){
                                String oldDimension=m.group();
    
                                ImageLink=ImageLink.replace(oldDimension,newDimension); 
    
                                    }
                                }
                                catch(Exception e){}
                                
                                  
                                    }
                                    
                                }
                            } 

                            
                        
                        
                        //Find the Starting and Ending Index of Paragraph.
                        Integer startContentIndex=temp.indexOf('<p');
                        Integer endContentIndex=temp.indexOf('/p>');
                        
                        if(startContentIndex!= -1 && endContentIndex != -1){
                            ContentMSG=temp.substring(startContentIndex,endContentIndex+3); //Extracting the Paragraph 
                            
                        }
                        //To Check Current RssFeed Contains Image or Not 
                        if(ImageLink!=''){       
                            finalMsg='<tr><td width=80% valign="Top">'+ContentMSG+'</td><td width=10%></td><td width=10%>'+ImageLink+'</td></tr>';}               
                        else{
                            finalMsg='<tr><td width=100%>'+ContentMSG+'</td></tr>';}            
                        showmsg+=finalMsg;//Adding all Content related to particular feed into Showmsg; 
                         
                        count++; //Increase the CountLimit 
                    }
                }             
                
                
                
            }  
             
            reader.next();
        }
         showmsg+='</table>';     
    }
    //Starting of Inner Class RssBlog
    public class RssBlog{

    public String title_Rss;
    public String image_Rss;
       
    public Map<String,String> title_Image=new Map<String,String>();
    
    public RssBlog(){
    String blogRes=callOutResponse(AtlasConstants.BLOG_URL);       
    findImage(blogRes);
    }
    /**
    * @author Rahul Kr Sharma
    * @description - calloutResponse, taking an input parameter of type String URL
    * @input param  - String URL
    * @return param String
    */  
    public String callOutResponse(String URL){
    String xmlresponse;
    
    try{
        HttpRequest  req = new HttpRequest();
        req.setEndpoint(URL); 
        req.setMethod('GET');
        Http h = new Http();
        
            if (!Test.isRunningTest()){
            HttpResponse res = h.send(req); 
            xmlresponse=res.getBody();
            return xmlresponse;
            }
            else{
            xmlresponse=AtlasTestConstants.getMetadata('RSS_BLOG_RES');  
            return xmlresponse;
            }
    }  //End of Try Block
    catch(Exception e){return e.getMessage();}
    }
    /**
    * @author Rahul Kr Sharma
    * @description - findImage from httpcallout response, taking an input parameter of type String response
    * @input param  - String response
    * @return param void
    */  
    public void findImage(String response){
        try{
            if(response!=null){
                Pattern articleContents= Pattern.compile('<article class=\\"(.+?)\\">');
                Pattern title = Pattern.compile('title=\\"(.+?)\\"');
                Pattern image=Pattern.compile('<img ');
                Matcher m = articleContents.matcher(response);
            
                //Outer While loop
                    while (m.find()){
                                 String temp_article=response.substring(m.start());
                                 Integer index_end_article=temp_article.indexOf('</article>');
                                 String article=response.substring(m.start(),m.start()+index_end_article);   
                                 
                    
                    Matcher m1 = title.matcher(article);
                    Matcher m2=image.matcher(article);
                                 
                             //first Inner Loop for finding corrosponding Title Tag
                             while(m1.find()){
                                 title_Rss=m1.group();
                                 
                                 break;
                             }//End of first Inner Loop
              
                             //second Inner Loop for finding corrosponding Image Tag    
                             while(m2.find()){
                                 String temp=article.substring(m2.start());
                                 Integer index=temp.indexOf('>');
                                 index++;
                                 image_Rss=article.substring(m2.start(),m2.start()+index);
                                 
                                 changeDimension(image_Rss); 
                                 break;
                             }//End of second Inner Loop
                             
                             //put Image and Title in Map.
             title_Image.put(title_Rss,image_Rss);

            }//End of Outer Loop
        }//End of If block 
    }//End of try block 
        
        catch(Exception e){} 
            
    }//End of findImage()
    /**
    * @author Rahul Kr Sharma
    * @description - changeDimension, taking an input parameter of type String str
    * @input param  - String str
    * @return param void
    */  
    public void changeDimension(String str)
    {
    Pattern dimension=Pattern.compile('width=\\"([0-9])*\\" height=\\"([0-9])*\\" '); 
    Matcher m=dimension.matcher(str);
    String newDimension='width="100" height="100" ';
    try{
    if(m.find()){
    String oldDimension=m.group();
    
    image_Rss=str.replace(oldDimension,newDimension);
    
    }
    }
    catch(StringException e){}
}
    

}//End of Inner Class 
    
    
}