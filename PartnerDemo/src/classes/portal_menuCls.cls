public class portal_menuCls {

    public String searchText { get; set; }
    public Map<Integer,Map<String,List<String>>> tabMenus{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    Portal_globalClass globalObj = new Portal_globalClass();
    public String accId{get;set;}
     public String family{get;set;}
    
    public portal_menuCls(){
        tabMenus = new Map<Integer,Map<String,List<String>>>();
        tabMenus = Portal_globalClass.getTabNames();
        mapLabels = Hard_Coded_Labels__c.getAll();
        accId=Portal_globalClass.AccID;
    }  
    
}