public with sharing class PageController {
public string language {get;set;}
public boolean isFrench {get;set;}

public void changeFrench(){
    language = 'fr';
     isFrench = true;
}

public void changeEnglish(){
    language = 'en_US';
        isFrench = false;

}

}