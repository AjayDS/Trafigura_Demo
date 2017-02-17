public class Portal_HomePage{

    public static String partnerName{get;set;}
    public static User u{get;set;}
    public String jsonString {get;set;}

    public Map<String,Account> accIdMap;
    public Account accGlobalObj{get;set;}  
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public List<Shopping_Cart__c> cartList{get;set;}
    
    ECommerce_CofigurableClass ecomAccConfig = new ECommerce_CofigurableClass();
    public String partnerLogoURL{get;set;}
    public String partnerTheme{get;set;}
    public String resourcePath{get;set;}
    public Account_Setting__c aSet{get;set;}
    public List<String> footerLink{get;set;}
    public String linkHeader{get;set;}    
    public Map<Integer,Map<String,List<String>>> tabMenus{get;set;}
    
    public List<String> iconOptionsOnHeader{get;set;}
    public class listJSONWrapper{
        public string thumb{get;set;}
        public string name{get;set;}
        public string price{get;set;}
        public string quantity{get;set;}
        public String prodId{get;set;}
        //public string total{get;set;}
        public listJSONWrapper(string img,string name,string price,string quantity,string prodId){
            this.thumb=img;
            this.name=name;
            this.price=price;
            this.quantity=quantity;
            this.prodId=prodId;                     
        }   
        
    }
    public String selectedLang{get;set;}
    public String langTypes{get;set;}
    
    public list<listJSONWrapper> wrapJSONList { get; set; }
    public ID AccID{get;set;}
    
    //testing purpose for System Admin
    public void setAccountinfo(){
        
        for(Account accObj:[select id,Name,card_Types__c,Payment_Types__c from Account where name=:partnerName limit 1]){
            accIdMap.put(accObj.Name,accObj);
            accGlobalObj=accObj;
        }
    }
    
    public Portal_HomePage(){                   
        accIdMap = new Map<String,Account>();        
        accGlobalObj= new Account();
        aSet = new Account_Setting__c();
        
        u = new User();
        wrapJSONList = new list<listJSONWrapper>();
        
        
        u = [select Id,username,contactid,FirstName,LastName from User where Id = :UserInfo.getUserId()];
        apexpages.currentpage().getparameters().put('sessionId',u.Id);    
                
            String networkId = Network.getNetworkId();
            try{
                
                if(u.lastName=='Guest User' || networkId==null){
                    partnerName='Guest User';
                    system.debug('networkId'+networkId);
                    setAccountinfo();
                    AccID=accIdMap.get(partnerName).Id;
                    system.debug('++++'+AccID);
                    accGlobalObj = accIdMap.get(partnerName); 
                    
                }else{
                     system.debug('ELSE EXECUTED>>>>>>');
                    ID contactId = u.contactId;                    
                    AccID  = [Select AccountID from Contact where id =: contactId].AccountId;                   
                    system.debug('.......'+AccID);
                    accGlobalObj=[select id,Name,card_Types__c,Payment_Types__c from Account where id=:AccID limit 1];
                    partnerName=accGlobalObj.Name;                                          
                    system.debug('------'+AccID);
                }
                tabMenus = new Map<Integer,Map<String,List<String>>>();
                tabMenus = ecomAccConfig.getTabNames(AccID);
                iconOptionsOnHeader = ecomAccConfig.iconOptions;
                System.debug('--------------------------'+tabMenus);
                partnerLogoURL= ecomAccConfig.partnerBrandLogo;
                partnerTheme = ecomAccConfig.partnerTheme;
                resourcePath = '/HTML/css/portal_'+partnerTheme+'.css';
                linkHeader=ecomAccConfig.footerLinkHeader;
                footerLink=ecomAccConfig.footerLinks;
                
                aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c,Language__c FROM Account_Setting__c where Account__c=:AccID  and is_Active__c=true limit 1];

            }catch(Exception e){
                system.debug('>>>>>'+e.getMessage());
            }
                

        //productsList = [select id,name,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id='01s36000005Z5Uf'),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and family ='Home Theaters'];
         cartList= [SELECT Account__c,Deletion_Date__c,Price__c,Id,Name,Product_Id__c,Quantity__c,Product_Id__r.Image_URL__c,Product_Id__r.Image__c,Product_Id__r.Name,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c where User_Id__c=:u.Id];                
        
        for(Shopping_Cart__c cartObj : cartList){
            System.debug('$$$$$'+cartObj.Price__c);            
            wrapJSONList.add(new listJSONWrapper(cartObj.Product_Id__r.Image__c,cartObj.Product_Id__r.Name,String.valueOf(cartObj.Price__c),String.valueOf(cartObj.Quantity__c),String.valueOf(cartObj.Product_Id__c)));
        }
        jsonString = JSON.serialize(wrapJSONList); 
        
        mapLabels = Hard_Coded_Labels__c.getAll();
        
        selectedLang = ApexPages.currentPage().getParameters().get('lang');  
    } 
    
    
    public PageReference refreshLanguage(){
            
        selectedLang = mapLabels.get(selectedLang).Value__c;
        PageReference homePageURL= new PageReference(mapLabels.get('HomePage_URL').Value__c);
        homePageURL.getParameters().put('lang',selectedLang);
        homePageURL.setRedirect(true);
        return homePageURL;
    } 
    
    
}