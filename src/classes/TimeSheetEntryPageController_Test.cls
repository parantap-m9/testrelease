@isTest
private class TimeSheetEntryPageController_Test {


	 static testMethod void test_method_one() {
			List<Task__c> lstTsk = new List<Task__c>();
		Map<Id, RecordType> mapRecType = new Map<Id, RecordType>([Select Id, Name from RecordType where SObjectType = 'Task__c']);
			List<Timesheet__c> lstTS = new List<Timesheet__c>();
			Integer i = 0;
		For(RecordType r : mapRecType.values()){
			Task__c t = new Task__c();
			t.RecordTypeId = r.Id;
			t.Type__c = 'Incident';
			t.Task_Number__c = 'Inc'+r.Name;
			t.Logged_Date__c = System.TODAY();
			t.Priority__c = 'CSO';
			t.Date_Forwarded_to_L2__c = System.TODAY();
			t.Description__c = 'Desc';
			t.Assignee__c = 'Ambuj Mehta';
			t.Status__c = 'Assigned';
			t.Customer__c = 'ABC';
			//if(i != 1){
				t.Efforts_TS__c = 3;
			//}
			t.Date_TS__c = Date.today();
			t.Efforts_Description_TS__c = 'TS DESCRIPTION';
			lstTsk.add(t);
			i++;
		}
		insert lstTsk;
		Set<Id> setTskUpd = new Set<Id>();
		List<Task__c> lstTskUp = new List<Task__c>();
		For(Task__c t: lstTsk){
			Timesheet__c ts = new Timesheet__c();
			ts.Associated_to_Task__c = t.Id;
			ts.Date__c = Date.today();
			ts.Efforts_in_hrs__c = 3;
			ts.Effort_Description__c = 'Efforts Desc' +t.Task_Number__c;
			lstTS.add(ts);
			t.Description__c = 'New Desc'+t.Task_Number__c;
			lstTskUp.add(t);
			setTskUpd.add(t.Id);
		}
		try{
			insert lstTS;
			update lstTskUp;
		} catch(Exception e){

		}
		
			//TaskTSTriggerControlHandlerUtil.hasActiveTaskTrigger();
			
		Task__c tskDel = new Task__c();
			tskDel.RecordTypeId = mapRecType.values()[0].Id;
			tskDel.Type__c = 'Incident';
			tskDel.Task_Number__c = 'INC0000012345';
			tskDel.Logged_Date__c = System.TODAY();
			tskDel.Priority__c = 'CSO';
			tskDel.Date_Forwarded_to_L2__c = System.TODAY();
			tskDel.Description__c = 'Desc';
			tskDel.Assignee__c = 'Ambuj Mehta';
			tskDel.Status__c = 'Assigned';
			tskDel.Customer__c = 'ABC';
			//if(i != 1){
				tskDel.Efforts_TS__c = 3;
			//}
			tskDel.Date_TS__c = Date.today();
			tskDel.Efforts_Description_TS__c = 'TS DESCRIPTION';
			insert tskDel;

		test.StartTest();
			
				 
			TimeSheetEntryPageController cnt = new TimeSheetEntryPageController();
			cnt.tabtoDisplay = 'Inc';
			cnt.tabSelection();
			cnt.tabtoDisplay = 'Misc';
			cnt.tabSelection();
			cnt.tskNum = lstTsk[0].Task_Number__c;
			cnt.ViewEfforts();
			cnt.assignedTasksIndividual = lstTsk[1];
			cnt.displayTasksOfAssignee();
			cnt.renderIncOpPanel = true;
			cnt.renderMiscOpPanel = false;
			cnt.displayTasksOfAssignee();
			cnt.assignedTasksIndividual.Assignee__c = 'All';
			cnt.displayTasksOfAssignee();
			cnt.tsToEditId = lstTS[0].Id;
			cnt.edtBtnClick();
			cnt.saveUpdatedTS();
			cnt.cancelUpdateToTS();
			cnt.tsToDeleteId = lstTS[1].Id;
			cnt.delBtnClick();
			cnt.listTasksofAssignee = lstTsk;
			cnt.SaveAllEfforts();
			lstTsk[0].Efforts_TS__c = null;
			cnt.SaveAllEfforts();
			lstTsk[0].Efforts_TS__c = 2.5;
			lstTsk[0].Date_TS__c = Date.today().addDays(-3);
			lstTsk[0].Efforts_Description_TS__c = 'My Eff TS Descr';
			cnt.SaveAllEfforts();

			TaskTSTriggerControlHandlerUtil.isTskUpdFrmSaveAll = true;
			Map<Id,Task__c> mapOldTsk = new Map<Id,Task__c>([Select Id, Efforts_TS__c, Date_TS__c, Efforts_Description_TS__c from Task__c where Id IN :setTskUpd]);
			List<Task__c> lstTaskUpdted = new List<Task__c>();
			List<Timesheet__c> lstTStoUpd = new List<Timesheet__c>();
			For(Task__c tsk: mapOldTsk.values()){
				tsk.Efforts_TS__c = 7;
				tsk.Date_TS__c = Date.today().addDays(-1);
				tsk.Efforts_Description_TS__c = 'New Description of TS';
				tsk.Assignee__c = 'Rahul Sharma';
				lstTaskUpdted.add(tsk);
				For(Timesheet__c ts: tsk.Timesheets__r){
					ts.Efforts_in_hrs__c = 5;
					lstTStoUpd.add(ts);
				}
			}
			
			upsert lstTaskUpdted;
			//System.assertEquals('New Description of TS', lstTaskUpdted[0].Efforts_Description_TS__c);
			TaskTSTriggerControlHandlerUtil.setTaskTriggerActive();
			Map<Id,Task__c> mapNewTsk = new Map<Id,Task__c>([Select Id, Efforts_TS__c, Date_TS__c, Efforts_Description_TS__c from Task__c where Id IN :setTskUpd]);
			TaskTriggerHandler.OnAfterUpdate(null, null, mapOldTsk, mapNewTsk);

			Timesheet__c tms = new Timesheet__c();
			
			tms = lstTS[0];

			TaskTSTriggerControlHandlerUtil.setTaskTriggerInactive();

			

			TaskTSTriggerControlHandlerUtil.hasActiveTSTrigger();
			update lstTStoUpd;
			TaskTSTriggerControlHandlerUtil.setTSTriggerInactive();
			TaskTSTriggerControlHandlerUtil.setTaskTriggerActive();
			delete tms;
			TaskTSTriggerControlHandlerUtil.setTSTriggerInactive();

			TaskTSTriggerControlHandlerUtil.setTaskTriggerActive();
			delete tskDel;
			TaskTSTriggerControlHandlerUtil.setTSTriggerInactive();

			TaskTSTriggerControlHandlerUtil.setTaskTriggerActive();
			undelete tskDel;
			TaskTSTriggerControlHandlerUtil.setTSTriggerInactive();

		test.StopTest();

	}
	


}