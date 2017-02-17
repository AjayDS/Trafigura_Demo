trigger createorder on Opportunity(after insert,after update){
list<order> ord= new list<order>();
    Account acc = new Account();
    Id accId;    
    User con = new User();
    try{
        con = [select contactid,id from User where id=:userInfo.getUserId()];
        accId = [select id,Name from Contact  where id=:con.id].Accountid;    
    }catch(Exception e){
        if(accId==null){
            accId=[select id from Account where name='Guest User' limit 1].id;
        }
    }
    
    System.debug('1----'+Trigger.isAfter +'\n'+Trigger.isInsert);
    if(Trigger.isAfter && Trigger.isInsert){        
        for(opportunity opp:trigger.new){
        if(opp.StageName=='Closed Won'){
            order o=new order();
            o.EffectiveDate=opp.CloseDate;
            o.status='created';
            o.AccountId=accId;   
            System.debug('3----'+ o.AccountId);
            o.CurrencyIsoCode=opp.CurrencyIsoCode;
            o.OpportunityId=opp.Id;
            ord.add(o);
        }
        }
        insert ord; 
        System.debug('2----'+ord);     
    } 
}