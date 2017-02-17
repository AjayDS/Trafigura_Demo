public  class OrderListController
{
     public Id orderId{get;set;}
     
     Public List<OrderItem> getordProducts()
     {
         List<OrderItem> ordPro;
         ordPro = [SELECT Id, OrderId, OrderItemNumber, PricebookEntry.Product2.Name,PricebookEntry.Product2.Image_Url__c, PricebookEntry.Product2.Productcode, Quantity, UnitPrice, Total_Price__c FROM OrderItem ];
         return ordpro;
     }
     
}