public class Portal_headerCls {
    public Account_Setting__c accSet{get;set;}
    public String partnerLogo{get;set;}
    Portal_globalClass globalObj = new Portal_globalClass(); 
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;} 
    public List<String> socialMedia{get;set;}
    public String phoneNum{get;set;}
    public String emailId{get;set;}
    public String loggedinUser{get;set;}
    
    
    public Portal_headerCls(){
        accSet = new Account_Setting__c();                
        socialMedia= new List<String>();
        accSet = Portal_globalClass.aSet;
        partnerLogo=accSet.Image_URL__c;
        mapLabels=globalObj.mapLabels;
        socialMedia = globalObj.socialMedia;
        loggedinUser=Portal_globalClass.u.lastName;
        
    }
    
    public string getClassname(){
        Portal_globalClass globalObj = new Portal_globalClass();
        string clsName = Portal_globalClass.getClassname() ;
        
        if(clsName == 'main'){
            return 'main.css';
        }else if(clsName == 'Green'){
            return 'greenmain.css';
        }
        else if(clsName == 'Blue'){
            return 'main.css';
        }else{
            return 'main.css';
        }
        
    }
    public string gettopcontent(){
        Portal_globalClass globalObj = new Portal_globalClass();
        string topCon = Portal_globalClass.getTopheader() ;
        if(topCon != null){
            return topCon;
        }else{
            return '<li><a href=""><i class="fa fa-phone"></i> +1 512 968 9962 </a></li><li><a href=""><i class="fa fa-envelope"></i> info@harman.com</a></li>';
        }
    }
    
    
}