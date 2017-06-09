trigger TaskTrigger on Task__c (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
    )
    {
        if(TaskTSTriggerControlHandlerUtil.hasActiveTaskTrigger()){
         
            if(Trigger.isInsert && Trigger.isBefore){
                TaskTriggerHandler.OnBeforeInsert(Trigger.New, Trigger.NewMap);
            } else if(Trigger.isInsert && Trigger.isAfter){
                TaskTriggerHandler.OnAfterInsert(Trigger.New, Trigger.NewMap);
            } else if(Trigger.isUpdate && Trigger.isBefore){
                TaskTriggerHandler.OnBeforeUpdate(Trigger.Old, Trigger.New, Trigger.OldMap, Trigger.NewMap);
            } else if(Trigger.isUpdate && Trigger.isAfter){
                TaskTriggerHandler.OnAfterUpdate(Trigger.Old, Trigger.New, Trigger.OldMap, Trigger.NewMap);
            } else if(Trigger.isDelete && Trigger.isBefore){
                TaskTriggerHandler.OnBeforeDelete(Trigger.Old, Trigger.OldMap);
            } else if(Trigger.isDelete && Trigger.isAfter){
                TaskTriggerHandler.OnAfterDelete(Trigger.Old, Trigger.OldMap);
            } else if(Trigger.isUndelete){
                TaskTriggerHandler.OnUndelete(Trigger.New, Trigger.NewMap);
            }
        }
}