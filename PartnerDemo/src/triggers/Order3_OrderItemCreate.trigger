trigger Order3_OrderItemCreate on Order (after insert, before update) {

    
    Set<id> Opp_Ids = new Set<id>();
    //Set<Id> opp = (new Map<Id, opportunity>([SELECT Id FROM Opportunity ])).keySet();
    //set<id> opp = new set<id>();
    for (Order opp : trigger.new) {
     //opportunity[] opp=new List<Opportunity>();
      //opp= [SELECT Id FROM Opportunity where id='00636000009Ra1xAAC'];
       //opp =[SELECT Id,Name FROM Opportunity WHERE Name = '1A782792W3003070T'];
       system.debug('++++opp'+opp);
        Opp_Ids.add(opp.id);
    }

   
    OpportunityLineItem[] OLItem = [Select OpportunityId, 
            Id,
            Quantity,
            UnitPrice,
            PriceBookEntryId
        from OpportunityLineItem where OpportunityId in :Opp_Ids];
        
    Map<id, OpportunityLineItem> OliMap = new Map<id, OpportunityLineItem>();
    for (OpportunityLineItem olimap1 : OLItem)
        OliMap.put(olimap1.Id, olimap1);
 
    OrderItem[] clis = new OrderItem[]{};
    for (Order sc : trigger.new) {
        string opptyId = sc.Opportunity.id; 
        system.debug('+yyyyy'+opptyid);   
    for (OpportunityLineItem oli : OLItem) {
            system.debug('Debug it: ' + OliMap.get(oli.Id).PriceBookEntryId);
            if (oli.OpportunityId == opptyId) {
                OrderItem cli = new OrderItem();
                cli = new OrderItem();
                    cli.UnitPrice = OliMap.get(oli.Id).UnitPrice;
                    cli.Quantity = OliMap.get(oli.Id).Quantity;
                    cli.PriceBookEntryId = OliMap.get(oli.Id).PriceBookEntryId;
                clis.add(cli);
                system.debug('UUUUU'+cli);
            }
        }
    }
    
    insert clis;

}