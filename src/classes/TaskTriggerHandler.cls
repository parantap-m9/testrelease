public without sharing class TaskTriggerHandler {
    public static void OnBeforeInsert(List<Task__c> listNewTask, Map<Id, Task__c> mapNewTask) {
        updateSFDCCase(listNewTask);
    }

    public static void OnAfterInsert(List<Task__c> listNewTask, Map<Id, Task__c> mapNewTask){

    }

    public static void OnBeforeUpdate(List<Task__c> listOldTask, List<Task__c> listNewTask, Map<Id, Task__c> mapOldTask, Map<Id, Task__c> mapNewTask){
    	updatePreviousEffortsOnAssigneeChng(mapOldTask, mapNewTask);
    }

    public static void OnAfterUpdate(List<Task__c> listOldTask, List<Task__c> listNewTask, Map<Id, Task__c> mapOldTask, Map<Id, Task__c> mapNewTask){
        insertTimeSheetOnSaveAll(mapOldTask, mapNewTask);
    }

    public static void OnBeforeDelete(List<Task__c> listOldTask, Map<Id, Task__c> mapOldTask) {

    }

    public static void OnAfterDelete(List<Task__c> listOldTask, Map<Id, Task__c> mapOldTask) {

    }  

    public static void OnUndelete(List<Task__c> listNewTask, Map<Id, Task__c> mapNewTask) {

    }

    /**
     * @Description This method is responsible for inserting 
     * TimeSheetEntry record whenever user enters the details
     * on VF page.
     * @Param Map<Id, Task__c> Map Updated Tasks
     * @Param List<Task__c> List Updated Tasks
     * 
     * @Return Void
     */
    private static void insertTimeSheetOnSaveAll(Map<Id, Task__c> mapOldTasks, Map<Id, Task__c> mapUpdatedTasks){
     
        system.debug('POC inside insertTimeSheetOnSaveAll');
        
        system.debug('POC isTskUpdFrmSaveAll from TaskTriggerHandler = ' + TaskTSTriggerControlHandlerUtil.isTskUpdFrmSaveAll);
     
        if(TaskTSTriggerControlHandlerUtil.isTskUpdFrmSaveAll){
            List<Timesheet__c> tsList = new List<Timesheet__c>();
            For(Task__c t: mapUpdatedTasks.values()){
                Timesheet__c ts = new Timesheet__c();
                if(mapOldTasks.get(t.Id).Efforts_TS__c != mapUpdatedTasks.get(t.Id).Efforts_TS__c || mapOldTasks.get(t.Id).Date_TS__c != mapUpdatedTasks.get(t.Id).Date_TS__c || mapOldTasks.get(t.Id).Efforts_Description_TS__c != mapUpdatedTasks.get(t.Id).Efforts_Description_TS__c){
                    ts.Associated_to_Task__c = t.Id;
                    ts.Date__c = t.Date_TS__c;
                    ts.Effort_Description__c = t.Efforts_Description_TS__c;
                    ts.Efforts_in_hrs__c = t.Efforts_TS__c;
                    ts.Assignee__c = t.Assignee__c;
                    tsList.add(ts);
                }
            }
            
            system.debug('POC tsList = ' + tsList);
            
            if(tsList.size() > 0){
                insert tsList;
            }
        }
    }

     
     /**
     * @Description This method is responsible for updating 
     * Previous Efforts field whenever Assignee changes on Task
     * @Param Map<Id, Task__c> Map Old Tasks
     * @Param Map<Id, Task__c> Map Updated Tasks
     * 
     * @Return Void
     */
         
    public static void updatePreviousEffortsOnAssigneeChng(Map<Id, Task__c> mapOldTsk, Map<Id, Task__c> mapNewTsk){
     	For(Task__c t: mapNewTsk.values()){
     		if(t.Assignee__c != mapOldTsk.get(t.Id).Assignee__c){
     			t.Previous_Assignee_Efforts__c = t.Total_Efforts__c;
     			t.Total_Efforts__c = 0;
     		}
     	}
     }
     


     /**
     * @Description This method is responsible for updating 
     * SFDC Case # based on incident summary.
     * @Param List<Task__c> Map New Tasks
     * 
     * @Return Void
     */
    private static void updateSFDCCase(List<Task__c> listNewTask){
        For(Task__c t: listNewTask){
            String DESCRIPTION = t.Description__c;
            If(DESCRIPTION.startsWith(Label.SFDCSTART) && DESCRIPTION.substring(15, 18).equalsignorecase(' - ')){
                t.SFDC_Case__c = DESCRIPTION.substring(7, 15);
            }
        } 
    }
}