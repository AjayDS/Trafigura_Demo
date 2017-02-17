public class portal_CheckoutCls{

    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public static String AccId{get;set;}
    public static List<Shopping_Cart__c> cartList{get;set;}
    public static String jsonString {get;set;}
    public static User u{get;set;}
    
    public portal_CheckoutCls(){
        cartList = new List<Shopping_Cart__c>();
        mapLabels = Hard_Coded_Labels__c.getAll();       
          
        jsonString = Portal_globalClass.jsonString;  
        u= Portal_globalClass.u;       
    }
       
    public Pagereference placeOrder(){
        Portal_globalClass globalObj = new Portal_globalClass();  
        AccId = Portal_globalClass.AccID; 
        Opportunity Opp = new Opportunity();        
        Opp.Name = 'transactionid';
        Opp.AccountId = AccID;
        if(Portal_globalClass.u.contactid!=null){
            opp.Contact__c = Portal_globalClass.u.contactid;
        }
        Opp.StageName ='Closed Won';
        Opp.CloseDate = System.Today();
        Insert Opp;
        
        List<OpportunityLineItem> oli = new List<OpportunityLineItem>();
         system.debug('JJJJJJJ'+Portal_globalClass.aSet.Price_book__c);   
        List<PricebookEntry> pBook = [SELECT Id,Name,Pricebook2Id,Product2Id,UnitPrice,IsActive  FROM PricebookEntry WHERE Pricebook2Id=:Portal_globalClass.aSet.Price_book__c and IsActive =true];
            
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
            order.Pricebook2Id =Portal_globalClass.aSet.Price_book__c;
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
}