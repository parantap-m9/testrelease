public class IncidentOverviewController {

    public List<IncWrapper> listOpenIncidents = new List<IncWrapper>();
    public List<Task__c> selectedInc = new List<Task__c>();
    
    public String selectedQueue {get; set;}
    public Set<String> setQueueNames = new Set<String>();

    public String pieChart { get; set; }    
    
    public Boolean renderROPanel {get; set;}
    public Boolean renderRWPanel { get; set; }
    public Boolean displayEscToL2 {get; set;}
    
    public Task__c editInc { get; set; }
    public Task__c delInc { get; set; }
    
    public String saveIncNum {get; set;}
    
    public List<Integer> listSerialNum {get; set;}

    public incidentOverviewController(){
    
        selectedQueue = ApexPages.currentPage().getParameters().get('queue');
        
        if( null != selectedQueue){
            system.debug('Rahul inside cons selectedQueue = ' + selectedQueue);
            if(selectedQueue == 'L1'){
                displayEscToL2 = true;
                renderROPanel = true; 
                Name_Value_Pair__c nvp = Name_Value_Pair__c.getValues('L1');
                setQueueNames.addAll(nvp.QueueName__c.split(';'));
            }
            else if(selectedQueue == 'L2'){
                displayEscToL2 = false;
                renderROPanel = true;  
                Name_Value_Pair__c nvp = Name_Value_Pair__c.getValues('L2');
                setQueueNames.addAll(nvp.QueueName__c.split(';'));
            }
        }

        else
            renderROPanel = false;
    }
    
    public List<IncWrapper> getListOpenIncidents(){
            system.debug('Rahul: inside getListopenIncidents: ');
            
            List<Task__c> listOpenInc = [Select Task_Number__c, SFDC_Case__c, Logged_Date__c, Priority__c, Application_Area__c, Description__c, Customer__c,Status__c, Assignee__c from Task__c where Queue__c = :setQueueNames];
            
            for(Task__c t : listOpenInc){
                listOpenIncidents.add(new IncWrapper(t));
            }
            system.debug('Rahul: value of openIncidents: '+listOpenIncidents);
        return listOpenIncidents;       
    }
    
    public pageReference getSelected(){
        selectedInc.clear();
        system.debug('Rahul: listOpenIncidents: '+listOpenIncidents);
        for(IncWrapper iw : listOpenIncidents){
            if(iw.selected == true){
                selectedInc.add(iw.task);
            }
        }
        system.debug('Rahul: selectedInc = '+selectedInc);
        return null;
    }
    
    public String getParam(String name) {
        return ApexPages.currentPage().getParameters().get(name);   
    }
/*    
    public pageReference queueSelection(){
        
        PageReference pageRef = Page.incidentOverviewPage;
        system.debug('Rahul selectedQueue inside queueSelection = '+selectedQueue);
        if(selectedQueue == 'L1'){
                displayEscToL2 = true;
                renderROPanel = true;               
                openIncidents = [Select Task_Number__c, SFDC_Case__c, Logged_Date__c, Priority__c, Application_Area__c, Description__c, Customer__c,Status__c, Assignee__c from Task__c where Queue__c = 'SFDC L1'];
                system.debug('Rahul: value of openIncidents L1: '+openIncidents);

            }
        else if(selectedQueue == 'L2'){
            displayEscToL2 = false;
            renderROPanel = true;            
            openIncidents = [Select Task_Number__c, SFDC_Case__c, Logged_Date__c, Priority__c, Application_Area__c, Description__c, Customer__c,Status__c, Assignee__c from Task__c where Queue__c = 'SFDC L2'];
            system.debug('Rahul: value of openIncidents L2: '+openIncidents);
        }
        
        pageRef.getParameters().put('queue', selectedQueue);
        pageRef.setRedirect(true);
        return pageRef;
    }
  */  
    public pageReference escalateToL2(){
        
        PageReference pageRef = Page.incidentOverviewPage;
        String escalateToL2 = getParam('escalateIncNum');
        system.debug('Rahul: escalateToL2 = ' + escalateToL2);
        
        Task__c t = new Task__c();
        t = [select Id, Task_Number__c, Queue__c from Task__c where Task_Number__c = :escalateToL2];
        if(t.Queue__c == 'SFDC L1'){
            t.Queue__c = 'SFDC L2';
            t.Date_Forwarded_to_L2__c = system.today();
            system.debug('Rahul: escalateToL2 t = ' + t);
        }
        
        if(null!=t){
            try{
                update t;
            }
            catch(exception e){
                ApexPages.Message escErrMsg = new ApexPages.Message(ApexPages.Severity.Error, 'An error was encountered in escalating the case to L2: ' + e);
                ApexPages.addMessage(escErrMsg);
            }
        }
        pageRef.getParameters().put('queue',selectedQueue);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public pageReference delBtnClick(){
        system.debug('Rahul inside delBtnClick method');
        
        PageReference pageRef;
        renderROPanel = true;
        renderRWPanel = false;
            
        String delIncNum = getParam('delIncNum');
        delInc = [select Task_Number__c from Task__c where Task_Number__c =:delIncNum];
        system.debug('Rahul: delIncNum = '+delIncNum);
        system.debug('Rahul: delInc = '+delInc);
        
        if(test.isRunningTest()){
            delete delInc;
        }
        
        try{
            if(null!=delInc){
                delete delInc;
                pageRef = Page.incidentOverviewPage;
                pageRef.getParameters().put('queue', selectedQueue);
                pageRef.setRedirect(true);
            }
        }   
        catch(dmlexception e){
            String errMsg1 = 'Your attempt to delete ';
            String errMsg2 = String.ValueOf(delInc.Task_Number__c);
            String errMsg3 = ' could not be completed because it is associated with the following timesheets';
            List<String> l = e.getMessage().split(':');
            String errMsg4 = l.get(2);
            String errMsg = errMsg1 + errMsg2 + errMsg3 + errMsg4;
            ApexPages.Message errorMsgTSAssociated = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg);
            ApexPages.addMessage(errorMsgTSAssociated);
            
            pageRef = null;
        }
        
        return pageRef;
    }
    
    public pageReference editBtnClick(){
        system.debug('Rahul inside editBtnClick method');
        //renderROPanel = 'false';
        renderRWPanel = true;
        String editIncNum = getParam('editIncNum');
        system.debug('Rahul: editIncName from editBtnClick = '+editIncNum);
        editInc = [Select Task_Number__c, SFDC_Case__c, Logged_Date__c, Priority__c, Application_Area__c, Description__c, Customer__c,Status__c, Assignee__c from Task__c where Task_Number__c = :editIncNum];
        system.debug('Rahul: from editBtnClick editInc = '+editInc);
        return null;
    }
    
    public pageReference cancelBtnClick(){
        system.debug('Rahul inside cancelBtnClick method');
        renderROPanel = true;
        renderRWPanel = false;
 
        editInc = null;
                
        return null;
    }
    
    public pageReference saveBtnClick(){
        system.debug('Rahul inside saveBtnClick method, selectedInc = '+selectedInc);
        
        if(selectedInc.size()>0){
            try{
                system.debug('Rahul: saving selectedInc: '+selectedInc);
                update selectedInc;
            }
            catch(exception e){
                system.debug('Rahul: exception caught while saving selectedInc: '+e.getMessage());
            }
        }
        
        if(null != editInc){
            try{
                system.debug('Rahul inside try for saveBtnClick');
                system.debug('Rahul from editBtnClick editInc = '+editInc);
                update editInc;
                editInc = null;
            }
            catch (exception e){
                system.debug('Rahul: caught exception while saving editInc: '+e.getMessage());
            }
        }
        
        pageReference incOvrViewPg = Page.IncidentOverviewPage; 
        incOvrViewPg.getParameters().put('queue',selectedQueue);
        system.debug('Rahul incOvrViewPg = '+incOvrViewPg);
        incOvrViewPg.setRedirect(true);
        return incOvrViewPg;        
    }
    
    public class IncWrapper{
        public Task__c task {get; set;}
        public Boolean selected {get; set;}     
        
        public IncWrapper(Task__c tsk){
            task = tsk;
            selected = false;
        }
    }
}