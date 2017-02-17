public with sharing class refined_search {

Portal_globalClass globalObj = new Portal_globalClass();
    public List<Product2> topSales{get;set;}
    public Map<String,List<Product2>> activeBrandList{get;set;} 
    public List<String> productBrands{get;set;}
    public Map<String,List<Product2>> brandList{get;set;}
    public String activeBrand{get;set;}
    public List<String> categories {get;set;}
    
    public refined_search (){
        topSales = new List<Product2>();
        productBrands = new List<String>();
        brandList = new Map<String,List<Product2>>();   
        productBrands= globalObj.productBrands;
        activeBrandList= new Map<String,List<Product2>>(); 
        
       Schema.DescribeFieldResult categoryList= Product2.Category__c.getDescribe();

        List<Schema.PicklistEntry> categoryListValues = categoryList.getPicklistValues();
        system.debug('categoryListValues :'+categoryListValues );
        categories= new List<String>();
        for(Schema.PicklistEntry picklistVal:categoryListValues ){
            
            if(!picklistVal.getValue().contains('None')){
             system.debug('categoryListValues :'+picklistVal.getValue());
                categories.add(picklistVal.getValue());
            }
        
           
        }
        
        topSales= globalObj.getTopSales();
        brandList=globalObj.getBrandNames();
        if(productBrands.size()>0){
            activeBrand=productBrands[0];
            productBrands.remove(0);
        }
        if(brandList.size()>0 && activeBrand!=null){            
            activeBrandList.put(activeBrand,brandList.get(activeBrand));
            system.debug('######'+activeBrandList);
            //brandList.remove(activeBrand);
        }
    }
}