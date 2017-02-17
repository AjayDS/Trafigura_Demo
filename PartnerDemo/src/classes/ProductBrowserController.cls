public with sharing class ProductBrowserController {
public static final Integer PAGE_SIZE = 10;  
public static Apexpages.Standardsetcontroller setCon {  
      get {  
           if(setCon == null){  
                String query = 'SELECT Brand__c,Category__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,ProductCode,RecordTypeId,Stock__c,SystemModstamp FROM Product2 ORDER BY Name ASC';  
                setCon = new Apexpages.Standardsetcontroller(Database.getQueryLocator(query));  
           }  
           return setCon;  
      }  
      set;  
 } 
 
 
  public static AccountWrapper buildScrollData(Integer currentPageNumber, Boolean getMore){  
       if(setCon != null){  
            setCon.setPageSize(PAGE_SIZE);  
            setCon.setPageNumber(currentPageNumber);  
          if(getMore){  
                if(setCon.getHasNext()){  
                    setCon.next();  
                     List<Product2> accts = (List<Product2>)setCon.getRecords();  
                      if(accts != null && !accts.isEmpty()){  
                         AccountWrapper aw = new AccountWrapper(setCon.getPageNumber(), setCon.getHasNext(), true, accts);  
                          return aw;  
                     } else {  
                          AccountWrapper aw = new AccountWrapper(setCon.getPageNumber(), setCon.getHasNext(), false, null);  
                         return aw;  
                      }  
                } else {  
                      AccountWrapper aw = new AccountWrapper(setCon.getPageNumber(), setCon.getHasNext(), false, null);  
                      return aw;  
                 }  
           } else {  
                 //Initial Call. Load the first number or records according to pageSize  
                AccountWrapper aw = new AccountWrapper(setCon.getPageNumber(), setCon.getHasNext(), true, (List<Product2>)setCon.getRecords());  
                return aw;  
           }  
       }  
       return null;  
  }   
  
   public class AccountWrapper{  
       public Integer pageNumber { get; set; }  
       public Boolean hasMore { get; set; }  
       public Boolean noRecords { get; set; }  
       public List<Product2> records { get; set; }  
       public AccountWrapper(Integer currentPageNumber, Boolean more, Boolean noRecs, List<Product2> recordsForSinglePage){  
            pageNumber = currentPageNumber;  
            hasMore = more;  
            noRecords = noRecs;  
            records = recordsForSinglePage;  
       }  
  } 
   public static String accountList {  
       get {  
            AccountWrapper aw = buildScrollData(1, false);  
           accountList = JSON.serialize(aw);  
            return accountList;  
       }  
     private set;  
  } 
 @RemoteAction  
  public static ProductBrowserController.AccountWrapper getMore(String currentPageNumber, String hasMore){  
       Integer pageNumber = Integer.valueOf(currentPageNumber);  
      Boolean more = Boolean.valueOf(hasMore);  
       if(more){  
            ProductBrowserController.AccountWrapper aw = ProductBrowserController.buildScrollData(pageNumber, more);  
            return aw;  
       }  
       return null;  
  }
 }