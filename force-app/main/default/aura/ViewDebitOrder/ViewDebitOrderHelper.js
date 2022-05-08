({
	  
     doInit : function(component, event, helper) {
	 
        // Todate set to Todays date
        var today = new Date();
        component.set('v.toDate1', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
		
        // Fromdate equal to Todays date minus 40
        var result = new Date();
        result.setDate(result.getDate() - 40);
        component.set('v.fromDate1', result.getFullYear() + "-" + (result.getMonth() + 1) + "-" + result.getDate());
      
   },
   
    sortData: function (component, fieldName, sortDirection) {
     var data = component.get("v.ViewDebitList.debitCreditList");
     var reverse = sortDirection !== 'asc';
     //sorts the rows based on the column header that's clicked
     data.sort(this.sortBy(fieldName, reverse))
     component.set("v.ViewDebitList.debitCreditList", data);
     },
 	
    sortBy: function (field, reverse, primer) {
     var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
     //checks if the two rows should switch places
     reverse = !reverse ? 1 : -1;
     return function (a, b) {
         return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
     }
 },
       
        
    filterRefDataView: function(component, event, helper) {
    var data = component.get("v.ViewDebitList.debitCreditList"),
          
     term = component.get("v.filterRef"),
            results = data, regex;
       var data1 =JSON.stringify(data);
       regex = new RegExp(term, "i");
        // filter checks each row, constructs new array where function returns true
        if(results!=null){
        results = data.filter(row => regex.test(row.userRef));
        }
        if((term != '') && (data != null)){
        component.set("v.ViewDebitList.debitCreditList", results); 
        }else{
            this.getDebitOrderList(component);
        }
    },
    filterAmtDataView: function(component, event, helper) {
    var data = component.get("v.ViewDebitList.debitCreditList"),
      term = component.get("v.filterAmount"),
       results = data, regex;
       var data1 =JSON.stringify(data);
        regex = new RegExp(term, "i");
       if(results!=null){
         results = data.filter(row => regex.test(row.amount));
         }        
        if((term != '' )&& (data != null)){
        component.set("v.ViewDebitList.debitCreditList", results); 
        }else{
            this.getDebitOrderList(component);
        }
    },
    
    getDebitOrderList : function(component, event, helper) {
        
        var action = component.get("c.viewDebitOrderDetails");
        var selectedAccountValue = component.get('v.SelectedAccNumberFromFlow');
        var frmdte = component.find("fDate").get("v.value");
        var fromdatestr =frmdte.toString();

        var fromdate = fromdatestr.replace(/-/g,"");
		
        action.setParams({
			'AccountId': selectedAccountValue,
            'FrmDate' : fromdate
           
        });
		action.setCallback(this, function(response) {
            var state = response.getState();
			if (state === "SUCCESS") {
                
                if(response.getReturnValue()){
				var resObj = response.getReturnValue();
				
                var json = JSON.parse(resObj);
                
             component.set("v.ViewDebitList",json);
                                    component.set('v.columns', [
                    {label: 'ACTION DATE', fieldName: 'actionDate', type: 'text'},
                    {label: 'USER CODE', fieldName: 'userCode', type: 'text', sortable: true},
                    {label: 'USER SEQ', fieldName: 'userSeq', type: 'text', sortable: true},
                    {label: 'USER REFERENCE', fieldName: 'userRef', type: 'text', sortable: true},
                    {label: 'AMOUNT', fieldName: 'amount', type: 'text', sortable: true},
                    {label: 'TRAN GRP', fieldName: 'trnGrp', type: 'text', sortable: true},
                    {label: 'STAT', fieldName: 'status', type: 'text', sortable: true}
                ]);     
				if(json.respCode == '47' && json.debitCreditList == ''){    
						alert('enter');                    
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": "Please select valid Check or Savings Account Number"
                        });
                        toastEvent.fire();
                    }else if(json.debitCreditList == '' ){                        
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": "There are currently no debit orders available to display."
                        });
                        toastEvent.fire();
                    }
                } }
		});
		$A.enqueueAction(action);
    },
   })