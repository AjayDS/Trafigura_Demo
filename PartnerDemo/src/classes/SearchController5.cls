public class SearchController5{
      public String productName { get; set; }    
      //public static List<Product2> prodList{get;set;}
      //public SearchController4() { } // empty constructor
  
/*public static List<Product2> getProducts1() {
        prodList= [SELECT Brand__c,Category__c,Family,Id,Image_URL__c,Image__c FROM Product2 WHERE Family = 'Headphones'];
        return prodList;
    }*/
     public List<Product2> products = new List<Product2>();   
  
  public List<SelectOption> ProductsList
    {
        get
        {
             products = [SELECT Id,Name,family FROM Product2];
             ProductsList = new List<SelectOption>();
            for(Product2 temp : products )
               {
                    ProductsList.add(new SelectOption(temp.Id, temp.Name));
                }
                system.debug('++showing'+ProductsList);
            return ProductsList;
        }
        set;
    }
    public pageReference getProducts()
    {    
      //getProducts1();
      return null;
    }


}