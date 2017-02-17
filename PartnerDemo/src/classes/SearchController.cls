public class SearchController{
      public String productName { get; set; }    
      public static List<Product2> prodList{get;set;}
      public SearchController() { } // empty constructor
  
public static List<Product2> getProducts1() {
        prodList= [SELECT Description,Name,ProductCode FROM Product2  WHERE Name like '%productName%'];
        return prodList;
    }
    public pageReference getProducts()
    {    
      getProducts1();
      return null;
    }

}