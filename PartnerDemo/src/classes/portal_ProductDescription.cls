public class portal_ProductDescription{
    
    public static String productId{get;set;}
    public Account_Setting__c acSet{get;set;} 
    public PriceBookEntry priceBookObj{get;set;}  
    public User userObj{get;set;}
    public String accId{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public static String selectedPrdId{get;set;}
    
    public portal_ProductDescription(){
        productId = apexpages.Currentpage().getParameters().get('prodid');
        System.debug('-----'+productId);  
        acSet = new Account_Setting__c();
        priceBookObj = new PriceBookEntry();
        userObj = new User();
        
        userObj = Portal_globalClass.u;
        accId =  Portal_globalClass.AccID;        
        acSet = Portal_globalClass.aSet;
        mapLabels = Hard_Coded_Labels__c.getAll();
        if(!String.isBlank(productId)){
            priceBookObj = getProductInfo(productId);
        }

    }
    
    private PriceBookEntry getProductInfo(String prodId){
        PriceBookEntry prodObj = new PriceBookEntry();        
        prodObj = [SELECT Id,ProductCode,UnitPrice,Product2.Description,Product2.Name,Product2.Image__c,Product2.Category__c,Product2.Brand__c,Product2.Stock__c,Product2.isActive,Product2.Family FROM PricebookEntry where priceBook2Id=:acSet.Price_Book__c and product2id=:prodId];
        return prodObj;
    }
    
     public PageReference insertQuantity(){             
        Portal_globalClass globalObj = new Portal_globalClass();
        acSet = Portal_globalClass.aSet;
        System.debug('Ajayyyyy'+selectedPrdId);
        if(selectedPrdId!=''){
             System.debug('Ajayyyyy'+acSet.price_Book__c);
             Portal_globalClass.insertToCart(selectedPrdId,acSet.price_Book__c);
        }
        
        return null;
    }

}