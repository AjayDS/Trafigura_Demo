public with sharing class prosearchcontroller2 { 
   
   public prosearchcontroller2(portal_menuCls controller) {}
   public String accountId{get;set;}
   public static Account_Setting__c aSet{get;set;}
   public List <Product2> pro {get;set;}  
   public string search {get;set;}   
   public String priceBookId{get;set;}
   public string searchText {get;set;}   
   public static String selectedPrdId{get;set;}
   
    public prosearchcontroller2() { 
        getSearchResults();                                   
       }
     
    public String getsearchText()
    {return 'searchText';}
    public void setsearchText(String searchText)
    {
        this.searchText = searchText;
        system.debug('***1'+searchtext);
    }   
    
   /*public PageReference search(){  
      String searchText = Apexpages.currentPage().getParameters().get('searchText');
      system.debug('@@@@@4'+searchText);
      system.debug('@@@@@5'+search);
      //getSearchResults();
       return null;
   }*/
   
   public PageReference getSearchResults(){
       pro= new List<Product2>();
           accountId='0013600000SAesPAAT';
           String searchText = Apexpages.currentPage().getParameters().get('searchText');
            //searchText='jbl';
           system.debug('accountId------------------:'+accountId+searchText);
           system.debug('searchstring in search method:'+searchText );
           if(searchText!=null && searchText !=''){
            aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
             if(aSet.Price_Book__c!=null){
                  priceBookId= aSet.Price_Book__c;               
                 //string search='SELECT Id,name,ProductCode,UnitPrice,Product2.Description,Product2.Name,Product2.Image__c,product2.Price__c,Product2.Category__c,Product2.Brand__c,Product2.Stock__c,Product2.isActive,Product2.Family FROM PricebookEntry where  product2.name=JBL Horizon limit 4 ';
                 string searchQuery='select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and product2.name like \'%'+searchText +'%\' Limit 20';//searchText 
                 system.debug('searchQuery:'+searchQuery);   
                 pro= Database.query(searchQuery);
                 system.debug('#####5'+pro); 
                 if(pro.size()<=0)
                   {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Records are found'));
                        return null; 
                        
                    }
                   
                           
               }
           }  
          
             
             else        
               {
               system.debug('NOT FOUND');
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Enter searchstring'));
                return null;

               }
          
           return null;
   }
   
       public static PageReference insertQuantity(){ 
        aSet= new Account_Setting__c ();       
        Portal_globalClass globalObj = new Portal_globalClass();
        aSet= Portal_globalClass.aSet;
        System.debug('Ajayyyyy'+selectedPrdId);
        if(selectedPrdId!=''){
             System.debug('Ajayyyyy'+aSet.price_Book__c);
             Portal_globalClass.insertToCart(selectedPrdId,aSet.price_Book__c);
        }
        
        return null;
    }
      
 }