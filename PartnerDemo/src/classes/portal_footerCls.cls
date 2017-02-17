public class portal_footerCls {
    Portal_globalClass globalObj = new Portal_globalClass();
    //public Subscritption_Email__c = new Subscritption_Email__c();
    public String subtList{get;set;}
    //public string Subscritption_Email_id__c{get;set;}
    public String copyrightText{get;set;}
    public Map<Integer,Map<String,List<String>>> footerLinks{get;set;}
     public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public String AccId{get;set;}
    public string test{get;set;}
    public   Subscritption_Email__c sub{get;set;}
    public string mailId{get;set;}
    
    public portal_footerCls(){
        footerLinks = new Map<Integer,Map<String,List<String>>>();
        footerLinks= globalObj.getFooterLinks();
        copyrightText = Portal_globalClass.aSet.Copyright_Text__c;
        mapLabels = Hard_Coded_Labels__c.getAll();
        accId=Portal_globalClass.AccID;
    }
    
    @RemoteAction
    public static String subscribeEmail(String emailId){
         
        List<Subscritption_Email__c> sEmail = new List<Subscritption_Email__c>(); 
        try{
        sEmail = [select id,Subscription_Email_id__c from Subscritption_Email__c where Subscription_Email_id__c=:emailId limit 1];        
        }catch(Exception e){ }       
        
        if(sEmail.size()==0){
            Subscritption_Email__c sEmailObj = new Subscritption_Email__c();
            sEmailObj .Subscription_Email_id__c=emailId;        
            insert sEmailObj ;
            return 'Thank you for Subscription!!';
        }else if(sEmail.size()>0){
            return 'This Email Id has already registered.';        
        }else{
            return 'exception found.';
        }
        
        
    }
     
   
}