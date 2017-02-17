public with sharing class prosearchcontroller1 { 
    public String searchText { get; set; }

    public prosearchcontroller1(portal_menuCls controller) {

    }


    public prosearchcontroller1() {

    }

 
   public list <product2> pro {get;set;}  
   public string search {get;set;}  
   public prosearchcontroller1(ApexPages.StandardController controller) {  
   }  
   public void search(){  
   system.debug('###'+search);
     string search='select name,id from product2 where name like \'%'+search+'%\' Limit 20';
     system.debug('*****'+search);  
     pro= Database.query(search);  
   }  
   public void clear(){  
   pro.clear();  
   }  
 }