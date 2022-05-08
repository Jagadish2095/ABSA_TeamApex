({
	doInit : function(component, event, helper) { 
         component.set('v.columns',[
            {label: 'Account Number', fieldName: 'oaccntnbr', type: 'text',wrapText: 'true', hideDefaultActions: 'true'},
            {label: 'Product Type', fieldName: 'product', type: 'text' ,wrapText: 'true', hideDefaultActions: 'true'},
            {label: 'Account Status', fieldName: 'status', type: 'text',wrapText: 'true', hideDefaultActions: 'true'},
             {label: 'Available R', fieldName: 'availableBalance', type: 'currency', typeAttributes: { currencyCode: 'ZAR', maximumSignificantDigits: 5} ,wrapText: 'true', hideDefaultActions: 'true'},
            {label: 'Balance R', fieldName: 'balance', type: 'currency', typeAttributes: { currencyCode: 'ZAR', maximumSignificantDigits: 5},wrapText: 'true', hideDefaultActions: 'true'}
          
        ]);       

      // helper.fetchDataAccounts(cmp, fetchData, 10); 
       helper.fetchDataAccounts(component, event, helper);    
    },
    
    //Next button function on Product Pagination
    nextProduct: function(component, event, helper) {
        helper.nextProductSet(component, event);
    },
    
    //Prev button function on Product Pagination
    previousProduct: function(component, event, helper) {
        helper.previousProductSet(component, event);
    },
    
    handleNavigate: function(component, event, helper) {
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");

        switch(actionClicked)
        {
            case "NEXT": 
            case "FINISH":
                {   
                    var cancontinue=component.get('v.NoRecordsFound');
                   if(cancontinue=='' || cancontinue==null)
                   {
                    navigate(actionClicked);
                   /* $A.getCallback(function(result) {
                        navigate(actionClicked);  
                    })*/
                   }
                    else
                    {
                            var homeEvent = $A.get("e.force:navigateToURL");
                    homeEvent.setParams({
                        "url": "/home/home.jsp"
                    });        
                    homeEvent.fire();
                    window.close();
                    }
                    break;   
                }
            case "BACK":
                {
                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    navigate(event.getParam("action"));
                    break;
                }
        }
        
    }
})