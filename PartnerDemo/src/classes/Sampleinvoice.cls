public class Sampleinvoice {

    public Date invoiceDate {get;set;}
    public String selectedOrder{get;set;}
    public Order order{get;set;}
    public Sampleinvoice() {
    
    //SELECT Account__c,Description__c,Id,Name,OwnerId,Price__c,Product_Id__c,Quantity__c,Shipping_Details__c,SubTotal__c,User_Id__c FROM Shopping_Cart__c 
    }
    
     public PageReference getOrderDetails(){       
     system.debug('inside getOrderDetails');
     try{
     order=new Order();
     order= [SELECT AccountId,BillingAddress,BillingCity,BillingCountry,BillingState,BillingStreet,Description,EndDate,Id,OriginalOrderId,OwnerId,Phone_Number__c,Pricebook2Id,Product_Description__c,ShippingAddress,ShippingCity,ShippingCountry,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,Shipping_Date__c,Status,StatusCode,SystemModstamp,TotalAmount,Type,User_Id__c FROM Order where OrderNumber = :selectedOrder];
   
     }catch(Exception e){
         order= new Order();
     }
      return null;
   }
}