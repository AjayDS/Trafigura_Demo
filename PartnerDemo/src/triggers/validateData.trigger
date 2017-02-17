trigger validateData on Account (Before insert,before update) {
    String s;
    List<Account> accList;
    String acId;
    Opportunity optyObj;
    
    if(Trigger.isBefore && Trigger.isInsert){    
        
        s.toLowerCase();// Since s is null, this call causes a NullPointerException 
    }

    for(Account accObj:Trigger.new){
        if(Trigger.isBefore && Trigger.isupdate){    
            accList =[select id from account where id=:s];
            //acId=accList[0].Id;       
        }
        
        
        
        optyObj=[select id from Opportunity where accountid=:s];
        update optyObj;
        
                
        
    }
    
    
    
}