public class incidentOverviewHomepageCtrl {

    public Boolean renderTempPanel {get; set;}
    public String selectedQueue {get; set;}
    
    public void incidentOverviewHomepageCtrl(){
        renderTempPanel = true;
    }
    
    public pageReference queueSelection(){
        system.debug('Rahul selectedQueue = '+selectedQueue);
        PageReference pageRef = Page.IncidentOverviewPage;
            pageRef.getParameters().put('queue',selectedQueue);

        return pageRef;
    }

}