public class eCommerceHomePage1 {

    public static String loggedInUserName { get; set; }

    public static Boolean isLoggedUser { get; set; }
        
    public Integer i{get;set;}       
    public List<Product2> allProductsList{get;set;} 
    public List<Product2> productsList{get;set;}
    public List<Product2> hometheaterList{get;set;}
    public List<Product2> carSpeakerList{get;set;}
    public Map<Id,String> prodAttchMap{get;set;}
    public Product2 prodInfo {get;set;}
    public static Integer NoOfItems{get;set;}
    public static Integer qty{get;set;}
    public String attURL{get;set;}
    String[] banks= new String[]{};       
    public static string transacId{get;set;}    
    public Integer totalPrice{get;set;}    
    public String address{get;set;}
    public String str{get;set;}
    public String sessionId{get;set;}
    public String loggedInUserId{get;set;}
    public static String pCode{get;set;}
    public Static String transactionid{get;set;}
    public Map<Id,Product2> productsMap{get;set;}
    //22/6
    public String selectedValue { get; set; } 
    public blob picture { get; set; }
    public String errorMessage { get; set; }
    public string searchstring {get;set;}  
    private Product2 product;
    private final String productId='01t36000002Fkta';
    public List<Product2> products3 {get; set;} 
    public List<Product2> products = new List<Product2>();   
    public List<Product2> products1 {get; set;} 
    
    public eCommerceHomePage1(){       
        str=apexpages.currentpage().getparameters().get('sessionId');        
        pCode=apexpages.currentpage().getparameters().get('pCode');
        
        prodAttchMap= new Map<Id,String>();
        productsList= new List<Product2>();
        hometheaterList= new List<Product2>();
        carSpeakerList= new List<Product2>(); 
        productsMap= new Map<Id,Product2>();       

        
        User u = [select Id,username,LastName from User where Id = :UserInfo.getUserId()];
        apexpages.currentpage().getparameters().put('sessionId',u.Id);
        loggedInUserName=u.userName;
        if(loggedInUserName!=null){
            isLoggedUser=true;
        }        
        
    }    
   
    public PageReference search() 
    {
       
      System.debug('searchstring:'+searchstring);
      //products1 =[SELECT Description, Family, Id, Image_URL__c, Image__c FROM Product2 WHERE Family LIKE' + '\'%' + searchstring + '%\' LIMIT 2 ]; 
     products1 = Database.query('SELECT  Description, Family, Id, Image_URL__c, Image__c FROM Product2 WHERE Family LIKE' + '\'%' + searchstring + '%\'');
      System.debug('products1 :'+products1 ); 
     //Product3= Database.query(products1);  
     return null;
       
    }
     
  
  
   public PageReference save() {
    errorMessage = '';
    try {
    System.debug('selectedValue :'+selectedValue );
    // product = [SELECT Brand__c,Category__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = '01t360000017xd4' ];
       // upsert product;
      product = [SELECT Brand__c,Category__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        if (picture != null) { 
            Attachment attachment = new Attachment();
            attachment.body = picture;
            attachment.name = 'product_' + productId + '.jpg';
            attachment.parentid = productId;
           attachment.ContentType = 'application/jpg';
            insert attachment;
            product.Image_URL__c = 'https://c.na30.content.force.com/servlet/servlet.FileDownload?file='+ attachment.id;
            product.Price__c =13000.00;
            update product;
        }
        return null;
    } catch(System.Exception ex) {
        errorMessage = ex.getMessage();
        return null;

    }
}   
    
    
    public void setRelatedProducts(){
        productsMap.clear();
        String pFamily=Apexpages.currentPage().getParameters().get('pFamily');
        String accountName=Apexpages.currentPage().getParameters().get('accountName');
        System.debug('###'+pFamily+'\n'+accountName);        
        
        if(accountName=='Guest User'){   
            if(searchstring!=null)
            {
              productsList= [select id,name,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where isActive=true limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and family =:pFamily ];   
            System.debug('productsList------'+productsList); 
            }else
            {    
            productsList= [select id,name,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where isActive=true limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and family =:pFamily];   
            System.debug('productsList------'+productsList);
            for(Product2 prodObj:productsList){ 
                System.debug('&&&&&&&&-'+prodObj);
                productsMap.put(prodObj.id,prodObj);
            }
          }              
        }
        else{       
            Set<Id> pId = new Set<Id>();
            for(Account_Products__c ap :[SELECT Account__c,Sell_Price__c,Account__r.Name,Id FROM Account_Products__c where Account__r.Name =:accountName]){
               // pId.add(ap.Product2Id);
            }  
            
            if(pId.size()>0){               
                productsList = [select id,name,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where isActive=true limit 1), RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Id in: pId and family =:pFamily limit 5];  
                for(Product2 prodObj:productsList){             
                        productsMap.put(prodObj.id,prodObj);
                }
                                
            }
        }
         
    
    }
         
    public void displaySelectedProduct(){           
            String str=apexpages.currentpage().getparameters().get('pCode');            
            if(!String.isBlank(str)){
                prodInfo=[select id,name,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:str];
            }
    }
             
    /*public String[] getBankName() {
       
        return banks;
    }
    
    
    public void setBankName(String[] banks){
        this.banks=banks;
    }
    
    public List<selectOption> getlistOfBanks(){
        List<selectOption> banksList = new List<selectOption>();
        
        banksList.add(new SelectOption('HDFC Bank',' HDFC BANK'));
        banksList.add(new SelectOption('Axis Bank',' AXIS BANK'));
        return banksList;
    }
    */
    
    @RemoteAction 
    public static String generateTransactionid(String phoneNum,String price, String address,String quanty,String emailId,String bankName,String cardNum,Id prodCode,String cardType){
        
        PaypalProccessor p = new PaypalProccessor();
        p.city = 'Bangalore';
        p.state = 'KR';
        p.zip = '1002';
        p.CVV = '';
        p.expYe = '2021';
        p.expMo = '06';
        p.CardNo = cardNum;//'5110921839131706';
        p.CardType = cardType;// 'MasterCard';
        p.FirstName  = 'Ajay';
        p.LastName  = 'Satish';
        p.Country = 'IN';
        p.Addy1 = '44';
        p.Addy2 = '433';
        p.payer = 'satishdoddangadi@gmail.com';
        p.amount = String.valueOf(Integer.valueOf(price)/65);//'5000';
        string message = p.pay();
        transactionid = p.transid;
        system.debug('#### Message::' + message);
        system.debug('#### Transaction Id::' + transactionid);
        
        if(transactionid!=null){
            
        
            Asset astObj = new Asset();
            
            System.debug('Invooked....'+pCode);
            
        
        }                
        return transactionid;        
        
    }
     public String productName { get; set; }    
      public static List<Product2> prodList{get;set;}
      
    public List<Product2> getprodList() {
       List<Product2> pl = new List<Product2>();
       Product2 p2 = new Product2();
       p2.Category__c = 'abc';
       
       pl.add(p2);
        return pl;
        //[SELECT Brand__c,Category__c,Family,Id,Image_URL__c,Image__c FROM Product2];        
    }
    
    
    
    public void selectedProductSummary(){           
            pCode=apexpages.currentpage().getparameters().get('pCode');
            sessionId=apexpages.currentpage().getparameters().get('sessionId');
            String stng = apexpages.currentpage().getparameters().get('qty');
            
            if(!String.isBlank(stng)){              
                qty =Integer.valueOf(stng); 
            }else{
                qty=0;
            }
            
            /*if(String.isBlank(sessionId)){
                   sessionId='guestuser@gmail.com'; 
            }*/
            if(!String.isBlank(pCode)){
                prodInfo=[select id,name,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:pCode];                
                /*if(!String.isBlank(sessionId)){
                 eCommerce_User_Records__c eRec=[select id,userName__c from eCommerce_User_Records__c where Username__c=:sessionId];                 
                 if(eRec!=null){
                     loggedInUserId=eRec.Id;   
                 }
                }    */            
            }

            if(Integer.valueof(qty)<100 && prodInfo!=null){
                totalPrice=Integer.valueOf(prodInfo.Price__c*Integer.valueof(qty));
            } 
            
    } 
    @RemoteAction
    public static User registerNewUser(String userName,String password){        
        User us= new User();
        /*Contact newUser = new Contact();
        newUser.lastName=userName;
        newUser.Email=userName;
        newUser.Phone=phoneNum;
        newUser.Password__c=password;
        newUser.Description=delAddr;        
        //newUser.AccountId='00136000008Gm2WAAS';
        System.debug('####'+userName+'\n'+password);        
        insert newUser;                                              
        
        
        
        String[] strName=userName.split('@');
        User userObj= new User();
        System.debug('%%%%%'+strName[0]);        
        userObj.LastName=strName[0];
        userObj.Alias=alias;
        userObj.Email=userName;
        userObj.CommunityNickname=strName[0];
        //userObj.userRoleId=[SELECT DeveloperName,Id,Name FROM UserRole limit 1].Id;
        userObj.ProfileId=[select id,Name from Profile where Name='System Administrator' limit 1].Id;
        //userObj.licenseId=[select id from UserLicense where name='Partner Community' limit 1].Id;
        //userObj.ContactId=newUser.id;     
        userObj.Phone=phoneNum;
        userObj.isActive=true;
        userObj.Delivery_Address__c=delAddr;
        userObj.userName=userName;
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        insert userObj;
        
        return userObj;*/
        
        return us;

    }
    
    @RemoteAction
    public static String registerUser(String firstName,String lastName,String emailId){
        Savepoint sp = Database.setSavepoint();
        //create Contact record for portal user
        Contact newUser = new Contact();
        newUser.firstName=firstName;
        newUser.lastName=lastName;
        newUser.Email=emailId;
        newUser.AccountId=[select id from Account where name='Guest User' limit 1].Id;
        //newUser.Description=delAddr;                
        System.debug('####'+firstName+'\n'+lastName);
        //newUser.ownerId=[select id from User where name like '%Integration User%' limit 1].Id;
        try{
                insert newUser;
        }catch(Exception e){
            Database.rollback(sp);

            return 'exception found'+e.getMessage();
        }
        
        
        
        //Create a portal user with Contact
        User userObj= new User();               
        userObj.LastName=lastName;
        userObj.Alias=lastName.substring(0, 3);
        userObj.Email=emailId;
        userObj.CommunityNickname=lastName;        
        userObj.ProfileId=[select id,Name from Profile where Name='Customer Community Login User' limit 1].Id;    
        //userObj.Phone='999';
        userObj.isActive=true; 
        String userName=firstName+lastName;userName=userName.replaceAll('\\s','');
        system.debug('userName---'+firstName+lastName+'@demo.com');
        userObj.userName=userName+'@demo.com';
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        userObj.contactId=newUser.id;
        
        try{                    
                insert userObj;             
        }catch(Exception e){
            Database.rollback(sp);

            return 'exception found'+e.getMessage();
            
        }
        
        system.resetPassword(userObj.Id,true);
        
        return 'Thank you! Please confirm your email address.';
        
    }  
   
    @RemoteAction
    public static PageReference login(String username,String password) {        
       
        String startUrl = '/apex/ECommerce_HomePage';       
        PageReference pRef = Site.login(username, password, startUrl);
        System.debug('!!!!!!!'+pRef);           
        return Site.login(username, password, startUrl);         
    }
    
    @RemoteAction
    public static Boolean resetPassword(String username) {        
        return Site.forgotPassword(username);   
    }
   }