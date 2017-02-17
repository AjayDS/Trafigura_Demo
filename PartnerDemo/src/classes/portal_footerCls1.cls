public class portal_footerCls1 {
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
    
    public portal_footerCls1(){        
        footerLinks = new Map<Integer,Map<String,List<String>>>();
        footerLinks= globalObj.getFooterLinks();
        copyrightText = Portal_globalClass.aSet.Copyright_Text__c;
        mapLabels = Hard_Coded_Labels__c.getAll();
        accId=globalObj.AccID;
    }
    
   
}