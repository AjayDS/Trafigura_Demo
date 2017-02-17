public class portal_topAdvcls {
  
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}    
    public Portal_globalClass ecomAccConfig = new Portal_globalClass();   
    public List<PriceBookEntry> homeBannerProdList{get;set;}
    public List<PriceBookEntry> homeBannerFirstProduct{get;set;}
    public List<Integer> counts{get;set;}
    public String loggedinUser{get;set;}
          
    public portal_topAdvcls(){                         
        homeBannerProdList = new List<PriceBookEntry>();
        homeBannerFirstProduct= new List<PriceBookEntry>();
        counts = new List<Integer>();
        try{
            homeBannerProdList= ecomAccConfig.getHomeBannerProducts();
            loggedinUser=Portal_globalClass.u.Lastname;
            counts=ecomAccConfig.counts;
            if(homeBannerProdList.size()>0){
                homeBannerFirstProduct.add(homeBannerProdList[0]);
                homeBannerProdList.remove(0);
            }               

        }catch(Exception e){
            system.debug('>>>>>'+e.getMessage());
        }
   
        mapLabels = Hard_Coded_Labels__c.getAll();
        
        //selectedLang = ApexPages.currentPage().getParameters().get('lang');  
    }           
}