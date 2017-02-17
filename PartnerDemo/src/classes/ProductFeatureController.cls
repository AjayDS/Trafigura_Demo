public with sharing class ProductFeatureController
{
public String stockVal{get;set;}
public String selectedValue { get; set; }    
    public Transient blob picture { get; set; }
    public String errorMessage { get; set; }
    public Product2 product { get; set; }
    public static List<Product2> products = new List<Product2>(); 
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public boolean  isLive {get;set;}     
            
  public static List<SelectOption> ProductsList
    {
        get
        {
             products = [SELECT Id,Name FROM Product2];
             ProductsList = new List<SelectOption>();
             ProductsList.add(new SelectOption('--None--','--None--'));
            for(Product2 temp : products )
               {
                    ProductsList.add(new SelectOption(temp.Id, temp.Name));
                }
            return ProductsList;
        }
        set;
    }
    
   public PageReference getProdDetails(){
       isLive=true;
     system.debug('inside getprodetails');
     try{
     product=new Product2();
     product = [SELECT Brand__c,Category__c,CreatedById,Stock__c,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,
                     ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :selectedValue];
    stockVal=String.valueOf(product.Stock__c);
     }catch(Exception e){
         product = new Product2();
     }
      return null;
   }
   public PageReference save() {
    errorMessage = '';
    system.debug('@@@@@@@@@@@');
    mapLabels = Hard_Coded_Labels__c.getAll();
     
    Attachment attachment = new Attachment();    
    try {
         Product2 product1 = [SELECT Brand__c,Category__c,Stock__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,
                     ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :selectedValue];
       // upsert product;
        if (picture != null) {                    
            attachment.body = picture;
            system.debug('with attachment');
            //system.debug('file size:  '+attachment.body.size());
            if(attachment.body.size()>135000)
                {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,mapLabels.get('FileUpload_MaxLimit').Value__c));   
                     return null;       
                }
                else{
                        attachment.name = 'product_' + selectedValue+'.jpg';            
                        attachment.parentid = selectedValue;
                        //attachment.Title='DisplayImage';
                        attachment.ContentType = 'application/jpg';            
                        insert attachment;  
                        product1.Image_URL__c = '/servlet/servlet.FileDownload?file='+ attachment.id;                                    
                    }
            }   
                    system.debug('only other details');       
                    product1.Brand__c=product.Brand__c;
                    product1.Category__c=product.Category__c;
                    product1.Family=product.Family;
                    product1.IsActive=product.IsActive;
                    product1.Price__C=product.Price__C;
                    product1.Stock__c=product.Stock__c; 
                    product1.Id = product.Id;
                    
                    system.debug('product.Brand__c:'+product.Brand__c);
                    system.debug('product.Category__c:'+product.Category__c);
                    system.debug('product.Family:'+product.Family);
                    system.debug('product.IsActive:'+product.IsActive);
                    system.debug('product.Price__C:'+product.Price__C);
                    system.debug('product.Stock__c:'+product.Stock__c);          
                    update product1 ; 
                    product = [SELECT Brand__c,Category__c,Stock__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,
                     ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :selectedValue];
                     system.debug('product.Brand__c after:'+product.Brand__c);
                    system.debug('product.Category__c:'+product.Category__c);
                    system.debug('product.Family:'+product.Family);
                    system.debug('product.IsActive:'+product.IsActive);
                    system.debug('product.Price__C:'+product.Price__C);
                    system.debug('product.Stock__c:'+product.Stock__c);   
              
    }
    catch (DMLException e) {
        //system.debug('Error uploading attachment');
        errorMessage = e.getMessage();
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,mapLabels.get('FileUpload_Error').Value__c));
      return null;
    } 
      catch(System.Exception ex) {      
        errorMessage = ex.getMessage();
        //system.debug('Error uploading attachment:'+errorMessage );
        return null;

    }
    finally {
      attachment = new Attachment(); 
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,mapLabels.get('Fileupload_Success').Value__c));
     //system.debug('Attachment uploaded successfully');
    return null;
    }
}