public class portal_Home {
    Portal_globalClass globalObj = new Portal_globalClass();
    public List<PriceBookEntry> topSales{get;set;}
    public Map<String,List<PriceBookEntry>> activeBrandList{get;set;} 
    public Set<String> productBrands{get;set;}
    public Map<String,List<PriceBookEntry>> brandList{get;set;}
    public String activeBrand{get;set;}
    public List<PriceBookEntry> recommendedProducts{get;set;}
    public List<PriceBookEntry> activeRecommendtn{get;set;}
    public String copyrightText{get;set;}
    public User userObj{get;set;}
    public Id AccID{get;set;}
    public static Account_Setting__c acSet{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public static String selectedPrdId{get;set;}
    public integer LimitSize{get;set;}
    public integer totalRecs = 0;
    public integer OffsetSize = 0;
            
    public portal_Home(){
        topSales = new List<PriceBookEntry>();
        productBrands = new Set<String>();
        List<String> prodBrands = new List<String>();
        LimitSize=2;

        brandList = new Map<String,List<PriceBookEntry>>();   
        productBrands= globalObj.productBrands;
        mapLabels = Hard_Coded_Labels__c.getAll();
        activeBrandList= new Map<String,List<PriceBookEntry>>(); 
        recommendedProducts= new List<PriceBookEntry>();
        activeRecommendtn = new List<PriceBookEntry>();
        userObj = new User();
        acSet= new Account_Setting__c ();
        AccID = Portal_globalClass.AccID;
        acSet = Portal_globalClass.aSet;
        
        
        topSales = globalObj.getTopSales();
        brandList = globalObj.getBrandNames();
        recommendedProducts = globalObj.getRecommendedProducts();
        copyrightText = Portal_globalClass.aSet.Copyright_Text__c;
        userObj = Portal_globalClass.u;
        if(productBrands.size()>0){
            for(String brnd:productBrands){
                brnd=brnd.deleteWhitespace();
                prodBrands.add(brnd);
            }
            
            system.debug('######'+productBrands);
            productBrands.clear();
            system.debug('######'+productBrands);
            productBrands.addAll(prodBrands);
            activeBrand =(new list<string>(productBrands)[0] );             
            productBrands.remove(new list<string>(productBrands)[0] );
        }
        
        if(brandList.size()>0 && activeBrand!=null){            
            activeBrandList.put(activeBrand,brandList.get(activeBrand));           
            brandList.remove(activeBrand);
        }
         system.debug('recommendedProducts.size()'+recommendedProducts.size());
         for(integer i=0;i<recommendedProducts.size();i++)
         {
             system.debug('recommendedProducts at :'+i+'  :'+recommendedProducts[i]);
         }
        if(recommendedProducts.size()>4){  
            
            for(Integer i=0;i<recommendedProducts.size();i++){                                
                activeRecommendtn.add(recommendedProducts[i]);                
                recommendedProducts.remove(i);
            }
            
        }else{
            activeRecommendtn=recommendedProducts.clone();  
            recommendedProducts.clear();
            System.debug('########'+recommendedProducts);
        }
        
    }
    
    public static PageReference insertQuantity(){ 
        acSet= new Account_Setting__c ();       
        Portal_globalClass globalObj = new Portal_globalClass();
        acSet = Portal_globalClass.aSet;
        System.debug('Ajayyyyy'+selectedPrdId);
        if(selectedPrdId!=''){
             System.debug('Ajayyyyy'+acSet.price_Book__c);
             Portal_globalClass.insertToCart(selectedPrdId,acSet.price_Book__c);
        }
        
        return null;
    }
    
    public void FirstPage()
    {
        OffsetSize = 0;
    }
    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
    }
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        
    }
    public void LastPage()
    {
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        system.debug('LastPage----'+totalRecs+LimitSize);
    }
    public boolean getprev()
    {   
        
        if(OffsetSize == 0)
        return true;
        else
        return false;
    }
    public boolean getnxt()
    {   
        
        if((OffsetSize + LimitSize) < totalRecs)
        return true;
        else
        return false;
    }

    
    
        
}