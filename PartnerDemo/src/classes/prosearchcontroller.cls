public with sharing class prosearchcontroller { 
    public prosearchcontroller(portal_menuCls controller) {
    system.debug('555');
    }


    public prosearchcontroller() {

    }

 
   public list <product2> pro {get;set;}  
   public string search {get;set;}  
   public prosearchcontroller(ApexPages.StandardController controller) {  
   }  
   public void search(){  
   system.debug('###'+search);
     string searchtext=apexpages.currentpage().getparameters().get('searchString');
     string search='select name,id from product2 where name like \'%'+searchtext+'%\' Limit 20';
     system.debug('*****'+search);  
     pro= Database.query(search);  
   }  
   public void clear(){  
   pro.clear();  
   }  
 }