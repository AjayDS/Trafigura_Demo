public with sharing class pdfExtn {

    public pdfExtn(portal_Invoice controller) {

    }
    public PageReference attachQuote(){
        PageReference pdfPage = Page.InvoiceGenerator;   
        Blob pdfBlob = pdfPage.getContent();
        Attachment attachment = new Attachment(); 
        if(pdfBlob!=null){  
            attachment.name = 'invoice_' + 'INV-0028'+ '.pdf';            
            attachment.parentid = 'a0M36000002T2kmEAC';
            attachment.ContentType = 'application/jpg'; 
           
            }
            return null;
        }
}