@isTest
private class IncidentOverviewController_Test {
    
    //Variables
    private static boolean renderROPanel {get; set;}
    private static boolean renderRWPanel {get; set;}
    private static Task__c editInc {get; set;}
    private static Task__c delInc {get; set;}
    
    //create test Inc records
    private static Task__c createTasks(){
        Datetime myDate = datetime.newInstance(2014, 10, 5, 00, 00, 0);
        Task__c t = new Task__c(Task_Number__c = 'INC123987', Priority__c = 'P1', Logged_Date__c = system.today(), Customer__c = 'abc', Application_Area__c = 'SFDC', Assignee__c = 'Rahul Sharma', Description__c = 'Test Inc', Status__c = 'Assigned', Type__c = 'Incident');
        
        insert t;
        return t;
    }
    
    private static testMethod void testDelBtnClick(){
        
        IncidentOverviewController ioc = new IncidentOverviewController();
        pageReference pgRef = Page.IncidentOverviewPage;
        
        Task__c t1 = createTasks();        
        pgRef.getParameters().put('delIncNum',t1.Task_Number__c);
                
        Test.setCurrentPage(pgRef);
        
        test.StartTest();
        ioc.delBtnClick();
        test.StopTest();
        
        Task__c t2 = createTasks();        
        pgRef.getParameters().put('delIncNum',t2.Task_Number__c);
        ioc.delBtnClick();

    }

    private static testMethod void testEditBtnClick(){
        IncidentOverviewController ioc = new IncidentOverviewController();
        pageReference pgRef = Page.IncidentOverviewPage;
        
        Task__c t1 = createTasks();        
        pgRef.getParameters().put('editIncNum',t1.Task_Number__c);
        
        Test.setCurrentPage(pgRef);
        
        test.StartTest();
        ioc.editBtnClick();
        test.StopTest();
    }
    
    private static testMethod void testCancelBtnClick(){
        IncidentOverviewController ioc = new IncidentOverviewController();
        pageReference pgRef = Page.IncidentOverviewPage;
        
        Task__c t1 = createTasks();        
        
        Test.setCurrentPage(pgRef);
        
        test.StartTest();
        ioc.cancelBtnClick();
        test.StopTest();
    }
    
    private static testMethod void testSaveBtnClick(){
        IncidentOverviewController ioc = new IncidentOverviewController();
        PageReference pgRef = Page.IncidentOverviewPage;
        
        Task__c t1 = createTasks();
        pgRef.getParameters().put('editIncNum', t1.Task_Number__c);
        
        Test.setCurrentPage(pgRef);

        test.StartTest();
        ioc.saveBtnClick();
        test.StopTest();
        
    }
    
}