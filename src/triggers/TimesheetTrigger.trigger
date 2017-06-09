// NEED MODIFICATION WITH BEST CODING PRACTICES AND RESOLVE BUG AS NOT WORKING AS EXPECTED

    trigger TimesheetTrigger on Timesheet__c (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
    ) {
     
        if(Trigger.isInsert && Trigger.isBefore){
            TimesheetTriggerHandler.OnBeforeInsert(Trigger.New);
        } else if(Trigger.isInsert && Trigger.isAfter){
            TimesheetTriggerHandler.OnAfterInsert(Trigger.New, Trigger.NewMap);
        } else if(Trigger.isUpdate && Trigger.isBefore){
            TimesheetTriggerHandler.OnBeforeUpdate(Trigger.Old, Trigger.New, Trigger.OldMap, Trigger.NewMap);
        } else if(Trigger.isUpdate && Trigger.isAfter){
            TimesheetTriggerHandler.OnAfterUpdate(Trigger.Old, Trigger.New, Trigger.OldMap, Trigger.NewMap);
        } else if(Trigger.isDelete && Trigger.isBefore){
            TimesheetTriggerHandler.OnBeforeDelete(Trigger.Old, Trigger.OldMap);
        } else if(Trigger.isDelete && Trigger.isAfter){
            TimesheetTriggerHandler.OnAfterDelete(Trigger.Old, Trigger.OldMap);
        } else if(Trigger.isUndelete){
            TimesheetTriggerHandler.OnUndelete(Trigger.New, Trigger.NewMap);
        }
    }