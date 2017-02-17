public with sharing class FileUploadController {

    public String selectedValue { get; set; }    
    public Transient blob picture { get; set; }
    public String errorMessage { get; set; }
    public Product2 product { get; set; }
    public static List<Product2> products = new List<Product2>(); 
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public boolean  isLive {get;set;} 
    //public Transient String picture {get;set;}
    public String filename{get;set;}
        
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
     product = [SELECT Brand__c,Category__c,CreatedById,Stock__c,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,
                     ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :selectedValue];
    
     }catch(Exception e){
         product = new Product2();
     }
      return null;
   }
   public PageReference save() {
    errorMessage = '';
    mapLabels = Hard_Coded_Labels__c.getAll();
     
    Attachment attachment = new Attachment();    
    try {
         Product2 product1 = [SELECT Brand__c,Category__c,Stock__c,CreatedById,CreatedDate,Description,Family,Id,Image_URL__c,Image__c,IsActive,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Price__c,
                     ProductCode,RecordTypeId,SystemModstamp FROM Product2 WHERE Id = :selectedValue];
       // upsert product;
        if (picture != null) {                    
            attachment.body = picture;//Blob.valueOf(picture);//
            system.debug('file size:  '+attachment.body.size());
            if(attachment.body.size()>135000)
                {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,mapLabels.get('FileUpload_MaxLimit').Value__c));   
                     return null;       
                }
                else{
                    attachment.name = 'product_' + fileName;            
                    attachment.parentid = selectedValue;
                    //attachment.Title='DisplayImage';
                    attachment.ContentType = 'application/jpg';            
                    insert attachment;
                    product1.Image_URL__c = '/servlet/servlet.FileDownload?file='+ attachment.id; 
                    product1.Brand__c=product.Brand__c;
                    product1.Category__c=product.Category__c;
                    product1.Family=product.Family;
                    product1.IsActive=product.IsActive;
                    product1.Price__C=product.Price__C;
                    product1.Stock__c=product.Stock__c;           
                    update product1 ;                    
            }
        }       
    }
    catch (DMLException e) {
        system.debug('Error uploading attachment');
        errorMessage = e.getMessage();
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,mapLabels.get('FileUpload_Error').Value__c));
      return null;
    } 
      catch(System.Exception ex) {      
        errorMessage = ex.getMessage();
        system.debug('Error uploading attachment:'+errorMessage );
        return null;

    }
    finally {
      attachment = new Attachment(); 
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,mapLabels.get('Fileupload_Success').Value__c));
     system.debug('Attachment uploaded successfully');
    return null;
    }

}