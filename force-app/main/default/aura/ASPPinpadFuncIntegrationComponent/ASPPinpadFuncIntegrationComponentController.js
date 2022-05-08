({
    doInit: function(component, event, helper) {
    var getRequestJSONAction = component.get('c.GetPinPadRequestMetadata')
    var PinPadFunction  = component.get('v.PinPadFunction');
    var RecordId  = component.get('v.recordId');
    getRequestJSONAction.setParams({
      'PinpadFunction' : PinPadFunction,   
      'RecordId' :  RecordId,          
   });
   getRequestJSONAction.setCallback(this, function(response) {
       var RequestMetadata = response.getReturnValue() ;            
      component.set('v.RequestJSON',RequestMetadata)     
  });
  $A.enqueueAction(getRequestJSONAction);
  },
  
  HandleResponse : function(component, event, helper) 
  {
    var Status = event.getParam('status');
    var ResponseMetadata = event.getParam('responseMetadata');
    component.set('v.PinPadData',ResponseMetadata)             
               
  },
         
  });