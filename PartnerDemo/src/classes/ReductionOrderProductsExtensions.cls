public class ReductionOrderProductsExtensions {

    public List<OrderItem> orderItems{get;set;}
    public List<OrderItem> orderItems2{get;set;}
    public String oId;
    public List<OrderItemWrapper> orderItemList{get;set;}
    public List<Id> oiIds = new List<Id>();
    public List<OrderItem> selectedOItems = new list<OrderItem>();
    public List<OrderItem> oItemsToInsert = new list<OrderItem>();

    public ReductionOrderProductsExtensions(ApexPages.StandardController controller) {
          oId = ApexPages.currentPage().getParameters().get('OrderId');
          this.orderItemList  = new List<OrderItemWrapper>();  
          getOrderItemSet();  
      }

    public void getOrderItemSet()
     {        
         Order o = [select AccountId,Id from Order where Id = :oId];
         orderItems = [select orderId,Order.AccountId,quantity,Pricebookentry.Product2.Name,ListPrice,UnitPrice,Order.Status from OrderItem 
                            where Order.AccountId =: o.AccountId ];
         set<String> uniqueOItems = new set<String>();

         for(OrderItem oi:orderItems){
             if(!uniqueOItems.contains(oi.Pricebookentry.Product2.Name )){  
                 uniqueOItems.add(oi.Pricebookentry.Product2.Name );
                  oiIds.add(oi.Id);
              }
           }   
         orderItems2 = [select orderId,Order.AccountId,quantity,Pricebookentry.Product2.Name,ListPrice,UnitPrice,Order.Status from OrderItem
                            where Id in: oiIds];
         for(OrderItem oi:orderItems2){
          this.orderItemList.add(new OrderItemWrapper(oi));
         }
     }

    public class OrderItemWrapper{

        public OrderItem oitem{get;set;}

        public Boolean selected{get;set;}

        public OrderItemWrapper(OrderItem o){
            this.oitem = o;
            this.selected = false;
        }

    }

    public PageReference save(){

     try{
          selectedOItems.clear();
         for(OrderItemWrapper owrapper : orderItemList){
            if(owrapper.selected == true)
             selectedOItems.add(owrapper.oitem);
           }

         list<id> selectedProductList = new list<Id>();

         for(OrderItem oi:selectedOItems){ 
         selectedProductList.add(oi.PricebookEntry.Product2Id);
        }

        list<OrderItem>oiList =  [Select o.PricebookEntry.ProductCode, o.PricebookEntry.IsActive, o.PricebookEntry.Product2Id, o.PricebookEntry.Pricebook2Id, o.PricebookEntry.Name, o.PricebookEntry.Id, o.PricebookEntryId, o.Id From OrderItem o where o.PricebookEntry.Product2Id in:selectedProductList];

         map<id,Id> pbemap = new map<Id,Id>();
         for(OrderItem oi:oiList){
             pbemap.put(oi.id, oi.PricebookEntryId);
         } 

         for(OrderItem oi:selectedOItems){
            OrderItem o = new OrderItem();
             o.PricebookEntryId = pbemap.get(oi.Id);
            o.Quantity = oi.Quantity;
            o.unitPrice = oi.UnitPrice;
            o.orderId = oId; 
            oItemsToInsert.add(o); 
          }

         if(oItemsToInsert.size()>0)
            insert oItemsToInsert;



           pageReference ref = ApexPages.currentPage(); 
           Id id = ref.getParameters().get('OrderId');
           ref.getParameters().clear();
           ref.getParameters().put('OrderId', id);  
           ref.setRedirect(true);
           return ref;

     }

     catch(Exception ex){

       ApexPages.addMessages(ex);

     }

     return null;

    }

    public PageReference cancel(){

      return new PageReference('/' + oId);

    }

}