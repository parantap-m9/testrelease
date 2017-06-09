trigger BugTrigger on Bug__c (after update) {
    List<Task> lstTask = new List<Task>();
    List<Id> ClsTskOfBugIds = new List<Id>();
    For(Bug__c b: Trigger.New){
        if(b.Status__c == 'Resolved' || b.Status__c == 'Closed'){
            ClsTskOfBugIds.add(b.Id);
        }
    }

    lstTask = [Select Id, Status from Task where WhatId = :ClsTskOfBugIds];
    For(Task t: lstTask){
    	t.Status = 'Completed';

    }
}