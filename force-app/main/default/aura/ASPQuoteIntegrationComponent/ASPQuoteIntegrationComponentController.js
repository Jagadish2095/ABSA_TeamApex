({    
     doInit: function(component, event, helper) {
         var quoteObject = {
            isQuoteStoredInQMS : component.get('v.isQuoteStoredInQMS'),
            QuoteData :  component.get('v.QuoteData'),
        }; 
          component.set('v.RequestJSON',JSON.stringify(quoteObject));
      },
      
      HandleResponse : function(component, event, helper) 
      {
       // var Status = event.getParam('status');
      var ResponseMetadata = event.getParam('responseMetadata');
      //  if(ResponseMetadata != 'PENDING')
      //  {
       component.set('v.QuoteReturnStatus',ResponseMetadata);
       // var navigate = component.get("v.navigateFlow");
      //  navigate("NEXT");    
      //  }                      
      },
          
})