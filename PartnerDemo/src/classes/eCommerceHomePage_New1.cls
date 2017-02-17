global class eCommerceHomePage_New1 {

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
    public Map<String,List<PricebookEntry>> PriceBookMap{get;set;}
    
    public Map<Id,Product2> productsMap{get;set;}
    public static String partnerName{get;set;}
    public static User u{get;set;}
    //public static Map<id,String> productPriceBookPrice{get;set;}
    public String jsonString {get;set;}
    public String SearchText{get;set;}
    
    public static final Integer PAGE_SIZE = 5;
    
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
    public static Apexpages.Standardsetcontroller setCon {  
      get {  
           if(setCon == null){  
                String query = 'SELECT Brand__c,Category__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,ProductCode,RecordTypeId,Stock__c,SystemModstamp,Total_Quantity_Sold__c FROM Product2 where Total_Quantity_Sold__c >0 ORDER BY Total_Quantity_Sold__c ASC OFFSET 5';  
                setCon = new Apexpages.Standardsetcontroller(Database.getQueryLocator(query));  
           }  
           return setCon;  
      }  
      set;  
 }
    public list<listJSONWrapper> wrapJSONList { get; set; }

    
    public eCommerceHomePage_New1(){
        attURL='https://c.na30.content.force.com/servlet/servlet.FileDownload?file=';
        str=apexpages.currentpage().getparameters().get('sessionId');        
        pCode=apexpages.currentpage().getparameters().get('pCode');        
        
        prodAttchMap= new Map<Id,String>();
        productsList= new List<Product2>();
        hometheaterList= new List<Product2>();
        carSpeakerList= new List<Product2>(); 
        productsMap= new Map<Id,Product2>();
        u = new User();
        wrapJSONList = new list<listJSONWrapper>();
        
 
        u = [select Id,username,LastName from User where Id = :UserInfo.getUserId()];
        apexpages.currentpage().getparameters().put('sessionId',u.Id);
        loggedInUserName=u.userName;
        if(loggedInUserName!=null){
            isLoggedUser=true;
        }
        
        try{
            ID contactId = u.contactId;
            ID AccID  = [Select AccountID from Contact where id =: contactId].AccountId;
                  
            //String networkId = Network.getNetworkId();
            //system.debug('Network id:::'+networkId+'\n'+User.network.Id);     
            Account accountObj= [select id,Name from Account where id=: AccID];
            
            if(accountObj!=null){
                partnerName= accountObj.Name;           
            }else if(u.lastName=='Guest User'|| accountObj==null){
                partnerName='Guest User';           
            }   
        }catch(Exception e){system.debug('###'+e.getMessage());}
        
        
        List<Shopping_Cart__c> cartList= [SELECT Account__c,Deletion_Date__c,Price__c,Id,Name,Product_Id__c,Quantity__c,Product_Id__r.Image_URL__c,Product_Id__r.Name,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c where User_Id__c=:u.Id];                
        
        for(Shopping_Cart__c cartObj : cartList){
            System.debug('$$$$$'+cartObj.Price__c);            
            wrapJSONList.add(new listJSONWrapper(cartObj.Product_Id__r.Image_URL__c,cartObj.Product_Id__r.Name,String.valueOf(cartObj.Price__c),String.valueOf(cartObj.Quantity__c),String.valueOf(cartObj.Product_Id__c)));
        }
        jsonString = JSON.serialize(wrapJSONList);

    }                
    
    public void setRelatedProducts(){
        productsMap.clear();
        String pFamily=Apexpages.currentPage().getParameters().get('pFamily');
        String accountName=Apexpages.currentPage().getParameters().get('accountName');
        System.debug('###'+pFamily+'\n'+accountName);
        
        String SearchProd=Apexpages.currentPage().getParameters().get('SearchProd');
        String Category=Apexpages.currentPage().getParameters().get('Category'); 
        accountName = 'Guest User';
        
        system.debug('SearchProd------->>>'+SearchProd);
        system.debug('Category------->>>'+Category);
               
        
        if(accountName=='Guest User'){          
            productsList= [select id,name,RecordTypeId,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where isActive=true limit 1),RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and family =:pFamily limit 5];   
            System.debug('productsList------'+productsList);            
            for(Product2 prodObj:productsList){ 
                System.debug('&&&&&&&&-'+prodObj);
                productsMap.put(prodObj.id,prodObj);
            }
            
            if(SearchProd!=''){
                SearchProd = '%'+SearchProd+'%';
                //productsList = [select id,name,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId), RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Name like :SearchProd];  
                productsList = [select id,name,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where isActive=true limit 1), RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true limit 3];  
                for(Product2 prodObj:productsList){             
                        productsMap.put(prodObj.id,prodObj);
                }
            }
                        
        }else{
                
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
                
            if(SearchProd!=''){
                SearchProd = '%'+SearchProd+'%';
                productsList = [select id,name,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where isActive=true limit 1), RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Id in: pId and Name like :SearchProd];  
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
    global static String generateTransactionid(String phoneNum,String price, String address,String quanty,String emailId,String bankName,String cardNum,Id prodCode,String cardType){
        
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
    global static User registerNewUser(String userName,String password){        
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
    global static String registerUser(String firstName,String lastName,String emailId){
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
    global static PageReference login(String username,String password) {        
       
        String startUrl = '/apex/ECommerce_HomePage';      
        //PageReference pRef = Site.login(username, password, startUrl);
        System.debug('@@@@'+username+Site.login(username, password, startUrl));
        return Site.login(username, password, startUrl);                                
    }
    
    public PageReference login1() {        
        String userName='contact.ajads@gmail1.com';
        String password='Harman@321';
        String startUrl = '/apex/ECommerce_HomePage';       
        PageReference pRef = Site.login(userName, password, null );
        if(pRef==null){
            return Page.eCommerce_HomePage;
        }else{
            pRef.setRedirect(true);
            System.debug('!!!!!!!'+pRef);           
            return pRef;         
        }
    }
    
    
    @RemoteAction
    global static Boolean resetPassword(String username) {        
        return Site.forgotPassword(username);   
    }
    
    @RemoteAction
    global static void saveCartDetails(List<Shopping_Cart__c> cartDetails){        

        System.debug('@@@@@'+cartDetails);       
        List<Shopping_Cart__c> cartList = new List<Shopping_Cart__c>();
        
        for(Shopping_Cart__c cartObj:cartDetails){         
            System.debug('!!!!!!'+cartObj);
            if(!partnerName.equalsignorecase('Guest User')){
                cartObj.Account__c =[select Id,Name from Account where name=:partnerName limit 1].Id;
            }            
            cartObj.User_Id__c=u.Id;            
            //cartObj.Product_Id__c = [SELECT Id,Name,ParentId FROM Attachment where Name =:strObj.name limit 1].ParentId;
            cartList.add(cartObj);
        }
        
        if(cartList.size()>0){
            insert cartList;
        }  
             
    }    
    public class ProductWrapper{
         public Integer pageNumber { get; set; }  
       public Boolean hasMore { get; set; }  
       public Boolean noRecords { get; set; }  
       public List<Product2> records { get; set; }  
       public ProductWrapper(Integer currentPageNumber, Boolean more, Boolean noRecs, List<Product2> recordsForSinglePage){  
            pageNumber = currentPageNumber;  
            hasMore = more;  
            noRecords = noRecs;  
            records = recordsForSinglePage;  
       }  
    } 
 public static String  productList{  
       get {  
            ProductWrapper pw = buildScrollData(1, false);  
           productList = JSON.serialize(pw);  
            return productList;  
       }  
     private set;  
  } 
  
  
   @RemoteAction  
  public static eCommerceHomePage_New1.ProductWrapper getMore(String currentPageNumber, String hasMore){  
      Integer pageNumber = Integer.valueOf(currentPageNumber);  
      Boolean more = Boolean.valueOf(hasMore);  
       if(more){  
            eCommerceHomePage_New1.ProductWrapper pw = eCommerceHomePage_New1.buildScrollData(pageNumber, more);  
            return pw;  
       }  
       return null;  
  }
  
  public static ProductWrapper buildScrollData(Integer currentPageNumber, Boolean getMore){  
       if(setCon != null){  
            setCon.setPageSize(PAGE_SIZE);  
            setCon.setPageNumber(currentPageNumber);  
          if(getMore){  
                if(setCon.getHasNext()){  
                    setCon.next();  
                     List<Product2> products= (List<Product2>)setCon.getRecords();  
                      if(products!= null && !products.isEmpty()){  
                         ProductWrapper pw = new ProductWrapper (setCon.getPageNumber(), setCon.getHasNext(), true, products);  
                          return pw;  
                     } else {  
                          ProductWrapper pw = new ProductWrapper (setCon.getPageNumber(), setCon.getHasNext(), false, null);  
                         return pw;  
                      }  
                } else {  
                      ProductWrapper pw = new ProductWrapper (setCon.getPageNumber(), setCon.getHasNext(), false, null);  
                      return pw;  
                 }  
           } else {  
                 //Initial Call. Load the first number or records according to pageSize  
                ProductWrapper pw = new ProductWrapper (setCon.getPageNumber(), setCon.getHasNext(), true, (List<Product2>)setCon.getRecords());  
                return pw;  
           }  
       }  
       return null;  
  }   
}