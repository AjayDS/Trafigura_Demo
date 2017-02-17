public class portal_AccountSettings {

    public Account_Setting__c accountSettings {get;set;}
    public String copyRight{get;set;}
    public Decimal categoryLimit {get;set;}
    public String imageUrl{get;set;}
    public Decimal itemsPerPage{get;set;}
    public Decimal taxRate{get;set;}    
    public String topEmail{get;set;}
    public String topPhone{get;set;}
    public String userIconOptions{get;set;}
    
    public portal_AccountSettings(){
        accountSettings= new Account_Setting__c();
        accountSettings=[SELECT Account__c,Brands__c,Categories__c,Category_Limit__c,Copyright_Text__c,CreatedById,CreatedDate,CurrencyIsoCode,Footer_Links__c,Id,Image_URL__c,IsDeleted,is_Active__c,Language__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,No_of_Items_Per_Page__c,Price_Book__c,Social_Media__c,SystemModstamp,Tax_Rate__c,Theme__c,Top_Email__c,Top_Phone__c,User_Icon_Options__c FROM Account_Setting__c WHERE Account__c = '0013600000SAesPAAT'];
        copyRight=accountSettings.Copyright_Text__c;
        categoryLimit =accountSettings.Category_Limit__c;
        imageUrl=accountSettings.Image_URL__c;
        itemsPerPage=accountSettings.No_of_Items_Per_Page__c;
        taxRate=accountSettings.Tax_Rate__c;
        topEmail=accountSettings.Top_Email__c;      
        topPhone=accountSettings.Top_Phone__c;
        userIconOptions=accountSettings.User_Icon_Options__c;
    }

    public PageReference save() {
        Account_Setting__c accountSettings1= new Account_Setting__c();
        accountSettings1=[SELECT Account__c,Brands__c,Categories__c,Category_Limit__c,Copyright_Text__c,CreatedById,CreatedDate,CurrencyIsoCode,Footer_Links__c,Id,Image_URL__c,IsDeleted,is_Active__c,Language__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,No_of_Items_Per_Page__c,Price_Book__c,Social_Media__c,SystemModstamp,Tax_Rate__c,Theme__c,Top_Email__c,Top_Phone__c,User_Icon_Options__c FROM Account_Setting__c WHERE Account__c = '0013600000SAesPAAT'];
        accountSettings1.Copyright_Text__c=copyRight;
        accountSettings1.Category_Limit__c=categoryLimit ;
        imageUrl=accountSettings1.Image_URL__c;
        itemsPerPage=accountSettings1.No_of_Items_Per_Page__c;
        taxRate=accountSettings1.Tax_Rate__c;
        topEmail=accountSettings1.Top_Email__c;      
        topPhone=accountSettings1.Top_Phone__c;
        userIconOptions=accountSettings1.User_Icon_Options__c;
        
        return null;
    }  
    
   
}