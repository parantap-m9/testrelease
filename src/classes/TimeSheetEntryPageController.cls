public class TimeSheetEntryPageController {

        public boolean renderNoTabSelOpPanel {get; set;}
        public boolean renderIncTabSelOpPanel {get; set;}
        public boolean renderMiscTabSelOpPanel {get; set;}
        public boolean renderMainPgBlk {get; set;}
        public boolean renderIncOpPanel {get; set;}
        public boolean renderMiscOpPanel {get; set;}
        public boolean renderViewEffortsROPanel {get; set;}
        public boolean renderViewEffortsRWPanel {get; set;}
        
        public String tabToDisplay {get; set;}
        
        public Task__c assignedTasksIndividual {get; set;}
        public List<Task__c> listTasksofAssignee {get;set;}

        public String tskNum {get;set;}
        public String tskNumEff {get;set;}
        public String tskType {get;set;}
        public Decimal tskEff {get; set;}
        public String tskAssignee {get; set;}
        public List<Timesheet__c> tteList{get;set;}
        public List<Secondary_Task__c> listSecondaryTasks {get; set;}
        public Id tsToEditId {get; set;}
        public Timesheet__c tsToEdit {get; set;}
        public Id tsToDeleteId {get; set;}
        public Timesheet__c tsToDelete {get; set;}
        
        public TimeSheetEntryPageController() {
            //Later, modify the query to filter results based on the person logged in
            listTasksofAssignee = new List<Task__c>();
            /*
            listTasksofAssignee = [Select Id, RecordType.Name, Task_Number__c, Total_Efforts__c, Action__c, Application_Area__c, Assignee__c, Change_Request__c, Customer__c, Date_Forwarded_to_L2__c, Days_in_L1_Queue__c, Days_in_L2_Queue__c, Description__c, JIRA_Ticket__c, Logged_Date__c, Priority__c, Scrum_Team__c, SFDC_Case__c, Status__c, Type__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Closed__c = false  Order By Logged_Date__c];
            */
            assignedTasksIndividual = new Task__c();
            
            renderNoTabSelOpPanel = true;
            renderIncTabSelOpPanel = false;
            renderMiscTabSelOpPanel = false;
            renderMainPgBlk = false;
            renderIncOpPanel = false;
            renderMiscOpPanel = false;
            
            listSecondaryTasks = new List<Secondary_Task__c>();
            listSecondaryTasks = [select Name from Secondary_Task__c];

        }    
        
        
        public void tabSelection() {
                
            if(tabToDisplay=='Inc') {
                renderNoTabSelOpPanel = false;
                renderIncTabSelOpPanel = true;
                renderMiscTabSelOpPanel = false;
                renderMainPgBlk = true;
                renderIncOpPanel = true;
                renderMiscOpPanel = false;
                listTasksofAssignee = [Select Id, RecordType.Name, Task_Number__c, Total_Efforts__c, Action__c, Application_Area__c, Assignee__c, Change_Request__c, Customer__c, Date_Forwarded_to_L2__c, Days_in_L1_Queue__c, Days_in_L2_Queue__c, Description__c, JIRA_Ticket__c, Logged_Date__c, Priority__c, Scrum_Team__c, SFDC_Case__c, Status__c, Type__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Closed__c = false AND (RecordType.Name = 'Enhancement Request' OR RecordType.Name = 'Support Incident') Order By Logged_Date__c];
                
                renderViewEffortsROPanel = false;
                renderViewEffortsRWPanel = false;
            } 
            else if(tabToDisplay=='Misc') {
                renderNoTabSelOpPanel = false;
                renderIncTabSelOpPanel = false;
                renderMiscTabSelOpPanel = true;
                renderMainPgBlk = true;
                renderIncOpPanel = false;
                renderMiscOpPanel = true;
                listTasksofAssignee = [Select Id, RecordType.Name, Task_Number__c, Total_Efforts__c, Action__c, Application_Area__c, Assignee__c, Change_Request__c, Customer__c, Date_Forwarded_to_L2__c, Days_in_L1_Queue__c, Days_in_L2_Queue__c, Description__c, JIRA_Ticket__c, Logged_Date__c, Priority__c, Scrum_Team__c, SFDC_Case__c, Status__c, Type__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Closed__c = false AND (RecordType.Name = 'Secondary Tasks') Order By Logged_Date__c];
                
                renderViewEffortsROPanel = false;
                renderViewEffortsRWPanel = false;
            }
        }


        public void ViewEfforts(){
            renderViewEffortsROPanel = true;
            renderViewEffortsRWPanel = false;
            tteList= new List<Timesheet__c>();
            Task__c t = [Select Id, RecordType.Name, Total_Efforts__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Task_Number__c = :tskNum limit 1];
            tskEff = t.Total_Efforts__c;
            if(t.RecordType.Name == 'Secondary_Tasks'){
                tteList = [Select Id, Assignee__c, Task_Number__c, Date__c, Associated_to_Task__c, Effort_Description__c, Efforts_in_hrs__c from Timesheet__c where Associated_to_Task__c = :t.Id Order By Date__c limit 5];
            }
            else{
                tteList = [Select Id, Assignee__c, Task_Number__c, Date__c, Associated_to_Task__c, Effort_Description__c, Efforts_in_hrs__c from Timesheet__c where Associated_to_Task__c = :t.Id Order By Date__c];
            }
        }

        public void displayTasksOfAssignee(){
            if(assignedTasksIndividual.Assignee__c != 'All') {
                listTasksofAssignee = new List<Task__c>();
                if(renderIncOpPanel == true && renderMiscOpPanel == false){
                    listTasksofAssignee = [Select Id, RecordType.Name, Task_Number__c, Total_Efforts__c, Action__c, Application_Area__c, Assignee__c, Change_Request__c, Customer__c, Date_Forwarded_to_L2__c, Days_in_L1_Queue__c, Days_in_L2_Queue__c, Description__c, JIRA_Ticket__c, Logged_Date__c, Priority__c, Scrum_Team__c, SFDC_Case__c, Status__c, Type__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Closed__c = false AND (RecordType.Name = 'Enhancement Request' OR RecordType.Name = 'Support Incident') AND Assignee__c = :assignedTasksIndividual.Assignee__c Order By Logged_Date__c];
                }
                else{
                    listTasksofAssignee = [Select Id, RecordType.Name, Task_Number__c, Total_Efforts__c, Action__c, Application_Area__c, Assignee__c, Change_Request__c, Customer__c, Date_Forwarded_to_L2__c, Days_in_L1_Queue__c, Days_in_L2_Queue__c, Description__c, JIRA_Ticket__c, Logged_Date__c, Priority__c, Scrum_Team__c, SFDC_Case__c, Status__c, Type__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Closed__c = false AND (RecordType.Name = 'Secondary Tasks') AND Assignee__c = :assignedTasksIndividual.Assignee__c Order By Logged_Date__c];
                }
            }
            else {
                listTasksofAssignee = [Select Id, RecordType.Name, Task_Number__c, Total_Efforts__c, Action__c, Application_Area__c, Assignee__c, Change_Request__c, Customer__c, Date_Forwarded_to_L2__c, Days_in_L1_Queue__c, Days_in_L2_Queue__c, Description__c, JIRA_Ticket__c, Logged_Date__c, Priority__c, Scrum_Team__c, SFDC_Case__c, Status__c, Type__c, Date_TS__c, Efforts_TS__c, Efforts_Description_TS__c from Task__c where Closed__c = false AND (RecordType.Name = 'Enhancement Request' OR RecordType.Name = 'Support Incident') Order By Logged_Date__c];
            }
            renderViewEffortsROPanel = false;
            renderViewEffortsRWPanel = false;
        }
        
        public void edtBtnClick(){
            tsToEdit = [select Id, Task_Number__c, Efforts_in_hrs__c, Date__c, Assignee__c, Effort_Description__c from Timesheet__c where Id = :tsToEditId];
            renderViewEffortsRWPanel = true;
        }
        
        public PageReference saveUpdatedTS(){
            try{
                database.update(tsToEdit);
            }
            catch (exception e){
                system.debug('POC Exception caught while Edit of TS from Display Efforts Section: ' + e.getMessage());
            }
            renderViewEffortsRWPanel = false;
            return null;
        }
        
        public void cancelUpdateToTS(){
            renderViewEffortsRWPanel = false;
        }
        
        public PageReference delBtnClick(){
            tsToDelete = [select Id from Timesheet__c where Id = :tsToDeleteId];
            
            try{
                if(tsToDelete != null){
                    database.delete(tsToDelete, false);
                }
            }
            catch(exception e){
                system.debug('POC exception caught while deletion of Timesheet: ' + tsToDelete + ' ; ' + e.getMessage());
            }
            PageReference pg = new PageReference('/apex/TimeSheetEntry');
            pg.setRedirect(true);
            return pg;
        }


        public PageReference SaveAllEfforts(){
            
            system.debug('POC: inside SaveAllEfforts');
            
            ApexPages.Message errorMsgValuesMissing = new ApexPages.Message(ApexPages.Severity.ERROR, 'For any particular task, Please enter value in all the three fields');
            
            List<Task__c> lstTaskToUpdate = new List<Task__c>();
            Set<Id> setTaskIdsToUpdate = new Set<Id>();
            
            Set<String> setCompositeKeyTask = new Set<String>();
            Set<String> setCompositeKeyTS = new Set<String>();
            
            For(Task__c t: listTasksofAssignee){
                
                system.debug('POC setCompositeKeyTask: ' + setCompositeKeyTask);
                
                if((null != t.Efforts_TS__c) && (null != t.Date_TS__c) && (null != t.Efforts_Description_TS__c && String.isNotBlank(t.Efforts_Description_TS__c)) ){
                    setTaskIdsToUpdate.add(t.Id);
                    setCompositeKeyTask.add(t.Task_Number__c + ' | ' + t.Date_TS__c + ' | ' + t.Assignee__c);
                    lstTaskToUpdate.add(t);        
                } else if((null != t.Efforts_TS__c) || (null != t.Date_TS__c ) || (null != t.Efforts_Description_TS__c && String.isNotBlank(t.Efforts_Description_TS__c))){
                    ApexPages.addMessage(errorMsgValuesMissing);
                    return null;
                } 
            }
            
            system.debug('POC: lstTaskToUpdate = ' + lstTaskToUpdate);     
            
            List<Timesheet__c> listExistingTimesheet = new List<Timesheet__c>();
            listExistingTimesheet = [select Id, Task_Number__c, Efforts_in_hrs__c, Date__c, Assignee__c from Timesheet__c where Associated_To_Task__c = :setTaskIdsToUpdate];
            
            for(Timesheet__c ts : listExistingTimesheet){
                setCompositeKeyTS.add(ts.Task_Number__c + ' | ' + ts.Date__c + ' | ' + ts.Assignee__c);
            }
            
            system.debug('POC setCompositeKeyTS: ' + setCompositeKeyTS);
            
            for(String s : setCompositeKeyTask){
                if(setCompositeKeyTS.contains(s)){
                    String errTask = s.substringBefore(' |');
                    String errAssignee = s.substringAfterLast('| ');
                    String errDate = s.substringBetween('| ',' |');
                    String errDateDisp = errDate.left(11);
                    ApexPages.Message errorMsgExitingTS = new ApexPages.Message(ApexPages.Severity.INFO, 'There is already an existing Timesheet entry for Task: ' + errTask + ' for Date: ' + errDateDisp + ' for Assignee: ' + errAssignee);

                    ApexPages.addMessage(errorMsgExitingTS);
                    return null;
                }
            }
            
            try{
                if(lstTaskToUpdate.size() > 0){
                        TaskTSTriggerControlHandlerUtil.isTskUpdFrmSaveAll = true;
                        database.update(lstTaskToUpdate);
                }
            }
            catch(exception e) {
                system.debug('Exception caught while update of Tasks: ' + e.getMessage());
            }
            return null;
        }
}