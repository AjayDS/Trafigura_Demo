public class eCommerce_SearchProductsDisplay{

public eCommerce_SearchProductsDisplay(eCommerceHomePage controller) {

    }

  public String accountId{get;set;}
    public String priceBookId{get;set;}    
    public String pFamilyName{get;set;}
    public Account_Setting__c aSet{get;set;}
    public String qty{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 5;
    //String array to keep track of the ids of choices  
    public List<String> choices {get;set;}
    public String selectedValue{get;set;}
    
    public List<String> getChoices() {
        return choices ;
    }

    public void setChoices(List<String> choices ) {
        choices.add(selectedValue);
        this.choices = choices ;
    }
    
    List<Product2> prodList = new List<Product2>();
    
   public eCommerce_SearchProductsDisplay(){
        accountId='0013600000N9GoE';//apexpages.currentpage().getparameters().get('accId');
        pFamilyName='Home Theaters';//apexpages.currentpage().getparameters().get('pfn');
        mapLabels = Hard_Coded_Labels__c.getAll();
        aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
        if(aSet.Price_Book__c!=null){
           priceBookId= aSet.Price_Book__c; 
           system.debug('OffsetSize : '+OffsetSize +'LimitSize: '+LimitSize+'totalRecs :'+totalRecs); 
           system.debug('totalRecs:'+totalRecs);       
            prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and Family=:pFamilyName];        
            totalRecs=prodList.size();
            system.debug('totalRecs:'+totalRecs);            
        }
    }
    
    public List<Product2> getSearchedProducts(){
                
        aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
        if(aSet.Price_Book__c!=null){
           priceBookId= aSet.Price_Book__c; 
           system.debug('OffsetSize : '+OffsetSize +'LimitSize: '+LimitSize+'totalRecs :'+totalRecs); 
           system.debug('totalRecs:'+totalRecs);       
            prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and Family=:pFamilyName LIMIT :LimitSize OFFSET:OffsetSize];        
            //totalRecs=prodList.size();
            system.debug('totalRecs:'+totalRecs);            
        }
        return prodList;
    }
    public Pagereference RefinedProducts(){
                system.debug('inside filtered objects:'); 
                system.debug('inside filtered objects:'+getChoices());
        /*aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:accountId and is_Active__c=true limit 1];
        if(aSet.Price_Book__c!=null){
           priceBookId= aSet.Price_Book__c; 
           system.debug('OffsetSize : '+OffsetSize +'LimitSize: '+LimitSize+'totalRecs :'+totalRecs); 
           system.debug('totalRecs:'+totalRecs);       
            prodList=[select id,name,Stock__c,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c,Image__c from Product2 where IsActive=true and Family=:pFamilyName LIMIT :LimitSize OFFSET:OffsetSize];        
            //totalRecs=prodList.size();
            system.debug('totalRecs:'+totalRecs);            
        }*/
        return null;
    }
    
   public void FirstPage()
    {
    OffsetSize = 0;
    }
    public void previous()
    {
    OffsetSize = OffsetSize-LimitSize;
    }public void next()
    {
    OffsetSize = OffsetSize + LimitSize;
    }public void LastPage()
    {
    OffsetSize = totalrecs-math.mod(totalRecs,LimitSize);
    }
    public boolean getprev()
    {
    if(OffsetSize == 0)
    return true;
    else
    return false;
    }
    public boolean getnxt()
    {
    if((OffsetSize + LimitSize) > totalRecs)
    return true;
    else
    return false;
    }
  
//List of select options to populate select boxes  
public List<SelectOption> getList() {  
     List<SelectOption> options = new List<SelectOption>();  
     options.add(new SelectOption('Headphones', 'Headphones'));   
     options.add(new SelectOption('Car Speakers', 'Car Speakers'));
     options.add(new SelectOption('Bluetooth Speakers', 'Bluetooth Speakers'));
     return options;   
} 
     
}