public class portal_Invoice{

 String orderNumber='00000105';
 public Decimal tax {get;set;}
 public Invoice__c invoice{get;set;}
 public Decimal totalOrderAmount{get;set;}
 public Decimal grandTotal{get;set;}
 public String billingAddress{get;set;}
 public String shippingAddress{get;set;}
 public List<OrderItem> orderItem{get;set;}
 public String invoiceNumber{get;set;}
 public String invoiceDate{get;set;}
 
  public Pagereference getGeneratedInvoice(){
  
  Invoice__c  invoice = new Invoice__c() ;  
  try{
          
          Order order =[SELECT BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,OrderNumber,Order_Amount__c,ShippingAddress,TotalAmount,Transaction_Id__c,Type FROM Order WHERE OrderNumber=:orderNumber];        
          system.debug('order from backend:'+order);
          String orderId=order.Id;
          invoice.Order__c=order.Id;
          // need to refactor this code, its a workaround
          Integer invoiceCount=[SELECT count() FROM Invoice__c WHERE Order__c =:order.Id];          
          system.debug('invoiceCount:'+invoiceCount);
          if(invoiceCount==1){
              List<Invoice__c> invId=[SELECT Id FROM Invoice__c WHERE Order__c =:order.Id LIMIT 1];
              invoice.Id=invId[0].Id;
              update invoice;
           }
           else if(invoiceCount==0){
              insert invoice;
           }              
          system.debug('order.BillingAddress:'+order.BillingAddress);
          system.debug('order.ShippingAddress:'+order.ShippingAddress);
          Address orderBillingAddress=order.BillingAddress;
          Address orderShippingAddress=order.ShippingAddress;
          billingAddress=orderBillingAddress.getStreet()+orderBillingAddress.getCity()+orderBillingAddress.getState()+orderBillingAddress.getCountry()+orderBillingAddress.getPostalCode();
          shippingAddress=orderShippingAddress.getStreet()+orderShippingAddress.getCity()+orderShippingAddress.getState()+orderShippingAddress.getCountry()+orderShippingAddress.getPostalCode();          
          system.debug('billingAddress:'+billingAddress);
          system.debug('shippingAddress:'+shippingAddress);
          totalOrderAmount=order.TotalAmount;
          tax=0.02;
          system.debug('invoice:'+invoice);
          system.debug('totalOrderAmount:'+totalOrderAmount);
          grandTotal=order.TotalAmount+(tax*order.TotalAmount);
          orderItem=[SELECT Description,Quantity,Total_Price__c,UnitPrice FROM OrderItem WHERE OrderId = :orderId];
          Invoice__c createdInvoice=[SELECT CreatedDate,Name FROM Invoice__c WHERE Order__c =:order.Id LIMIT 1];
          invoiceNumber=createdInvoice.Name;
          DateTime inv_CreatedDate=createdInvoice.CreatedDate;
          String dateOutput = inv_CreatedDate.format('dd/MM/yyyy');
          invoiceDate=dateOutput;
          system.debug('orderItem:'+orderItem); 
          
          //code to add the generated pdf as an order attachment
          PageReference pdfPage = Page.InvoiceGenerator;   
           Blob pdfBlob = pdfPage.getContent();
          system.debug('pdfPage :'+pdfPage+ 'pdfBlob :'+pdfBlob ); 
           if(pdfBlob!=null){ 
               Attachment attachment = new Attachment(); 
                attachment.name = 'invoice_' + 'INV-0028'+ '.pdf';            
                attachment.parentid = orderId;
                attachment.ContentType = 'application/jpg'; 
                attachment.body=pdfBlob ;
                insert attachment;                  
            }  
           return null;   
      }
       catch (DMLException e) {
            system.debug('DML Error '+e.getMessage());
            //errorMessage = e.getMessage();
          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,mapLabels.get('FileUpload_Error').Value__c));
          return null;
        } 
      catch(System.Exception ex) {      
        //errorMessage = ex.getMessage();
        system.debug('Generic Error:'+ex.getMessage() );
        return null;
        }      
    }  

}