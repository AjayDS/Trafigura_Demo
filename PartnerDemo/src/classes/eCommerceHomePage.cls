global class eCommerceHomePage {
        
    public PageReference getAvailableStock() {
        return null;
    }


    public String prodCategorySelected { get; set; }
    public static String loggedInUserName { get; set; }
    public static Boolean isLoggedUser { get; set; }       
    public Integer i{get;set;}       
    public List<Product2> allProductsList{get;set;} 
    public List<Product2> productsList{get;set;}
    public List<Product2> hometheaterList{get;set;}
    public List<Product2> carSpeakerList{get;set;}
    public List<Shopping_Cart__c> cartList{get;set;}
    public Map<Id,String> prodAttchMap{get;set;}
    public Product2 prodInfo {get;set;}
    public static Integer NoOfItems{get;set;}
    public static Integer qty{get;set;}    
    String[] banks= new String[]{};       
    public static string transacId{get;set;}    
    public Integer totalPrice{get;set;}    
    public String address{get;set;}
    public String str{get;set;}
    public String sessionId{get;set;}
    public String loggedInUserId{get;set;}
    public static String pCode{get;set;}
    public String transactionid{get;set;}
    public Map<String,List<PricebookEntry>> PriceBookMap{get;set;}
    
    public Map<Id,Product2> productsMap{get;set;}
    public static String partnerName{get;set;}
    public static User u{get;set;}
    //public static Map<id,String> productPriceBookPrice{get;set;}
    public String jsonString {get;set;}
    public String SearchText{get;set;}
    
    public Map<Id,List<OrderItem>> orderProductsMap{get;set;}
    public List<Order> orderList{get;set;}
    public Map<Id,Product2> productsMapforOrder{get;set;}
    public string testString{get;set;}
    public  Map<Id,String> productSellPrice{get;set;} 
    public String userN{get;set;}
    public String pass{get;set;}
    public String fName{get;set;}
    public String lName{get;set;}
    public String email{get;set;}
    public String cardType{get;set;} 
    public String NameOnCard{get;set;}
    public String cardNum{get;set;}
    public String expDate{get;set;}
    public String paymentType{get;set;}
    public String PayableAmount{get;set;}
    public String addressInfo{get;set;}
    public String totalQuantity{get;set;}
    
    public String mailingStreet{get;set;}
    public String mailingCity{get;set;}
    public String mailingState{get;set;}
    public String mailingZipcode{get;set;}
    public String mailingCountry{get;set;}
    
    public String test{get;set;}
    
    
    
    //file upload variables    
     public String selectedValue { get; set; }    
    public blob picture { get; set; }
    public String errorMessage { get; set; }
    private Product2 product;
    public List<Product2> products = new List<Product2>();  
    public List<Product2> categories=new List<Product2>();
    public List<SelectOption> selectList{get;set;}
    public List<SelectOption> paymentOptions{get;set;}
    public Map<String,Account> accIdMap;
    public Account accGlobalObj{get;set;}  
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    
    public Set<Id> bannerProductIds = new Set<Id>();
    public Map<Id,Product2> homeBannerProducts{get;set;}
    
    ECommerce_CofigurableClass ecomAccConfig = new ECommerce_CofigurableClass();
    public String partnerLogoURL{get;set;}
    public String partnerTheme{get;set;}
    public String resourcePath{get;set;}
    public Account_Setting__c aSet{get;set;}
    public List<String> footerLink{get;set;}
    public String linkHeader{get;set;}
    
    public Map<Integer,Map<String,List<String>>> tabMenus{get;set;}
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
    public list<listJSONWrapper> wrapJSONList { get; set; }
    public ID AccID{get;set;}
    
    //testing purpose for System Admin
    public void setAccountinfo(){
        
        for(Account accObj:[select id,Name,card_Types__c,Payment_Types__c from Account where name=:partnerName limit 1]){
            accIdMap.put(accObj.Name,accObj);
            accGlobalObj=accObj;
        }
    }
    
    public eCommerceHomePage(){        
        prodAttchMap= new Map<Id,String>();
        productsList= new List<Product2>();
        hometheaterList= new List<Product2>();
        carSpeakerList= new List<Product2>(); 
        productsMap= new Map<Id,Product2>();
        productsMapforOrder= new Map<Id,Product2>();        
        orderProductsMap = new Map<Id,List<OrderItem>>();       
        accIdMap = new Map<String,Account>();        
        accGlobalObj= new Account();
        homeBannerProducts = new Map<Id,Product2>();
        aSet = new Account_Setting__c();
        
        u = new User();
        wrapJSONList = new list<listJSONWrapper>();
        testString='0';
        orderList = new List<Order>();
        
        
        u = [select Id,username,contactid,LastName from User where Id = :UserInfo.getUserId()];

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
                System.debug('--------------------------'+tabMenus);
                partnerLogoURL= ecomAccConfig.partnerBrandLogo;
                partnerTheme = ecomAccConfig.partnerTheme;
                resourcePath = '/HTML/css/portal_'+partnerTheme+'.css';
                linkHeader=ecomAccConfig.footerLinkHeader;
                footerLink=ecomAccConfig.footerLinks;
                
                aSet= [SELECT Account__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c FROM Account_Setting__c where Account__c=:AccID  and is_Active__c=true limit 1];
                
                String multiSelVal = accGlobalObj.card_Types__c;               
                List<String> splitList = multiSelVal.split(';');  
                
                selectList = new List<SelectOption>();
                selectList.add(new SelectOption('--CardType--','--CardType--'));
                for (String s: splitList)
                {   
                    system.debug('#######'+accGlobalObj.Payment_Types__c);
                    selectList.add(new SelectOption(s,s));                     
                }
                
                multiSelVal = accGlobalObj.Payment_Types__c;
                splitList = multiSelVal.split(';');   
                paymentOptions = new List<SelectOption>();
                paymentOptions.add(new SelectOption('--PaymentType--','--PaymentType--'));
                for (String s: splitList)
                {
                    system.debug('>>>>>');
                    paymentOptions.add(new SelectOption(s,s));
                }
                
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
        setHomeBannerImages(partnerName);    
    }   
    
    public PageReference echoVal() {
       
       String name= Apexpages.currentPage().getParameters().get('name');
       String street= Apexpages.currentPage().getParameters().get('street');
       String landmark= Apexpages.currentPage().getParameters().get('landmark');
       String city= Apexpages.currentPage().getParameters().get('city');
       String state= Apexpages.currentPage().getParameters().get('state');
       String country= Apexpages.currentPage().getParameters().get('country');
       String pincode= Apexpages.currentPage().getParameters().get('pincode');
       String phonenumber= Apexpages.currentPage().getParameters().get('phonenumber');
       
       Addreess__c addresoBJ = new Addreess__c();
       
       addresoBJ.Name__c= name;
       addresoBJ.Street_Address__c= street;
       addresoBJ.Land_Mark__c= landmark;
       addresoBJ.City__c= city;
       addresoBJ.State__c= state;
       addresoBJ.Country__c= country;
       addresoBJ.pincode__c= pincode;
       addresoBJ.Phone_Number__c = phonenumber;
       addresoBJ.User__c = UserInfo.getUserId();//'005360000026jjf';
        
       if(addresoBJ!=null){
           
            System.debug('$$$$$$$$'+addresoBJ);         
               insert addresoBJ;
               System.debug('Inserted.....');
         /*  }catch(Exception e){
                System.debug('Found Exception');
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please verufy the Details.'));
           }*/
       }
       
       
       

       return null;
    }
    
    public void searchProducts(){
        productsMap.clear();
         system.debug('SearchProd------->>>'+SearchText);
         system.debug('Category------->>>'+prodCategorySelected);        
         if(SearchText!=null){             
             String query='SELECT  Description, Family, Id, Image_URL__c, Image__c FROM Product2 WHERE Id =\'' + prodCategorySelected + '\'and Name LIKE' + '\'%' + SearchText+ '%\'';
             system.debug('query------->>>'+query);                     
             productsList=  Database.query(query);
             system.debug('productsList--->'+productsList);
             //'SELECT  Description, Family, Id, Image_URL__c, Image__c FROM Product2 WHERE Id=:prodCategorySelected +'and Family LIKE' + '\'%' + SearchText+ '%\''
            for(Product2 prodObj:productsList){                  
                productsMap.put(prodObj.id,prodObj);                
            }             
          }
    }   
    
    public void setRelatedProducts(){
        productsMap.clear();
        String pFamily=Apexpages.currentPage().getParameters().get('pFamily');
        String accountName=Apexpages.currentPage().getParameters().get('accountName');
        System.debug('###pFamily:'+pFamily+'\n account Name:'+accountName);        
        String SearchProd=Apexpages.currentPage().getParameters().get('SearchID');
        String Category=Apexpages.currentPage().getParameters().get('productCategory'); 
        //accountName = 'Community Partner1';
        
        system.debug('SearchProd------->>>'+SearchText);
        system.debug('Category------->>>'+prodCategorySelected);               
         productSellPrice = new Map<Id,String>(); 
         
        if(accountName=='Guest User'){ 
            
            for(Account_Products__c ap :[SELECT Account__c,Sell_Price__c,Account__r.Name,Product__c,Id FROM Account_Products__c where Account__r.Name =:accountName]){
                if(ap.Sell_Price__c!=null){
                    System.debug('&&&&&&&&-'+ap);
                    productSellPrice.put(ap.Product__c,String.valueOf(ap.Sell_Price__c));
                }
            }  
            
            
            if(pFamily!=null){
                productsList= [select id,name,Stock__c,Image__c,RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and family =:pFamily limit 5];   
            }else{
                productsList= [select id,name,Stock__c,RecordTypeId,Image__c,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true];   
            }
            System.debug('productsList------'+productsList);            
            for(Product2 prodObj:productsList){  
                if(productSellPrice.containsKey(prodObj.id)){
                    productsMap.put(prodObj.id,prodObj);
                }
            }
           
            if(SearchProd!=''){
                SearchProd = '%'+SearchProd+'%';
                //productsList = [select id,name,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:priceBookId), RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Name like :SearchProd];  
                productsList = [select id,Image__c,name,Stock__c,RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true limit 3];  
                for(Product2 prodObj:productsList){             
                        productsMap.put(prodObj.id,prodObj);
                }
            }
        }else{                
                    
            Set<Id> pId = new Set<Id>();
            for(Account_Products__c ap :[SELECT Account__c,Sell_Price__c,Account__r.Name,Product__c,Id FROM Account_Products__c where Account__r.Name =:accountName]){
                pId.add(ap.Product__c);
                System.debug('!!!!!!!!-'+pId);
                if(ap.Sell_Price__c!=null){
                    System.debug('&&&&&&&&-'+ap);
                    productSellPrice.put(ap.Product__c,String.valueOf(ap.Sell_Price__c));
                }
            }  
            
            if(pId.size()>0){               
                productsList = [select id,name,Image__c,Stock__c,RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Id in: pId and family =:pFamily limit 5];  
                for(Product2 prodObj:productsList){  
                        System.debug('QQQQQ-'+productSellPrice.size()+productsList.size()); 
                        if(productSellPrice.containsKey(prodObj.id)){
                            productsMap.put(prodObj.id,prodObj);
                        }
                }
                
                System.debug('QQQQQ-'+productsList.size());
                
                if(SearchProd!=''){
                    SearchProd = '%'+SearchProd+'%';
                    productsList = [select id,name, Image__c,Stock__c,RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Id in: pId and Name like :SearchProd];  
                    for(Product2 prodObj:productsList){             
                            productsMap.put(prodObj.id,prodObj);                            
                    }
                }
            }
        }    
    }
        
     
    public void setOrderedProducts(){
        String orderId=Apexpages.currentPage().getParameters().get('orderId');      
        String accountName=Apexpages.currentPage().getParameters().get('accountName');
        testString='00';
        //if(accountName=='Guest User'){ // has to be changed later...
            try{
                orderList = [SELECT id,CreatedDate,OrderNumber,Status,Shipping_Date__c,ActivatedDate,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Email_Id__c,Phone_Number__c,ShippingAddress,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,TotalAmount,(SELECT AvailableQuantity,CreatedById,Description,EndDate,Id,ListPrice,OrderId,OrderItemNumber,PricebookEntryId,PricebookEntry.Product2Id,Quantity,ServiceDate,UnitPrice FROM OrderItems)FROM Order where OrderNumber=:orderId];
                setRelatedProducts();
            }catch(Exception e){testString='-1';system.debug(e.getMessage());}                       
        //}
        system.debug('EEEEEE'+orderProductsMap);
    }
    
    public void displaySelectedProduct(){           
            String str=apexpages.currentpage().getparameters().get('pCode');            
            if(!String.isBlank(str)){
                prodInfo=[select id,name,Stock__c,Image__c,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:str];
            }
    }
    
    
    
    public PageReference generateTransactionid(){
        
        System.debug('CALLED');
        
        PayableAmount='123123';//Apexpages.currentPage().getParameters().get('totalAmount');
        System.debug('--> '+PayableAmount+cardNum+cardType);
        PaypalProccessor p = new PaypalProccessor();
        p.city = 'Bangalore';
        p.state = 'KR';
        p.zip = '1002';
        p.CVV = '';
        p.expYe = '2021';
        p.expMo = '06';
        p.CardNo = '5110921839131706';// cardNum;//'5110921839131706';
        p.CardType = 'MasterCard';//cardType;// 'MasterCard';
        p.FirstName  = 'Ajay';
        p.LastName  = 'Satish';
        p.Country = 'IN';
        p.Addy1 = '44';
        p.Addy2 = '433';
        p.payer = 'satishdoddangadi@gmail.com';
        p.amount = String.valueOf(Integer.valueOf(PayableAmount)/65);//'5000';
        string message;
        try{
            message = p.pay();
        }Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+ e.GetLineNumber()));      
        }
        transactionid = p.transid;
        system.debug('#### Message::' + message);  
        //Testing
        if(transactionid==null){
            transactionid='123123123';
        }
        if(transactionid==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,message));
            return null;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully Transaction with Id: '+transactionid));  
            System.debug('Invooked....'+transactionid);

            Opportunity Opp = new Opportunity();
            Opp.Name = transactionid;
            Opp.AccountId = AccID;
            Opp.StageName ='Closed Won';
            Opp.CloseDate = System.Today();
            Insert Opp;
                       
            List<PricebookEntry> pBook = [SELECT Id,Name,Pricebook2Id,Product2Id,UnitPrice,IsActive  FROM PricebookEntry WHERE Pricebook2Id=:aSet.Price_book__c and IsActive =true];
            
            Map<Id,PricebookEntry> priceEntryMap = new Map<Id,PricebookEntry>();
            
            if(pBook.size()>0){
                for(PricebookEntry pEntry:pBook){
                    
                    priceEntryMap.put(pEntry.Product2Id,pEntry);
                }
            }
            
            List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
            
             System.debug('scaaaaaart');            
            cartList= [SELECT Account__c,Deletion_Date__c,Price__c,Id,Name,Product_Id__c,Quantity__c,Product_Id__r.Image_URL__c,Product_Id__r.Image__c,Product_Id__r.Name,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c where User_Id__c=:userInfo.getUserId()];
            for(Shopping_Cart__c cart : cartList)
            {

                OpportunityLineItem oppli = new OpportunityLineItem();
                if(priceEntryMap.size()>0){
                    oppli.PricebookEntryId =priceEntryMap.get(cart.Product_Id__c).Id;
                }
                oppli.OpportunityId = opp.id; 
                oppli.Quantity=cart.Quantity__c;
                oppli.UnitPrice=cart.Price__c;                
                oli.add(oppli);
                    
            }
            if(Oli.size()>0){
                     System.debug('insertinggggg'); 
                    Insert Oli;
                    delete cartList;
                    createOrderAndOLineItems(transactionid,opp,oli);
                    
            }
             PageReference newocp = new PageReference('/Portal_ProductDisplay');
             newocp.setRedirect(true);
            
            return newocp;  
        }
        
       
    }
    
    public void createOrderAndOLineItems(String transactionId,Opportunity optyObj, List<OpportunityLineItem> optyLineItems){
            List<OrderItem> orderItemsList = new List<OrderItem>();
            Order order = new Order();
            order.EffectiveDate = System.Today();
            order.Status='Created';
            order.OpportunityId=optyObj.Id;
            order.AccountId=optyObj.AccountId;
            order.Transaction_Id__c=transactionId;
            order.Pricebook2Id =aSet.Price_book__c;
            try{
                insert order;
            }catch(Exception e){
                System.debug('@@@'+e.getMessage());
            }
            if(order.Id!=null){
                for(OpportunityLineItem optyLineItem:optyLineItems){
                    OrderItem OrderItemObj = new OrderItem();
                    OrderItemObj.OrderId=order.Id;
                    OrderItemObj.PricebookEntryId=optyLineItem.PricebookEntryId;
                    OrderItemObj.Quantity=optyLineItem.Quantity;
                    OrderItemObj.UnitPrice=optyLineItem.UnitPrice;
                    OrderItemObj.ServiceDate=optyLineItem.ServiceDate;
                    orderItemsList.add(OrderItemObj);   
                }               
            }
            
            if(orderItemsList.size()>0){
                try{
                    insert orderItemsList;
                }catch(Exception e){
                    System.debug('!!!!!'+e.getMessage());                   
                }
                
            }
        
    }

    public void displayMessage() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This is a demo message.'));
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
                prodInfo=[select id,name,Stock__c,Image__c,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:pCode];                
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
    
    
    public PageReference registerUser(){        
        String firstName = fName;
        String lastName = lName;        
        String emailId = email;
        
        
        Savepoint sp = Database.setSavepoint();
        //create Contact record for portal user
        Contact newUser = new Contact();
        newUser.firstName=firstName;
        newUser.lastName=lastName;
        newUser.Email=emailId;      
        newUser.AccountId=[select id from Account where name=:mapLabels.get('Guest_Account').Value__c limit 1].Id;
        newUser.MailingStreet = mailingStreet;
        newUser.MailingCity = mailingCity;
        newUser.MailingState = mailingState;
        newUser.MailingPostalCode = mailingZipcode;
        newUser.MailingCountry = mailingCountry;
        
        
        try{    
            Contact userObj = new Contact();
            try{
                userObj=[select id,Email,LastName from Contact where Email=:emailId limit 1 ];
            }Catch(Exception e){}
            System.debug('####'+firstName+'\n'+lastName+'\n'+emailId+'\n'+userObj.Email); 
            if(userObj.Email=='' || userObj.Email==null){
               insert newUser;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Duplicate_Email_Error));
                Database.rollback(sp);          
                return null;
            }
            
            
        }catch(Exception e){}   
        
        //Create a portal user with Contact
        User userObj= new User();               
        userObj.LastName=lastName;
        userObj.Alias=lastName.substring(0, 3);
        userObj.Email=emailId;
        userObj.CommunityNickname=lastName;        
        userObj.ProfileId=[select id,Name from Profile where Name=:mapLabels.get('Guest_User_Profile').Value__c limit 1].Id;    
        //userObj.Phone='999';
        userObj.isActive=true; 
        String userName=firstName+lastName;userName=userName.replaceAll('\\s','');
        system.debug('userName---'+firstName+lastName+'@demo.com');
        userObj.userName=Email+mapLabels.get('Username_Extension').Value__c;
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        //userObj.isPortalEnabled = true;
        userObj.contactId=newUser.id;
        
        try{    
                if(newUser.Id!=null || newUser.id!=''){
                    insert userObj;             
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.No_Contact_Error));
                }
        }catch(Exception e){}
        try{
            system.resetPassword(userObj.Id,true);      
            //Site.forgotPassword(userObj.userName);
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Successfully Registered. Please confirm the email Address.'));
        return null;        
        
    }     
    
    public PageReference login1() {        
        String userName=userN;
        String password=pass;      
        System.debug('@@@@'+password);
        if(password=='' || password==null){         
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,mapLabels.get('Password_Validation').Value__c));
             return null;
        }
        
        String startUrl = Label.Start_URL;//'/apex/ECommerce_HomePage'; 
        
        PageReference pRef = Site.login(userName, password, startUrl);
        System.debug('AAAAA'+pRef);
        
        if(pRef==null){           
            return null;
        }else{
            pRef.setRedirect(true);
            System.debug('!!!!!!!'+pRef);           
            return pRef;         
        }
    }
    
        
    public PageReference resetPassword() {   
        String username = userN;
        Boolean isExec=false;
        try{
            User userObj = [select id from User where username=:userN and isActive=true];   
            if(userObj==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,mapLabels.get('Username_Validation_Error').Value__c));
                return null;            
            }else{
                isExec = Site.forgotPassword(username);   
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,mapLabels.get('Username_Validation').Value__c));
                System.debug('AAAAAA'+isExec+userN);
                return null;
                
            }
        }Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,mapLabels.get('Username_Validation_Error').Value__c));
            return null;            
        }       
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
    
    String country = null;
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        List<Addreess__c> addressList = new List<Addreess__c>(); 
        try{
        system.debug('Itemssssssss:'+u.id);
        system.debug('Itemssssssss:'+AccId);
        
        for(Addreess__c addrObj : [select id,Name__c,Street_Address__c, Land_Mark__c, City__c, State__c, Country__c, Pincode__c, Phone_Number__c,Shipping_Details__c,Account__c,User__c from Addreess__c where User__c=:u.Id Order by LastModifiedDate DESC limit 5]){
            SelectOption so1 = new SelectOption(addrObj.id,addrObj.Name__c+'<br/>'+addrObj.City__c+'<br/>'+addrObj.Street_Address__c+'<br/>'+addrObj.Land_Mark__c+'<br/>'+addrObj.Pincode__c);
            so1.setEscapeItem(false);
            options.add(so1);                           
        } 
        
        /*
        SelectOption so1 = new SelectOption('US',str);
        so1.setEscapeItem(false);
        options.add(so1);
        SelectOption so2 = new SelectOption('Canada','<span title="The Great White North">Canada</span>');
        so2.setEscapeItem(false);
        options.add(so2); */
        system.debug('Itemssssssss:'+u.id+AccId);
        }Catch(Exception e){
            System.debug('ERRRRRRRRRR:'+e.getMessage());
        }
        
        return options; 
    }       
    
    public String getCountry() {
        return country;
    }
                    
    public void setCountry(String country) { this.country = country; }  

    public List<SelectOption> ProductCategories
    {
       get
        {    
        /*try{
             categories= [SELECT Id,Family FROM Product2];
             ProductCategories= new List<SelectOption>();
            }Catch(Exception e){}
            for(Product2 temp : categories)
               {
                    ProductCategories.add(new SelectOption(temp.Id, temp.Family));
                }*/
            return ProductCategories;
        }
        set;
    }  
    
     public void setHomeBannerImages(String accountName){    
        accountName='Community Partner1';
        //productSellPrice = new Map<Id,String>(); 
        for(Account_Products__c accProd:[SELECT Account__c,In_HomeBanner__c,Sell_Price__c,Account__r.Name,Product__c,Id FROM Account_Products__c where Account__r.Name =:accountName and In_HomeBanner__c=true]){
            if(accProd.In_HomeBanner__c){
                bannerProductIds.add(accProd.Product__c);
                //productSellPrice.put(accProd.Product__c,String.valueOf(accProd.Sell_Price__c));
            }
        }
        
        System.debug('setHomeBannerImages'+bannerProductIds);
        
        for(Product2 prodObj:[select id,name,Stock__c,RecordTypeId,RecordType.DeveloperName,Image__c,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and Id in:bannerProductIds]){
                homeBannerProducts.put(prodObj.Id,prodObj);
        }
        
        System.debug('setHomeBannerImages'+homeBannerProducts);
        
    }

}