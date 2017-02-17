public with sharing class soql_offset_example {

   private integer counter=0;  //keeps track of the offset
   private integer list_size=5; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   
   public String accountId{get;set;}
    public String priceBookId{get;set;}    
    public String pFamilyName{get;set;}
    public Account_Setting__c aSet{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    List<Product2> prodList = new List<Product2>(); 

   public soql_offset_example() {
   //total_size = [select count() from Number__c]; //set the total size in the constructor
    accountId='0013600000N9GoE';//apexpages.currentpage().getparameters().get('accId');
        pFamilyName='Home Theaters';//apexpages.currentpage().getparameters().get('pfn');
        mapLabels = Hard_Coded_Labels__c.getAll();
        aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
        if(aSet.Price_Book__c!=null){
           priceBookId= aSet.Price_Book__c; 
           system.debug('list_size : '+list_size+'counter: '+counter+'total_size:'+total_size); 
           //system.debug('totalRecs:'+totalRecs);       
            prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and Family=:pFamilyName];        
              total_size =prodList.size();
            system.debug('totalRecs:'+total_size);
            
            }
   }

   public Product2[] getProducts() {
      try {
                
        aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
        if(aSet.Price_Book__c!=null){
           priceBookId= aSet.Price_Book__c; 
           system.debug('list_size : '+list_size+'counter: '+counter+'total_size:'+total_size); 
           //system.debug('totalRecs:'+totalRecs);       
            prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and Family=:pFamilyName LIMIT :list_size OFFSET:counter];        
           // total_size =prodList.size();
            //system.debug('totalRecs:'+totalRecs);
            
            }
            return prodList;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
   }

   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {
      return counter/list_size + 1;
   }

   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
}