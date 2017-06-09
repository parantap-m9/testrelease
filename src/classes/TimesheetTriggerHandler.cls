public without sharing class TimesheetTriggerHandler {
    
    public static void OnBeforeInsert(List<Timesheet__c> listNewTS) {
        
    }

    public static void OnAfterInsert(List<Timesheet__c> listNewTS, Map<Id, Timesheet__c> mapNewTS){
        populateTotalEffortsOnTSIns(listNewTS);
    }

    public static void OnBeforeUpdate(List<Timesheet__c> listOldTS, List<Timesheet__c> listNewTS, Map<Id, Timesheet__c> mapOldTS, Map<Id, Timesheet__c> mapNewTS){

    }

    public static void OnAfterUpdate(List<Timesheet__c> listOldTS, List<Timesheet__c> listNewTS, Map<Id, Timesheet__c> mapOldTS, Map<Id, Timesheet__c> mapNewTS){
        populateTotalEffortsOnTSIns(listNewTS);
    }

    public static void OnBeforeDelete(List<Timesheet__c> listOldTS, Map<Id, Timesheet__c> mapOldTS) {

    }

    public static void OnAfterDelete(List<Timesheet__c> listOldTS, Map<Id, Timesheet__c> mapOldTS){
        updateTotalEffortsOnTSDel(listOldTS, mapOldTS);        
    }   

    public static void OnUndelete(List<Timesheet__c> listNewTS, Map<Id, Timesheet__c> mapNewTS) {
        
    }
    
    
    /**
     * @Description This method is responsible for updating Task 
     * record whenever TS is inserted with correct Total Efforts field
     * 
     * @Param Map<Id, TimeSheet__c> Map Old TimeSheet
     * @Param List<Task__c> List Updated Tasks
     * 
     * @Return Void
     */



    private static void populateTotalEffortsOnTSIns(List<Timesheet__c> listNewTS){
        
        system.debug('POC listNewTS = ' + listNewTS);
        
        Set<Id> setTaskIdsIns = new Set<Id>();
        Map<String,Decimal> mapTotalEffortsIns = new Map<String,Decimal>();
        List<Timesheet__c> lstTS = [Select Id, Associated_to_Task__c, Associated_to_Task__r.Total_Efforts__c, Date__c, Effort_Description__c, Efforts_in_hrs__c, Task_Number__c from Timesheet__c where Id IN :listNewTS];
        
        For(Timesheet__c t: lstTS){
            setTaskIdsIns.add(t.Associated_to_Task__c);
        }

        List<Task__c> listTask = [Select Id, Total_Efforts__c, Task_Number__c, (select Id, Associated_To_Task__c, Date__c, Efforts_in_hrs__c from Timesheets__r) from Task__c where id IN :setTaskIdsIns];
        //List<Timesheet__c> listExistingTS = [select Id, Associated_To_Task__c, Date__c, Efforts_in_hrs__c from Timesheet__c where Associated_To_Task__c = :setTaskIdsIns]; 
        //Decimal calcTotalEff = 0;
        
        for(Task__c ta : listTask){
            for(Timesheet__c ts : ta.Timesheets__r){
                    if(!mapTotalEffortsIns.containskey(ts.Associated_To_Task__c)){
                        mapTotalEffortsIns.put(ts.Associated_To_Task__c, ts.Efforts_in_hrs__c);
                    }
                    else{
                        decimal d = 0;
                        d = mapTotalEffortsIns.get(ts.Associated_To_Task__c);
                        mapTotalEffortsIns.put(ts.Associated_To_Task__c, d + ts.Efforts_in_hrs__c);
                    }
                }
            }
        
        For(Task__c tsk:listTask){
            tsk.Total_Efforts__c = mapTotalEffortsIns.get(tsk.Id);
            tsk.Efforts_TS__c = null;
            tsk.Efforts_Description_TS__c = null;
            tsk.Date_TS__c = null;

        }

        TaskTSTriggerControlHandlerUtil.setTaskTriggerInactive();
        update listTask;
        
    }


    /**
     * @Description This method is responsible for updating Task 
     * record whenever TS is updated with correct Total Efforts field
     * 
     * @Param Map<Id, TimeSheet__c> Map Old TimeSheet
     * @Param List<Task__c> List Updated Tasks
     * 
     * @Return Void
     */
     /*
    private static void populateTotalEffortsOnTSUpd(List<Timesheet__c> listNewTS){
       */ /*
        Set<Id> tskList = new Set<Id>();
        Map<Id,Decimal> mapTotalEffortsUpd = new Map<Id,Decimal>();
        List<Timesheet__c> lstTS = [Select Id, Associated_to_Task__c, Associated_to_Task__r.Total_Efforts__c, Date__c, Effort_Description__c, Efforts_in_hrs__c, Task_Number__c from Timesheet__c where Id IN :listNewTS];
        
        For(Timesheet__c t: lstTS) {
            if(mapOldTS.get(t.Id).Efforts_in_hrs__c != mapNewTS.get(t.Id).Efforts_in_hrs__c) {
                tskList.add(t.Associated_to_Task__c);
                if(!mapTotalEffortsUpd.containsKey(t.Associated_to_Task__c)){
                    if(t.Associated_to_Task__r.Total_Efforts__c == null){
                        t.Associated_to_Task__r.Total_Efforts__c = 0;
                    }

                    Decimal temp1 = t.Associated_to_Task__r.Total_Efforts__c + MapNewTS.get(t.Id).Efforts_in_hrs__c - MapOldTS.get(t.Id).Efforts_in_hrs__c;
                        mapTotalEffortsUpd.put(t.Associated_to_Task__c, temp1);                      
                } else {
                        Decimal temp2 = mapTotalEffortsUpd.get(t.Associated_to_Task__c) + MapNewTS.get(t.Id).Efforts_in_hrs__c - MapOldTS.get(t.Id).Efforts_in_hrs__c;
                        mapTotalEffortsUpd.put(t.Associated_to_Task__c, temp2);
                }
            } 

        }

        List<Task__c> listTask = [Select Id, Total_Efforts__c,Task_Number__c from Task__c where id IN :tskList];
        For(Task__c tsk:listTask){
            tsk.Total_Efforts__c = mapTotalEffortsUpd.get(tsk.Id);
        }    
        update listTask;
        *//*
        Set<Id> setTskIdsUpd = new Set<Id>();
        Map<Id,Decimal> mapTotalEffortsUpd = new Map<Id,Decimal>();
        List<Timesheet__c> lstTS = [Select Id, Associated_to_Task__c, Associated_to_Task__r.Total_Efforts__c, Date__c, Effort_Description__c, Efforts_in_hrs__c, Task_Number__c from Timesheet__c where Id IN :listNewTS];
        
        For(Timesheet__c t: lstTS) {
            setTskIdsUpd.add(t.Associated_to_Task__c);
        }
        List<Task__c> lstTask = [Select Id,(Select Id from TimeSheets__r) from Task__c where Id IN :setTskIdsUpd];

        For(Task__c ta : lstTask){
            decimal totalEff = 0;
            
            For(TimeSheet__c ts: lstTS){
                totalEff = totalEff + ts.Efforts_in_hrs__c;
            }        
            
            ta.Total_Efforts__c = totalEff;
            ta.Efforts_TS__c = null;
            ta.Efforts_Description_TS__c = null;
            ta.Date_TS__c = null;
        }
        
        if(lstTask.size() > 0){
            try{
                database.update(lstTask, false);
            }
            
            catch(exception e){
                system.debug('exception caught while update of Total Efforts on Task object: ' + e.getMessage());
            }
        }
    }
    */
    /**
     * @Description This method is responsible for updating Task 
     * record whenever TS is deleted
     * 
     * @Param Map<Id, TimeSheet__c> Map Old TimeSheet
     * @Param List<Task__c> List Updated Tasks
     * 
     * @Return Void
     */
    private static void updateTotalEffortsOnTSDel(List<Timesheet__c> listOldTS, Map<Id, Timesheet__c> mapOldTimeSheet){

        Map<Id, List<TimeSheet__c>> mapTsktolstTS = new Map<Id, List<TimeSheet__c>>();
        List<Timesheet__c> lstTStoTsk = new List<Timesheet__c>();
        
        For(Timesheet__c ts: mapOldTimeSheet.values()){
            if(!mapTsktolstTS.containsKey(ts.Associated_to_Task__c)){
                List<Timesheet__c> lstTStoTskNew = new List<Timesheet__c>();
                lstTStoTskNew.add(ts);
                mapTsktolstTS.put(ts.Associated_to_Task__c, lstTStoTskNew);
            } else {
                lstTStoTsk = mapTsktolstTS.get(ts.Associated_to_Task__c);
                lstTStoTsk.add(ts);
                mapTsktolstTS.put(ts.Associated_to_Task__c, lstTStoTsk);  
            }
    
        }
        List<Task__c> lstAllAssociatedTasks = [Select Id, Total_Efforts__c from Task__c where Id IN :mapTsktolstTS.keyset()];
        List<Task__c> lstTaskstoUpdate = new List<Task__c>();
        Decimal hoursToDeduct;
        For(Task__c t :lstAllAssociatedTasks){
            List<Timesheet__c> lstTS = new List<Timesheet__c>();
            lstTS.addAll(mapTsktolstTS.get(t.Id));
            For(Timesheet__c ts : lstTS){
                hoursToDeduct = 0;
                hoursToDeduct+=ts.Efforts_in_hrs__c;
            }
            t.Total_Efforts__c = t.Total_Efforts__c - hoursToDeduct;
            lstTaskstoUpdate.add(t);
        }
        if(lstTaskstoUpdate.size() > 0){
            Database.update(lstTaskstoUpdate, false);    
        }

    }

}