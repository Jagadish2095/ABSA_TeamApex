({
    
        doInit : function(component, event, helper) {
    
            //component.set("v.showLoadingSpinner", true);
            //Set Cloumns
            component.set('v.tableColumns', [
                { label: 'First Name', fieldName: 'FirstName', type: 'text'},
                { label: 'Last Name', fieldName: 'LastName', type: 'text'},
                { label: 'Role', fieldName: 'UserRole', type: 'text'},
                { label: 'Profile', fieldName: 'Profile', type: 'text'},
                { label: 'BRID', fieldName: 'BRID__c', type: 'text'}
            ]);
    
            /*
            //Get Group Members
            let userPromise = Promise.resolve(helper.promiseFetchUsers(component));
            userPromise.then( $A.getCallback(
                    function (result) {
                        //let options = result.map(record=>({label:record.Name,value:record.Email}));
                        console.log('result Data ==> '+ JSON.stringify(result));
                        var rows = result;
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.UserRole) row.UserRole = row.UserRole.Name;
                        }
    
                        component.set("v.groupMembersList", rows);
                        component.set("v.showLoadingSpinner", false);
                    }
                ),
                $A.getCallback(
                    function (status) {
                        component.set("v.showLoadingSpinner", false);
                        component.find('notifLib').showToast({ "variant": "error",
                                                                                                        "message": "Unable to fetch group members! "+status.message
                                                                                                });
                    }
                )
            ).catch(function (error) {
                component.set("v.showLoadingSpinner", false);
                $A.reportError("Unable to initialise component!", error);
            });*/
        },
    
        reLoad : function(component, event, helper) {
            var pgId = component.get("v.publicGroupSearchId");
    
            if(pgId != ""){
                component.set("v.showLoadingSpinner", true);
    
                //Get Group Members
                let userPromise = Promise.resolve(helper.promiseFetchUsers(component));
                userPromise.then( $A.getCallback(
                        function (result) {
                            //let options = result.map(record=>({label:record.Name,value:record.Email}));
                            console.log('result Data ==> '+ JSON.stringify(result));
                            var rows = result;
                            for (var i = 0; i < rows.length; i++) {
                                var row = rows[i];
                                if (row.UserRole) row.UserRole = row.UserRole.Name;
                                if (row.Profile) row.Profile = row.Profile.Name;
                            }
    
                            console.log('rows Data ==> '+ JSON.stringify(rows));
                            component.set("v.groupMembersList", rows);
                            component.set("v.showLoadingSpinner", false);
                        }
                    ),
                    $A.getCallback(
                        function (status) {
                            component.set("v.showLoadingSpinner", false);
                            component.find('notifLib').showToast({ "variant": "error",
                                                                                                            "message": "Unable to fetch group members! "+status.message
                                                                                                    });
                        }
                    )
                ).catch(function (error) {
                    component.set("v.showLoadingSpinner", false);
                    $A.reportError("Unable to initialise component!", error);
                });
            }
        },
    
        exportCSVAction : function(component,event,helper){
            
            // get the Records [contact] list from 'ListOfContact' attribute 
            var stockData = component.get("v.groupMembersList");
            
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
             if (csv == null){return;} 
            
            // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
         var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                hiddenElement.target = '_self'; // 
                hiddenElement.download = 'Public Group Users Report.csv';  // CSV file Name* you can change it.[only name not .csv] 
                document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
            }, 
    
        openModalAction : function(component, event, helper) {
            
            helper.openOrCloseModal(component, event, true);
    
        },
    
        closeModalAction : function(component, event, helper) {
            
            helper.openOrCloseModal(component, event, false);
    
        }
    
})