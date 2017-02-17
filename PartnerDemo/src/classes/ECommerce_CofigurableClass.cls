public class ECommerce_CofigurableClass{
    
    public Account_Setting__c accSet{get;set;}
    public List<Tab_Setting__c> tabSet{get;set;}
    public String partnerBrandLogo;
    public String partnerTheme;
    public String footerLinkHeader{get;set;}
    public List<String> footerLinks{get;set;}   
    public List<String> iconOptions{get;set;} 
    
    public Map<Integer,Map<String,List<String>>> getTabNames(Id accId){
        System.debug('000000000'+accId);
        Map<Integer,Map<String,List<String>>> tabsMap = new Map<Integer,Map<String,List<String>>>();
        accSet = new Account_Setting__c();        
        accSet=[select id,Account__c,Image_URL__c,Theme__c,Copyright_Text__c,Footer_Links__c,is_Active__c,No_of_Items_Per_Page__c,User_Icon_Options__c from Account_Setting__c where Account__c=:accId and is_Active__c=true limit 1];
        tabSet=[SELECT Account__c,Display_Order__c,Id,is_Active__c,Name,Submenus_for_Tab__c,Tab_Name__c,Tab_URL__c FROM Tab_Setting__c where Account__c=:accId and is_Active__c=true limit 6];        
        
        
        if(accSet!=null && !String.isBlank(accSet.Image_URL__c) && !String.isBlank(accSet.Theme__c)){
            partnerBrandLogo = accSet.Image_URL__c;        
            partnerTheme = accSet.Theme__c;
            if(!String.isBlank(accSet.Footer_Links__c)){
                footerLinks = accSet.Footer_Links__c.split(';');
                footerLinkHeader= footerLinks[0];
                footerLinks.remove(0);
            }
            if(!String.isBlank(accSet.User_Icon_Options__c)){
                iconOptions = accSet.User_Icon_Options__c.split(';');
            }
        }        
        
        for(Tab_Setting__c tabS:tabSet){
            Map<String,List<String>> tempMenuList = new Map<String,List<String>>();
            List<String> menuList = new List<String>();
            if(!String.isBlank(tabS.Tab_Name__c) && !String.isBlank(tabS.Submenus_for_Tab__c)){
                menuList=tabS.Submenus_for_Tab__c.split(';');  
                tempMenuList.put(tabS.Tab_Name__c,menuList);                            
            }else if(!String.isBlank(tabS.Tab_Name__c)){
                 tempMenuList.put(tabS.Tab_Name__c,menuList);  
            }
             
            tabsMap.put(Integer.valueOf(tabS.Display_Order__c),tempMenuList); 
             
        }
        
       
        System.debug('%%%%%'+tabsMap);
        return tabsMap;
    }  
        
}