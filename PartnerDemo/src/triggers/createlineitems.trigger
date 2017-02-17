trigger createlineitems on Order (before insert,after insert) {
      Pricebook2 standardBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
    if(trigger.isbefore)
    {
        for(Order saord : trigger.new)
        {
            saord.Pricebook2Id = standardbook.id;
            
        }
    }
    
    if(trigger.isafter)
    {
 
    list<Orderitem> lineitems = new list<Orderitem>();
        Pricebookentry entry = [SELECT Id,unitprice FROM PricebookEntry WHERE Pricebook2Id = :standardBook.Id AND Product2.ProductCode = '123'];
    for (Order o : trigger.new){
        if(o.Statuscode == 'D')
        {
            
            
            Orderitem oitem = new Orderitem();
            oitem.OrderId = o.id;
           
          oitem.PricebookEntryId = entry.Id;
            oitem.UnitPrice = entry.UnitPrice;
            oitem.Quantity = 1;
           
        lineitems.add(oitem);
      
   }
        
        
    }
    try{
    insert lineitems;
    }
    catch (Exception e)
    {
        e.getMessage();
    }
    }
    
}