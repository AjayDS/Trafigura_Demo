public with sharing class vfListPaginationController {

private Static Final Integer PAGE_NUMBER = 10;

public String accountId{get;set;}
    public String priceBookId{get;set;}    
    public String pFamilyName{get;set;}
    public Account_Setting__c aSet{get;set;}
    public String qty{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
   
 //Keeps track of current page & max size of article list
 Integer currentPage = 1;
 Integer maxSize = 1;
 
 public vfListPaginationController () { 
         accountId='0013600000N9GoE';//apexpages.currentpage().getparameters().get('accId');
        pFamilyName='Home Theaters';//apexpages.currentpage().getparameters().get('pfn');
        mapLabels = Hard_Coded_Labels__c.getAll();          
 }
 
 public List<Product2> getSearchedProducts(){
        List<Product2> prodList = new List<Product2>();        
        aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
        if(aSet.Price_Book__c!=null){
            priceBookId= aSet.Price_Book__c; 
            system.debug('priceBookId:'+priceBookId);       
            prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true];        
            maxSize =prodList.size();
            system.debug('maxSize :'+maxSize );
        }
        return prodList;
    }
 // Returns whether we need to see previous button or not
 public boolean getPrevRequired() {
     system.debug('currentPage getPrevRequired:'+currentPage );
     getCurrentPageNumber();
  return currentPage > 1;
 }
 // Returns whether we need to see next button or not
 public boolean getNextRequired() {
 system.debug('currentPage getNextRequired:'+currentPage * PAGE_NUMBER);
 getCurrentPageNumber();
  return currentPage * PAGE_NUMBER < maxSize;
 }
 //Returns current page number
 public Decimal getCurrentPageNumber() {
 system.debug('currentPage getCurrentPageNumber:'+currentPage );
 //getCurrentPageNumber();
  return this.currentPage;
 }
 //action for next click
 public PageReference next() {
 system.debug('currentPage next:'+currentPage );
 system.debug('maxSize  next:'+maxSize );
  if(maxSize > this.currentPage * PAGE_NUMBER) {
  system.debug('inside if loop'+this.currentPage * PAGE_NUMBER);
   this.currentPage = this.currentPage + 1;
   getCurrentPageNumber();
  }
  return null;
 }   
 //action for previous click
 public PageReference previous() { 
 system.debug('currentPage previous:'+currentPage );      
  if(this.currentPage > 1)
   this.currentPage = this.currentPage - 1;
   getCurrentPageNumber();
  return null;
 }

}