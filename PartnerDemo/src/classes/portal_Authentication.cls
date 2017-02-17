public class portal_Authentication{

    public static String userN{get;set;}
    public static String pass{get;set;}
    public static String emailId{get;set;}
    public static String firstName{get;set;}
    public static String lastName{get;set;}
    public static String resetUserName{get;set;}
    public Map<string,Hard_Coded_Labels__c> mapLabels{get;set;}
    public static String staticMsg{get;set;}
    
    public portal_Authentication(){
        mapLabels = new Map<string,Hard_Coded_Labels__c>();
        mapLabels = Hard_Coded_Labels__c.getAll();    
    }
    public PageReference login() {        
        String userName=userN;
        String password=pass;      
        System.debug('@@@@'+password);
        if(password=='' || password==null){         
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,mapLabels.get('Password_Validation').Value__c));
             return null;
        }
        
        String startUrl = Label.Start_URL; 
        
        PageReference pRef = Site.login(userName, password, startUrl);
        System.debug('AAAAA'+pRef);
        
        if(pRef==null){           
            return null;
        }else{
            pRef.setRedirect(true);
            System.debug('!!!!!!!'+pRef);           
            return pRef;         
        }
    }
    
     public PageReference registerUser(){               
        
        Savepoint sp = Database.setSavepoint();
              
        //create Contact record for portal user
        Contact newUser = new Contact();
        newUser.firstName=firstName;
        newUser.lastName=lastName;
        newUser.Email=emailId;      
        newUser.AccountId=[select id from Account where name=:mapLabels.get('Guest_Account').Value__c limit 1].Id;
        /*newUser.MailingStreet = mailingStreet;
        newUser.MailingCity = mailingCity;
        newUser.MailingState = mailingState;
        newUser.MailingPostalCode = mailingZipcode;
        newUser.MailingCountry = mailingCountry;*/
        
         System.debug('Register called....');
        try{    
            Contact userObj = new Contact();
            try{
                userObj=[select id,Email,LastName from Contact where Email=:emailId limit 1 ];
                if(!String.isBlank(userObj.Email)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.Duplicate_Email_Error));
                    Database.rollback(sp);          
                    return null;
                }
            }Catch(Exception e){
                
                 System.debug('###'+e.getMessage());
            }
            
            System.debug('####'+firstName+'\n'+lastName+'\n'+emailId+'\n'+userObj.Email); 
           
            if(userObj.Id==null || userObj.Email==null){
               insert newUser;
            }
            
            
        }catch(Exception e){}   
        
        //Create a portal user with Contact
        User userObj= new User();               
        userObj.LastName=lastName;
        userObj.Alias=lastName.substring(0, 3);
        userObj.Email=emailId;
        userObj.CommunityNickname=lastName;        
        userObj.ProfileId=[select id,Name from Profile where Name=:mapLabels.get('Guest_User_Profile').Value__c limit 1].Id;            
        userObj.isActive=true; 
        //String userName=firstName+lastName;
        //userName=userName.replaceAll('\\s','');
        //system.debug('userName---'+firstName+lastName+'@demo.com');
        userObj.userName=emailId+mapLabels.get('Username_Extension').Value__c;
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        //userObj.isPortalEnabled = true;
        userObj.contactId=newUser.id;
        
        try{    
                if(newUser.Id!=null || newUser.id!=''){
                    insert userObj;
                    staticMsg='Successfully Registered. Please confirm the email Address.';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,staticMsg));
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.No_Contact_Error));
                }
        }catch(Exception e){}
        try{
            system.resetPassword(userObj.Id,true);      
            //Site.forgotPassword(userObj.userName);
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
                
        return null;        
        
    }   
    
    public PageReference resetPassword() {           
        Boolean isExec=false;
        try{
            User userObj = [select id from User where username=:resetUserName and isActive=true];   
            if(userObj==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,mapLabels.get('Username_Validation_Error').Value__c));
                return null;            
            }else{
                isExec = Site.forgotPassword(resetUserName);   
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,mapLabels.get('Username_Validation').Value__c));
                System.debug('AAAAAA'+isExec+resetUserName);
                return null;
                
            }
        }Catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,mapLabels.get('Username_Validation_Error').Value__c));
            return null;            
        }       
    }  
    
}