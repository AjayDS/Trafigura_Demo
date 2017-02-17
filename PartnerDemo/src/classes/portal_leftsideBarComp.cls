public class portal_leftsideBarComp{
    Portal_globalClass globalObj = new Portal_globalClass();
    //portal_productCls prodClsObj = new portal_productCls();
    public Account_Setting__c aSetObj{get;set;}
    public String accName{get;set;}
    public Integer catSize{get;set;}
    public Integer brandSize{get;set;}
    public Map<String,set<String>> categoryAndBrandMap{get;set;}
    //public Map<string,Category_and_Brand_Mapping__c> categoryBrandMapsCS{get;set;}  
    public List<String> brandNames;
    public Map<String,String> allowedCategories{get;set;}
    public Map<String,Integer> brandsWithCount{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public String AccId{get;set;}
    public List<PriceBookEntry> pricebookList{get;set;} 
    
    public portal_leftsideBarComp(){
        aSetObj = new Account_Setting__c();
        categoryAndBrandMap = new Map<String,set<String>>();
        brandNames = new List<String>();    
        //categoryBrandMapsCS = new Map<string,Category_and_Brand_Mapping__c>();
        allowedCategories = new Map<String,String>();
        brandsWithCount = new Map<String,Integer>(); 
        pricebookList = new List<PriceBookEntry>();
                
        accName=Portal_globalClass.partnerName;        
        aSetObj = Portal_globalClass.aSet; 
        AccId=aSetObj.Account__c;//'0013600000SAesPAAT';      
        brandsWithCount = globalObj.getBrandCounts();
        pricebookList = globalObj.priceBookEntryList;
        //categoryBrandMapsCS = Category_and_Brand_Mapping__c.getAll();  
        categoryAndBrandMap = getCategoryBrandMap(pricebookList);
        catSize= categoryAndBrandMap.size();
        brandSize= pricebookList.size();
        Integer categoryLimit=0;
        mapLabels = Hard_Coded_Labels__c.getAll();
        if(Portal_globalClass.aSet.Category_Limit__c==null){
            Portal_globalClass.aSet.Category_Limit__c=25;
        }
        
        if(Portal_globalClass.aSet.Categories__c!=null && !String.isBlank(Portal_globalClass.aSet.Categories__c)){
            for(String str:Portal_globalClass.aSet.Categories__c.split(';')){               
                allowedCategories.put(str,str);
            }
        }
        
        System.debug('---*******'+categoryAndBrandMap.values());
    }
    
    public Map<String,set<String>> getCategoryBrandMap(List<PriceBookEntry> pbList){
        Map<String,set<String>> categoryBrandMap = new Map<String,set<String>>();       
        
        if(pbList.size()>0){
                
                for(PriceBookEntry pbObj:pbList){
                    set<String> brandList  = new set<String>();                 
                    if(pbObj.product2.Category__c!=null){
                        if(categoryBrandMap.containsKey(pbObj.product2.Category__c)){
                            brandList = categoryBrandMap.get(pbObj.product2.Category__c);   
                            brandList.add(pbObj.product2.Brand__c);
                            categoryBrandMap.put(pbObj.product2.Category__c,brandList);                          
                        }else{
                            brandList.add(pbObj.product2.Brand__c);
                            categoryBrandMap.put(pbObj.product2.Category__c,brandList);                            
                        }
                    }
                }
                
        }
        system.debug('AAAAAAAAAAA'+categoryBrandMap);
        return categoryBrandMap;
    }
    
    /*public List<PriceBookEntry> getSelectedProductsList(){
        
        return prodClsObj.getSelectedProducts();
    }*/
    
    
    
    
    
}