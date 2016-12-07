public class customListController{
  
  public Apexpages.StandardSetController customController {
  
      get{
              if(customController==null){
                  customController=new ApexPages.StandardSetController(database.getQueryLocator([select id,name from Opportunity]));                 
              }
              return customController;
      }set;
  
  }
  
  public List<Opportunity>  getOpties(){
      return customController.getRecords();
  }
}