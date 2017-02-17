public with sharing class FileUploadController1 {

    public String selectedValue { get; set; }
    
    public blob picture { get; set; }

    public String errorMessage { get; set; }
    public string searchstring {get;set;}  
    private Product2 product;
    private final String productId='01t36000002Fkta';

public List<Product2> products3 {get; set;} 
 public List<Product2> products = new List<Product2>();   
 public List<Product2> products1 {get; set;} 
 
  public List<SelectOption> ProductsList
    {
        get
        {
             products = [SELECT Id,Name FROM Product2];
             ProductsList = new List<SelectOption>();
            for(Product2 temp : products )
               {
                    ProductsList.add(new SelectOption(temp.Id, temp.Name));
                }
            return ProductsList;
        }
        set;
    }
 public PageReference search() 
    {
       
      System.debug('searchstring:'+searchstring);
      //products1 =[SELECT Description, Family, Id, Image_URL__c, Image__c FROM Product2 WHERE Family LIKE' + '\'%' + searchstring + '%\' LIMIT 2 ]; 
     products1 = Database.query('SELECT  Description, Family, Id, Image_URL__c, Image__c FROM Product2 WHERE Family LIKE' + '\'%' + searchstring + '%\'');
      System.debug('products1 :'+products1 ); 
     //Product3= Database.query(products1);  
     return null;
       
    }
     
  
  
   public PageReference save() {
    errorMessage = '';
    try {
    System.debug('selectedValue :'+selectedValue );
    // product = [SELECT Brand__c,Category__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = '01t360000017xd4' ];
       // upsert product;
      product = [SELECT Brand__c,Category__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        if (picture != null) { 
            Attachment attachment = new Attachment();
            attachment.body = picture;
            attachment.name = 'product_' + productId + '.jpg';
            attachment.parentid = productId;
           attachment.ContentType = 'application/jpg';
            insert attachment;
            product.Image_URL__c = 'https://c.na30.content.force.com/servlet/servlet.FileDownload?file='+ attachment.id;
            product.Price__c =13000.00;
            update product;
        }
        return null;
    } catch(System.Exception ex) {
        errorMessage = ex.getMessage();
        return null;

    }
}
}