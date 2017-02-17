public class Portal_ProductsDisplay{

    public String accountId{get;set;}
    public String priceBookId{get;set;}    
    public String pFamilyName{get;set;}
    public Account_Setting__c aSet{get;set;}
    public String qty{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    
     
    public Portal_ProductsDisplay(){
        accountId=apexpages.currentpage().getparameters().get('accId');
        pFamilyName=apexpages.currentpage().getparameters().get('pfn');
        mapLabels = Hard_Coded_Labels__c.getAll();
    }
    
    public List<Product2> getCurrentProducts(){
        List<Product2> prodList = new List<Product2>(); 
            System.debug('-----'+accountId+pFamilyName);
        try{       
            aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
            if(aSet.Price_Book__c!=null){
                priceBookId= aSet.Price_Book__c;        
                prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and Family=:pFamilyName];        
            }
        }Catch(Exception e){
            System.debug('-----'+e.getMessage());
        }        
        return prodList;
    }
    
    
    

}