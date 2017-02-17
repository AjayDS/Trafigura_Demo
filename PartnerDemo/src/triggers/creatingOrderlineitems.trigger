trigger creatingOrderlineitems on Order (after insert)
{
    system.debug('@@@@');
    Set<Id> opportunityIds = new Set<Id>();
    List<Order> orderList = new List<Order>();
    Map<Id,String> optyPriceBookMap = new Map<Id,String>();
    
    
    for(Order o :trigger.new)
    {
        system.debug('{{{{'+o);
        if(o.OpportunityId != NULL )
        {
            system.debug('+++'+o);
            opportunityIds.add(o.OpportunityId);
            system.debug('666666'+opportunityIds);
            orderList.add(o);
            system.debug('888888'+orderlist);
            
        }
    }
    
    List<Opportunity> optyList = new List<Opportunity>();
    if(opportunityIds.size()>0){
        optyList =[select id,Pricebook2Id from Opportunity where id in : opportunityIds];
        for(Opportunity optyObj:optyList){
            optyPriceBookMap.put(optyObj.id,optyObj.PriceBook2Id);    
        }
        try{
        for(Order ordObj:orderList){
            ordObj.PriceBook2Id= optyPriceBookMap.get(ordObj.OpportunityId);
        }
        }
        catch(Exception e){
        system.debug('000000'+e);}
    }
    
     //Map<Id, Opportunity> oppsWithLineItems = new Map<Id, Opportunity>([SELECT Description,Id,ListPrice,Name,OpportunityId,Product2Id,ProductCode,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem where OpportunityId='00636000009RYHm']);
    //Map<Id, Opportunity> oppsWithLineItems = new Map<Id, Opportunity>([SELECT Id, (SELECT Description,Id,ListPrice,Name,OpportunityId,Product2Id,ProductCode,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem) WHERE Id IN:orderList]);
    Map<Id, List<OpportunityLineItem>> oppsWithLineItems = new Map<Id, List<OpportunityLineItem>>();
    for(OpportunityLineItem oLineItem:[SELECT Description,Id,ListPrice,Name,OpportunityId,Product2Id,ProductCode,PricebookEntryId,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem WHERE OpportunityId IN:OpportunityIds])
    {
    system.debug('****'+oLineItem);
    List<OpportunityLineItem> tempList = new List<OpportunityLineItem>();
    if(oppsWithLineItems.containsKey(oLineItem.OpportunityId))
    {
        system.debug('++++'+oLineItem);
        tempList= oppsWithLineItems.get(oLineItem.OpportunityId);
        tempList.add(oLineItem);
        oppsWithLineItems.put(oLineItem.OpportunityId,tempList);
        system.debug('____'+oppsWithLineItems);
    }else{
        tempList.add(oLineItem);
        oppsWithLineItems.put(oLineItem.OpportunityId,tempList);
    }   

}


    if(opportunityIds.size() > 0)
    {
        List<OrderItem> orderItemsForInsert = new List<OrderItem>();
        try{
        for(Order o : orderList)
        {
          list<Opportunitylineitem> oppWithLineItem = oppsWithLineItems.get(o.Opportunityid);
          for(OpportunityLineItem oli : oppWithLineItem)
            {
                orderItemsForInsert.add(new OrderItem(Quantity=oli.Quantity,OrderId=o.Id,PricebookEntryId=oli.PricebookEntryId));
                system.debug('---->'+orderItemsForInsert);
            }
            
           
        if(orderItemsForInsert.size() > 0)
        {
            insert orderItemsForInsert;
             system.debug('testing----->'+orderItemsForInsert);
        }
    }
    }
     catch(Exception e){system.debug('JJJJ');}
}
}