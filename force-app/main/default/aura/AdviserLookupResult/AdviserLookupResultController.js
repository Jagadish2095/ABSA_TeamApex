/**
 * This is the JavaScript Controller for the AdviserLookupResultController Component for the selection of Adviser records
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-02-23
 */

({
   selectRecord : function(component, event, helper) {

       var selectedRecord = component.get("v.oRecord");
       var compEvent = component.getEvent("oSelectedRecordEvent");
       
       compEvent.setParams({"recordByEvent" : selectedRecord });

       compEvent.fire();

    },
})