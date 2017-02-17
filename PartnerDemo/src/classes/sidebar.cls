public class sidebar
{

    public PageReference sidebar() {
        return null;
    }

    private final product2 family;
    //public List<Site_Placements__c> splace {get; set;}
   
        public sidebar()
           
            {
              
                family=[SELECT Brand__c,Category__c,Family FROM Product2 WHERE Family = 'home theaters' AND Id = '01t360000019KHO'];
                system.debug('tttttt'+family);
                
               
            }
           
            public product2 getfamily() {
        return family;
    }
    public PageReference Fetch() {
        //update splace;
        return null;
    }
           
}