public class portal_productCls {

    public List<PriceBookEntry> productsList{get;set;}
    public String pFamilyName{get;set;}
    public String pBrand{get;set;}
    public String pCategory{get;set;}
    public integer LimitSize{get;set;}
    public integer totalRecs = 0;
    public integer OffsetSize = 0;
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;} 
    public Portal_globalClass globalObj{get;set;}
    public Set<Id> allProdIds{get;set;}
    public String priceBookid{get;set;}
    public List<String> portalBrandsList{get;set;}
    public static String selectedPrdId{get;set;}
    
    
    public portal_productCls(){
        mapLabels = new Map<string,Hard_Coded_Labels__c>();
        globalObj= new Portal_globalClass();
        portalBrandsList = new List<String>(Portal_globalClass.portalBrandsList);
        allProdIds = new Set<Id>(Portal_globalClass.allProdIds);
        LimitSize=Integer.valueOf(Portal_globalClass.aSet.No_of_Items_Per_Page__c);         
        mapLabels = Hard_Coded_Labels__c.getAll();
        priceBookid=Portal_globalClass.aSet.Price_Book__c;
        //productsList=selectedProducts();      
        totalRecs =  [select count() from PriceBookEntry where product2id in : allProdIds and priceBook2Id=:priceBookid and Product2.isActive=true ];//3;//productsList.size();

    }
    
    public List<PriceBookEntry> getSelectedProducts(){
              
        pFamilyName = apexpages.currentpage().getparameters().get('pfn');       
        pBrand=apexpages.currentpage().getparameters().get('pbrand');
        pCategory = apexpages.currentpage().getparameters().get('pcategory');
        List<PriceBookEntry> tempProductsList = new List<PriceBookEntry>();
         System.debug('======='+totalRecs);
        String searchQuery = 'SELECT Id,ProductCode,UnitPrice,Product2.Description,Product2.Name,Product2.Image__c,Product2.Category__c,Product2.Brand__c,Product2.Stock__c,Product2.isActive,Product2.Family FROM PricebookEntry where product2id in : allProdIds and priceBook2Id='+'\''+priceBookid+'\''+' and Product2.isActive=true';
        try{
            if(portalBrandsList.size()>0){
                searchQuery=searchQuery+' and Product2.Brand__c in : portalBrandsList';
            }
            if(!String.isBlank(pFamilyName)){
                searchQuery=searchQuery+' and Product2.Family=:pFamilyName';
            }
            
            if(!String.isBlank(pBrand)){                
                searchQuery=searchQuery+' and Product2.Brand__c=:pBrand';
            }
            
            if(!String.isBlank(pCategory)){
                searchQuery=searchQuery+' and Product2.Category__c=:pCategory';
            }
            searchQuery=searchQuery+ ' LIMIT :LimitSize OFFSET :OffsetSize';            
            tempProductsList = Database.query(searchQuery);        
            System.debug('======='+tempProductsList.size());      
            
        }catch(Exception e){
            System.debug(e.getMessage()+'--> no records found for this result. :(');
        }       
        
        return tempProductsList;
    
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
        system.debug('LimitSize--OffsetSize'+LimitSize+OffsetSize);
        //getnxt();
        
    }
    public void LastPage()
    {
        //OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        if(math.mod(totalRecs,LimitSize)==0)
        OffsetSize= totalrecs - LimitSize; 
        else
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        
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
        system.debug('LimitSize--OffsetSize'+LimitSize+OffsetSize);
        if((OffsetSize + LimitSize) >= totalRecs)
        return true;
        else
        return false;
    }
    
     public static PageReference insertQuantity(){           
        Portal_globalClass globalObj = new Portal_globalClass();        
        System.debug('Ajayyyyy'+selectedPrdId);
        if(selectedPrdId!=''){
             System.debug('Ajayyyyy'+Portal_globalClass.aSet.Price_Book__c);
             Portal_globalClass.insertToCart(selectedPrdId,Portal_globalClass.aSet.Price_Book__c);
        }
        
        return null;
    }

}