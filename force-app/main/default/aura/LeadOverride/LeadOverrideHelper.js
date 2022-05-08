({
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    navHome : function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Lead"
        });
        homeEvent.fire();
    },
    closeFocusedTab : function(component) {
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        }).catch(function(error) {
            console.log(error);
        });
    },
    closeFocusedTabAndOpenNewTab : function( component, leadId ) {
        
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            var focusedTabId = response.tabId;
            
            console.log(focusedTabId);
            
            //Opening New Tab
            workspaceAPI.openTab({
                url: '#/sObject/' + leadId + '/view'
            }).then(function(response) {
                workspaceAPI.focusTab({tabId : response});
            })
            .catch(function(error) {
                console.log(error);
            });
            
            //Closing old tab
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    camelize: function (text) {
        var lowerCase = text.toLowerCase();
        return lowerCase.replace(/^([a-z])|[\s-_]+(\w)/g, function(match, p1, p2, offset) {
            if (p2) return p2.toUpperCase();
            return p1.toUpperCase();        
        });
    },
    
    createProductInterestData: function(component, event) {
        // get the productInterestList from component and add(push) New Object to List  
        var rowItemList = component.get("v.productInterestList");
        rowItemList.push({
            'sobjectType': 'Product_Interest__c',
            'Financial_Product__c': '',
        });
        // set the updated list to attribute (productInterestList) again    
        component.set("v.productInterestList", rowItemList);
    },
    
    //Set navigation buttons based on Permission Sets and Profiles
    getUserPermissionSets : function( component ) {
        //Set CaseType default selection
        var action = component.get("c.getLoggedInUserPermissionSets");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var userPermissionSets = response.getReturnValue();
                console.log('***userPermissionSets**', userPermissionSets);
                if(userPermissionSets != null) {
                    userPermissionSets.forEach(function(record) {
                        //Set default record type
                        if(record == 'Assign') {
                            component.set("v.showAssignBtn", true);
                        }else if(record == 'Route') {
                            component.set("v.showRouteBtn", true);
                        }else if(record == 'VA') {
                            component.set("v.defaultRecordType", 'STI_Lead');
                        }
                    });  
                }

            }else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                var toast = this.getToast("Error", message, "error");
                
                toast.fire();
                
                this.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Get the service group of the logged in user
    getUserServiceGroup : function( component ) {
        //Set CaseType default selection
        var action = component.get("c.getLoggedInUserServiceGroups");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var groupNames = [];
                var formatGroupNames = [];
                var userServiceGroups = response.getReturnValue();
                
                console.log('***userServiceGroups**', userServiceGroups);
                if(userServiceGroups != null){
                    
                    if(userServiceGroups.length > 0){
                        for(i = 0; i < userServiceGroups.length; i++){
                            var serviceGroupName = userServiceGroups[i].Name;
                            groupNames.push(serviceGroupName);
                            formatGroupNames.push('\''+serviceGroupName+'\'');
                            
                            var nonSalesGroup = serviceGroupName + ' - Non Sales';
                            groupNames.push(nonSalesGroup);
                            formatGroupNames.push('\''+nonSalesGroup+'\'');
                            
                            var managerGroup = serviceGroupName + ' - BM';
                            groupNames.push(managerGroup);
                            formatGroupNames.push('\''+managerGroup+'\'');
                        }
                    }
                }
                console.log('***formatGroupNames**', formatGroupNames);
                
				component.set('v.userPublicGroupNames', groupNames);
                
				var userLookupFieldCondition = ' And Id in (Select UserOrGroupId From GroupMember Where Group.Name in ('+formatGroupNames+'))  AND IsActive = true AND Is_Absent__c = false';
                component.set('v.userLookupFieldCondition', userLookupFieldCondition); 
                
            }else if(state === "ERROR"){
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                var toast = this.getToast("Error", message, "error");
                
                toast.fire();
                
                this.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    // Added by Poulami to fetch picklist values dynamically for DD STI
    fetchPickListVal: function(component, fieldName, elementId) {
		this.showSpinner(component);
		var unwantedlist = '';
        var BSSASite = component.get('v.showBSSAFieldBool');
        if(elementId == 'DDSTISource')
              unwantedlist = ['WPB','Inbound CLI','Credit card','SS&E','Absa Life','STI','Virtual'];
        else if(elementId == 'DDInboundSource')
              unwantedlist = ['Banker','Client','LMS AIC','Life Adviser','Rebroke','Service','Web','Virtual'];
		var action = component.get('c.getFieldDependencies');
		action.setParams({
			objectName: component.get('v.leadRecord'),
			controllingField: fieldName,
            dependentField: 'DD_Lead_Sub_Source__c'
		});
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
                console.log('allValues',response.getReturnValue());
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                component.set("v.depnedentFieldMap",StoreResponse);
                var listOfkeys = [];
                var ControllerField = [];
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
				for (var i = 0; i < listOfkeys.length; i++) {
                  if(!unwantedlist.includes(listOfkeys[i])) {
					ControllerField.push(listOfkeys[i]);
                  }
				}
				component.set('v.sourceOptions', ControllerField);
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},
    
    // Added by Poulami to fetch picklist values dynamically for DD STI
    fetchSiteCodePickListVal: function(component, fieldName, elementId) {
		this.showSpinner(component);
        var action = component.get('c.getFieldDependencies');
		action.setParams({
			objectName: component.get('v.leadRecord'),
			controllingField: fieldName,
            dependentField: 'BSSA_Site_Code__c'
		});
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
                console.log('allValues',response.getReturnValue());
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                component.set("v.depnedentSiteFieldMap",StoreResponse);
                var depnedentSiteFieldMap = component.get("v.depnedentSiteFieldMap");
        		var ListOfSiteDependentFields = depnedentSiteFieldMap[elementId];
        		console.log('ListOfSiteDependentFields',ListOfSiteDependentFields);
        		if(ListOfSiteDependentFields.length > 0){
                	component.set("v.bDisabledDependentFld" , false);  
                	this.fetchSiteDepValues(component, ListOfSiteDependentFields);    
            	}else{
                	component.set("v.bDisabledDependentFld" , true); 
                	component.set("v.siteCodeOptions", ['--- None ---']);
            	}  
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},
    
    
    // Added by Poulami to fetch dependent picklist values dynamically for DD STI
    fetchDepValues: function(component, ListOfDependentFields) {
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.subsourceOptions", dependentFields);        
    },
    
    // Added by Poulami to fetch dependent picklist values dynamically for DD STI
    fetchSiteDepValues: function(component, ListOfDependentFields) {
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set("v.siteCodeOptions", dependentFields);        
    },
})