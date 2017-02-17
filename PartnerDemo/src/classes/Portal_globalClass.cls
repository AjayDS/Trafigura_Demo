public class Portal_globalClass {
    public static string topPhoneNumner ;
    public static string EmailStr ;
    public static string className;
    public static List<sObject> topAdv;
    public static List<sObject> menu;
    public static string Userid = UserInfo.getUserId();
    public static Account_Setting__c AccountSetting;
    public static User u{get;set;}
    public static Account_Setting__c aSet{get;set;}
    public static Account_Setting__c accSet{get;set;}
    public static List<Tab_Setting__c> tabSet{get;set;}
    public List<Footer_Settings__c> footerSet{get;set;}
    public static String partnerName{get;set;}  
    public static String jsonString {get;set;}
    public static List<Shopping_Cart__c> cartList{get;set;}
    public Map<String,Account> accIdMap;
    public Account accGlobalObj{get;set;} 
    public static String partnerBrandLogo;
    public static String partnerTheme;
    public String footerLinkHeader{get;set;}
    public List<String> footerLinks{get;set;}   
    public static List<String> iconOptions{get;set;} 
    public static Set<Id> prodIds{get;set;}
    public static Set<Id> allProdIds{get;set;}
    public static Set<Id> topSaleProducts{get;set;}
    public static Set<Id> recommendedProducts{get;set;}
    public List<Integer> counts{get;set;}
    public list<listJSONWrapper> wrapJSONList { get; set; }
    public Map<Integer,Map<String,List<String>>> tabMenus{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public List<String> iconOptionsOnHeader{get;set;}
    public static ID AccID{get;set;}
    public List<String> socialMedia{get;set;}
    public Set<String> productBrands{get;set;}
    public List<Account_Products__c> accountProducts{get;set;}
    public List<PriceBookEntry> priceBookEntryList{get;set;}
    public Map<String,List<PriceBookEntry>> productsMap{get;set;}
    public static List<String> portalBrandsList = new List<String>();
    
    
    public class listJSONWrapper{
        public string thumb{get;set;}
        public string name{get;set;}
        public string price{get;set;}
        public string quantity{get;set;}
        public String prodId{get;set;}
        public string total{get;set;}
        public listJSONWrapper(string img,string name,string price,string quantity,string prodId){
            this.thumb=img;
            this.name=name;
            this.price=price;
            this.quantity=quantity;
            this.prodId=prodId;                     
        }   
        
    }        
    
    public void setAccountinfo(){
        
        for(Account accObj:[select id,Name,card_Types__c,Payment_Types__c from Account where name=:partnerName limit 1]){
            accIdMap.put(accObj.Name,accObj);
            accGlobalObj=accObj;
        }
    }
    
    public Portal_globalClass(){
        counts = new List<Integer>();
        prodIds = new Set<Id>();
        allProdIds = new Set<Id>();
        topSaleProducts = new Set<Id>();
        recommendedProducts = new Set<Id>();
        socialMedia = new List<String>();
        productBrands = new Set<String>();
        wrapJSONList = new list<listJSONWrapper>();
        accIdMap = new Map<String,Account>();        
        accGlobalObj= new Account();
        aSet = new Account_Setting__c();        
        u = new User();
        wrapJSONList = new list<listJSONWrapper>();
        accountProducts = new List<Account_Products__c>();      
        priceBookEntryList = new List<PriceBookEntry>();
        productsMap = new Map<String,List<PriceBookEntry>>();        
        
        u = [select Id,username,contactid,FirstName,LastName from User where Id = :UserInfo.getUserId()];
        String networkId = Network.getNetworkId();
           try{
                 system.debug('++++'+UserInfo.getUserId());
                if(u.lastName=='Guest User' || networkId==null){
                    partnerName='Guest User';
                    system.debug('networkId'+networkId);
                    setAccountinfo();
                    AccID=accIdMap.get(partnerName).Id;
                    system.debug('++++'+AccID);
                    accGlobalObj = accIdMap.get(partnerName); 
                    
                }else{                     
                    ID contactId = u.contactId;                    
                    AccID  = [Select AccountID from Contact where id =: contactId].AccountId;                   
                    system.debug('.......'+AccID);
                    accGlobalObj=[select id,Name,card_Types__c,Payment_Types__c from Account where id=:AccID limit 1];
                    partnerName=accGlobalObj.Name;                                          
                    system.debug('------'+AccID);
                }
                
                aSet= [SELECT Account__c,Categories__c,Category_Limit__c,Social_Media__c,Brands__c,Top_Phone__c,Top_Email__c,Copyright_Text__c,Id,Image_URL__c,is_Active__c,Name,No_of_Items_Per_Page__c,Price_Book__c,Theme__c,User_Icon_Options__c,Language__c FROM Account_Setting__c where Account__c=:AccID  and is_Active__c=true limit 1];
                accountProducts=[select Account__c, Total_Quantity_Sold__c,Is_Recommended__c,Account__r.Name,Product__c,In_HomeBanner__c,is_in_Top_Sales__c,Id from Account_Products__c where Account__c=:AccID and Product__r.isActive=true Order by Total_Quantity_Sold__c DESC];
                Integer i=0;
                Integer topSalesCount=0;
                for(Account_Products__c ap:accountProducts){                                            
                     
                    if(ap.In_HomeBanner__c){
                        prodIds.add(ap.Product__c);
                        System.debug('%%%%%%%'+ap.Product__c);
                        counts.Add(i++);            
                    }
                    
                    if(ap.is_in_Top_Sales__c){
                        topSaleProducts.add(ap.Product__c);
                    }else if(topSalesCount<=6 && ap.Total_Quantity_Sold__c>0){
                        topSaleProducts.add(ap.Product__c);
                        topSalesCount++;                
                    }
                    
                    if(ap.Is_Recommended__c){               
                        recommendedProducts.add(ap.Product__c);                 
                    }
                    allProdIds.add(ap.Product__c);
                }
                
                if(aSet.Social_Media__c!=null){
                    socialMedia=aSet.Social_Media__c.Split(';');                
                }
                if(aSet.Brands__c!=null){
                    //aSet.Brands__c = aSet.Brands__c.trim();
                    system.debug('@@@@@'+String.valueOf(aSet.Brands__c));
                    portalBrandsList= (String.valueOf(aSet.Brands__c)).Split(';');
                }
                
                if(aSet.Price_Book__c!=null){
                    priceBookEntryList = [SELECT Id,ProductCode,UnitPrice,Product2.Description,Product2.Name,Product2.Image__c,Product2.Category__c,Product2.Brand__c,Product2.Stock__c,Product2.isActive,Product2.Family FROM PricebookEntry where product2id in: allProdIds and priceBook2Id=:aSet.Price_Book__c and  Product2.Brand__c in : portalBrandsList and Product2.isActive=true];
                }

                portalBrandsList.sort();
                productBrands.addAll(portalBrandsList);
            }Catch(Exception e){}                
                
        
        List<OrderItem> latestProducts = new List<OrderItem>();
        latestProducts=[SELECT Id,createdByid,PricebookEntryId,PricebookEntry.Product2Id FROM OrderItem where createdById=:UserInfo.getUserId() limit 8];
        if(latestProducts.size()>0){
            for(OrderItem oi:latestProducts){
                    recommendedProducts.add(oi.PricebookEntry.Product2Id);              
            }
        }

        System.debug('!!!!!!'+allProdIds);
        
        cartList= [SELECT Account__c,Deletion_Date__c,Price__c,Id,Name,Product_Id__c,Quantity__c,Product_Id__r.Image_URL__c,Product_Id__r.Image__c,Product_Id__r.Name,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c where User_Id__c=:u.Id];                
        
        for(Shopping_Cart__c cartObj : cartList){
            System.debug('$$$$$'+cartObj.Price__c);            
            wrapJSONList.add(new listJSONWrapper(cartObj.Product_Id__r.Image__c,cartObj.Product_Id__r.Name,String.valueOf(cartObj.Price__c),String.valueOf(cartObj.Quantity__c),String.valueOf(cartObj.Product_Id__c)));
        }
        jsonString = JSON.serialize(wrapJSONList); 
        
        mapLabels = Hard_Coded_Labels__c.getAll();
        
        /*if(Userinfo.getUserType() != 'Standard'){
            Account Ac = [Select id,(Select id,Theme__c,Top_Phone__c,Top_Email__c from Account_Settings__r) 
                          from Account where Id =: 
                          ([select AccountId from user where Id =: Userid]).id];
            AccountSetting = Ac.Account_Settings__r[0];         
        }*/ 
    }
    
    private Map<String,List<PriceBookEntry>> returnProducts(List<PriceBookEntry> pBEntryList){  
        if(pBEntryList.size()>0){
            List<PriceBookEntry> tempObj = new List<PriceBookEntry>();          
         for(PriceBookEntry pEntryObj:pBEntryList){         
              
             if(prodIds.size()>0 && prodIds.Contains(pEntryObj.Product2Id)){                
                 if(productsMap.containsKey('HomeBanner')){
                     tempObj=productsMap.get('HomeBanner');
                     tempObj.add(pEntryObj);
                     productsMap.put('HomeBanner',tempObj);
                 }else{
                    tempObj.add(pEntryObj);
                    productsMap.put('HomeBanner',tempObj);
                 }
                 
             }               
             
             tempObj.clear();            
             if(topSaleProducts.size()>0 && topSaleProducts.Contains(pEntryObj.Product2Id)){                
                 if(productsMap.containsKey('TopSales')){
                     tempObj=productsMap.get('TopSales');
                     tempObj.add(pEntryObj);
                     productsMap.put('TopSales',tempObj);
                 }else{
                    tempObj.add(pEntryObj);
                    productsMap.put('TopSales',tempObj);
                 }               
             }
             
             tempObj.clear();
             
             if(recommendedProducts.size()>0 && recommendedProducts.Contains(pEntryObj.Product2Id)){                
                 if(productsMap.containsKey('RecProducts')){
                     tempObj=productsMap.get('RecProducts');
                     tempObj.add(pEntryObj);
                     productsMap.put('RecProducts',tempObj);
                 }else{
                    tempObj.add(pEntryObj);
                    productsMap.put('RecProducts',tempObj);
                 }
                 
             }
             
             tempObj.clear();             
             if(allProdIds.size()>0 && productBrands.size()>0 && allProdIds.Contains(pEntryObj.Product2Id) && productBrands.contains(pEntryObj.Product2.Brand__c)){             
                 if(productsMap.containsKey('BrandMap')){
                     tempObj=productsMap.get('BrandMap');
                     tempObj.add(pEntryObj);
                     productsMap.put('BrandMap',tempObj);                    
                 }else{
                    tempObj.add(pEntryObj);
                    productsMap.put('BrandMap',tempObj);                    
                 }               
             }
             
             tempObj.clear();
                                    
         }
        }
        
        return productsMap;
    }
    
    public static Map<Integer,Map<String,List<String>>> getTabNames(){
        System.debug('000000000'+AccID);
        Map<Integer,Map<String,List<String>>> tabsMap = new Map<Integer,Map<String,List<String>>>();
        accSet = new Account_Setting__c();        
        try{
            if(!String.isBlank(AccID)){
                accSet=[select id,Account__c,Image_URL__c,Theme__c,Copyright_Text__c,Footer_Links__c,is_Active__c,No_of_Items_Per_Page__c,User_Icon_Options__c from Account_Setting__c where Account__c=:AccID and is_Active__c=true limit 1];
                tabSet=[SELECT Account__c,Display_Order__c,Id,is_Active__c,Name,Submenus_for_Tab__c,Tab_Name__c,Tab_URL__c FROM Tab_Setting__c where Account__c=:AccID and is_Active__c=true limit 6];        
            }
            
            
            if(accSet!=null && !String.isBlank(accSet.Image_URL__c) && !String.isBlank(accSet.Theme__c)){
                partnerBrandLogo = accSet.Image_URL__c;        
                partnerTheme = accSet.Theme__c;
                if(!String.isBlank(accSet.User_Icon_Options__c)){
                    iconOptions = accSet.User_Icon_Options__c.split(';');
                }
            }        
            
            for(Tab_Setting__c tabS:tabSet){
                Map<String,List<String>> tempMenuList = new Map<String,List<String>>();
                List<String> menuList = new List<String>();
                if(!String.isBlank(tabS.Tab_Name__c) && !String.isBlank(tabS.Submenus_for_Tab__c)){
                    menuList=tabS.Submenus_for_Tab__c.split(';');  
                    tempMenuList.put(tabS.Tab_Name__c,menuList);                            
                }else if(!String.isBlank(tabS.Tab_Name__c)){
                     tempMenuList.put(tabS.Tab_Name__c,menuList);  
                }
                 
                tabsMap.put(Integer.valueOf(tabS.Display_Order__c),tempMenuList); 
                 
            }
        }catch(Exception e){
            System.debug('Exception found: at line# '+e.getLineNumber());
        }
       
        System.debug('%%%%%'+tabsMap);
        return tabsMap;
    }  
    
    public static string getClassname(){
        if(aSet.Theme__c!= null){
            return aSet.Theme__c;
        }else{
            return 'green';
        }       
          
    }
    
    public static string getTopheader(){
        if(aSet!= null){
            return '<li><a href=""><i class="fa fa-phone"></i> '+aSet.Top_Phone__c+'</a></li><li><a href=""><i class="fa fa-envelope"></i> '+aSet.Top_Email__c+'</a></li>';
        }else{
            return null;
        }
    }
    
    public List<PriceBookEntry> getHomeBannerProducts(){
         List<PriceBookEntry> prodList = new List<PriceBookEntry>();            
         if(priceBookEntryList.size()>0){
             for(PriceBookEntry pEntryObj:priceBookEntryList){
                 System.debug('#######'+pEntryObj.Product2Id+'\n'+prodIds);
                 if(prodIds.Contains(pEntryObj.Product2Id)){
                    prodList.add(pEntryObj); 
                 }
             }
         }
         //prodList =  [select id,Image__c,name,Brand__c,Category__c,Stock__c,Total_Quantity_Sold__c,RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and id in:prodIds limit 10]; 
         System.debug('--->prodList'+prodList);
         return prodList;
    }
    
    public List<PriceBookEntry> getTopSales(){
        List<PriceBookEntry> prodList = new List<PriceBookEntry>();
         if(priceBookEntryList.size()>0){
             for(PriceBookEntry pEntryObj:priceBookEntryList){
                 if(topSaleProducts.Contains(pEntryObj.Product2Id)){
                    prodList.add(pEntryObj); 
                 }
             }
         }
         //prodList =  [select id,Image__c,name,Brand__c,Category__c,Stock__c,Total_Quantity_Sold__c,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:aSet.Price_Book__c limit 1),RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and id in:topSaleProducts limit 10]; 
         System.debug('--->prodList'+prodList);
         return prodList;       
    }   

    public  Map<String,List<PriceBookEntry>>  getBrandNames(){
        Map<String,List<PriceBookEntry>> brandList = new Map<String,List<PriceBookEntry>>();   
        System.debug('!!!!!!'+allProdIds);      
        System.debug('!!!!!!'+productBrands);  
        List<PriceBookEntry> prodList = new List<PriceBookEntry>(); 
        if(priceBookEntryList.size()>0){
             for(PriceBookEntry prodObj:priceBookEntryList){
                System.debug('BrandProductsssssss'+prodObj.Product2.Brand__c);
                 if(allProdIds.Contains(prodObj.Product2Id) && productBrands.contains(prodObj.Product2.Brand__c)){
                    //prodList.add(pEntryObj); 
                    List<PriceBookEntry> temProductList = new List<PriceBookEntry>();
    
                    if(brandList.ContainsKey(prodObj.Product2.Brand__c.deleteWhitespace())){
                        temProductList= brandList.get(prodObj.Product2.Brand__c.deleteWhitespace());
                        temProductList.add(prodObj);
                        brandList.put(prodObj.Product2.Brand__c.deleteWhitespace(),temProductList);
                    }else{
                        temProductList.add(prodObj);
                        brandList.put(prodObj.Product2.Brand__c.deleteWhitespace(),temProductList);
                        system.debug('AAAAAAAaa'+prodObj.Product2.Brand__c.deleteWhitespace()+'\n'+temProductList);
                    }
                    
                 }
             }
        }
       
        System.debug('-------->'+brandList);
        return brandList;
    }   
    
    public Map<String,Integer> getBrandCounts(){
        Map<String,Integer> brandCountsMap = new Map<String,Integer>();
        List<AggregateResult>  prodList = [select Brand__c , count(id) myCount  from Product2 where IsActive=true  and id in:allProdIds and Brand__c in :productBrands  group by Brand__c];       
        if(prodList.size()>0){
            for(AggregateResult ar:prodList){
                brandCountsMap.put((String)ar.get('Brand__c'),(Integer)ar.get('myCount'));
            }
        }
        System.debug('$$$$$$$$'+brandCountsMap);
        return brandCountsMap;
    }
    
    public List<PriceBookEntry> getRecommendedProducts(){
        List<PriceBookEntry> recProducts = new List<PriceBookEntry>();
        if(recommendedProducts.size()>0){
            if(priceBookEntryList.size()>0){
                 for(PriceBookEntry pEntryObj:priceBookEntryList){
                     if(recommendedProducts.Contains(pEntryObj.Product2Id)){
                        recProducts.add(pEntryObj); 
                     }
                 }
            }
            //recProducts = [select id,Image__c,name,Brand__c,Category__c,Stock__c,Total_Quantity_Sold__c,(SELECT Id,UnitPrice,Pricebook2Id,Product2Id FROM PricebookEntries where Pricebook2Id=:aSet.Price_Book__c limit 1),RecordTypeId,RecordType.DeveloperName,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true and id in:recommendedProducts limit 8];       
        }
        
        return recProducts;
    }
    
    public Map<Integer,Map<String,List<String>>> getFooterLinks(){
        
        Map<Integer,Map<String,List<String>>> footerMap = new Map<Integer,Map<String,List<String>>>();       
        footerSet=[SELECT Account__c,Display_Order__c,Submenus_for_Footers__c,Header_Name__c,Id,is_Active__c FROM Footer_Settings__c where is_Active__c=true and Account__c =:AccID];                              
        
        for(Footer_Settings__c footerS:footerSet){
            Map<String,List<String>> tempMenuList = new Map<String,List<String>>();
            List<String> menuList = new List<String>();
            if(!String.isBlank(footerS.Header_Name__c) && !String.isBlank(footerS.Submenus_for_Footers__c)){
                menuList=footerS.Submenus_for_Footers__c.split(';');  
                tempMenuList.put(footerS.Header_Name__c,menuList);                            
            }else if(!String.isBlank(footerS.Header_Name__c)){
                 tempMenuList.put(footerS.Header_Name__c,menuList);  
            }
             
            footerMap.put(Integer.valueOf(footerS.Display_Order__c),tempMenuList); 
             
        }
        
        return footerMap;
    }
    
    public static pageReference insertToCart(String selectedPrdId,String pricebook){
        Shopping_Cart__c cartObj = new Shopping_Cart__c();
        System.debug('selectedPrdId------'+selectedPrdId+'\n'+pricebook);
        if(selectedPrdId!=''){
           
            try{
                cartObj=[Select Id,Product_Id__c,Quantity__c,User_Id__c from Shopping_Cart__c where Product_Id__c=:selectedPrdId and User_Id__c=:Userid limit 1];                
                    cartObj.Quantity__c = cartObj.Quantity__c+Decimal.valueOf('1');//cartObj.Quantity__c+1;
                    //cartObj.SubTotal__c=cartObj.Quantity__c*cartObj.Price__c;               
                update cartObj;         
                System.debug('updated....');
                            
            }catch(Exception e){
                //System.debug('Exception found'+e.getMessage());
                
                    if(cartObj==null || cartObj.id==null){
                        PriceBookEntry pbObj = new PriceBookEntry();
                        pbObj = [SELECT Id,UnitPrice,Product2.Description,Product2.Name,Product2.Image__c,Product2.Category__c,Product2.Brand__c,Product2.Stock__c,Product2.isActive,Product2.Family FROM PricebookEntry where Product2Id=:selectedPrdId and PriceBook2Id=:pricebook limit 1];
                        cartObj.Quantity__c=1;
                        cartObj.Account__c=AccID;
                        cartObj.Price__c=pbObj.UnitPrice;
                        cartObj.Product_Id__c= selectedPrdId;
                        cartObj.User_Id__c =Userid ;
                        cartObj.SubTotal__c=pbObj.UnitPrice;                        
                        insert cartObj;        
                        System.debug('Inserted======');      
                    }
               
            }
        }
        
        return null;
    }
    /*
    public Pagereference placeOrder(){
        Opportunity Opp = new Opportunity();
        Opp.Name = 'transactionid';
        Opp.AccountId = AccID;
        Opp.StageName ='Closed Won';
        Opp.CloseDate = System.Today();
        Insert Opp;
        
        List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
            
        List<PricebookEntry> pBook = [SELECT Id,Name,Pricebook2Id,Product2Id,UnitPrice,IsActive  FROM PricebookEntry WHERE Pricebook2Id=:aSet.Price_book__c and IsActive =true];
            
        Map<Id,PricebookEntry> priceEntryMap = new Map<Id,PricebookEntry>();
        
        if(pBook.size()>0){
            for(PricebookEntry pEntry:pBook){
                
                priceEntryMap.put(pEntry.Product2Id,pEntry);
            }
        }
                    
        cartList= Portal_globalClass.cartList;//[SELECT Account__c,Deletion_Date__c,Price__c,Id,Name,Product_Id__c,Quantity__c,Product_Id__r.Image_URL__c,Product_Id__r.Image__c,Product_Id__r.Name,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c where User_Id__c=:userInfo.getUserId()];
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
                createOrderAndOLineItems('transactionid',opp,oli);                
        }
        
        PageReference newPage= new PageReference('/Portal_Home_Copy');
        newPage.setRedirect(true);
        
        return newPage;  
        
    }
    
     public static void createOrderAndOLineItems(String transactionId,Opportunity optyObj, List<OpportunityLineItem> optyLineItems){
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
        
    }*/
    
}