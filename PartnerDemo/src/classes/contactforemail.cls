public with sharing class contactforemail {
    
  //public Boolean For_Subscription__c {get;set;} 
  public Contact contact {
    get {
      if (contact == null)
        contact = new Contact();
        System.debug('*****'+contact);
      return contact;
      
    }
    set;
  }

  public contactforemail() {
      System.debug('*****2'+contact);
       }
  
  public PageReference submit() {

    try {
         insert contact;
        } 
        catch (DMLException e) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new contact.'));
        return null;
            }
       return Page.thanku4_subscribe;
      }

    }