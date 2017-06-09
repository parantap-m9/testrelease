public class ExpTrackerLoginCon {

    public ExpTrackerLoginCon() {

    }
    
    public string uname {get; set;}
    public string pwd {get; set;}

 
    public PageReference loginValidation(){
        system.debug(uname + ' : ' + pwd);
        ExpTrackingCreds__c credValidate = ExpTrackingCreds__c.getValues(uname);
        system.debug(credValidate);
        PageReference pageRef = null;

        if(credValidate == null){
            system.debug('Rahul inside 1st if'); 
            ApexPages.Message incorrectUname = new ApexPages.Message(ApexPages.Severity.ERROR,'Wrond Username');
            ApexPages.addMessage(incorrectUname);
            return null;
        }
        if(pwd == credValidate.Password__c){
            PageRef = Page.HomePage;
            PageRef.getParameters().put('uid',credValidate.Name);
            return pageRef;
        }
        else{
            ApexPages.Message incorrectPwd = new ApexPages.Message(ApexPages.Severity.ERROR,'Wrong Password');
            ApexPages.addMessage(incorrectPwd);
            return null;
        }    
    }
}