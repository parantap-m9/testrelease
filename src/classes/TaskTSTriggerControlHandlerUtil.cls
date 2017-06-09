public without sharing class TaskTSTriggerControlHandlerUtil {
	private static Boolean taskTriggerActive = true;
	private static Boolean timeSheetTriggerActive = true;
	

	public static Boolean isTskUpdFrmSaveAll = false;

	public static Boolean hasActiveTaskTrigger(){
		return taskTriggerActive;			
	}

	public static void setTaskTriggerActive(){
		taskTriggerActive = true;
	}

	public static void setTaskTriggerInactive(){
		taskTriggerActive = false;	
	}

	public static Boolean hasActiveTSTrigger(){
		return timeSheetTriggerActive;			
	}

	public static void setTSTriggerInactive(){
		timeSheetTriggerActive = false;	
	}

}