({
	getControlOfficers: function(component, event, helper) {
		var accountId = component.get('v.recordId');
		console.log('accountId--' + accountId);
		var action = component.get('c.getControlOfficers');
		action.setParams({
			accountId: component.get('v.recordId')
		});

		// Add callback behavior for when response is received
		action.setCallback(this, function(response) {
			var state = response.getState();
			console.log('response state---' + state);
			if (component.isValid() && state === 'SUCCESS') {
				console.log('response state123---' + state);
				console.log('response ---' + response);
				var responseBean1 = JSON.parse(response.getReturnValue());
				console.log('message---' + JSON.stringify(responseBean1));
				var servicerResults = JSON.stringify(responseBean1);

				var json = JSON.parse(servicerResults);
                var count =  0;
                if(responseBean1 != null){
					if (responseBean1.length > 0) {
						for (var i = 0; i < responseBean1.length; i++) {
							console.log('Officer Name' + responseBean1[i].name);
								if (responseBean1[i].role == 'Business Banker' && count == 0) {
									count++;
									component.set('v.BusinessBanker', responseBean1[i].name);
							component.set(
								'v.businessBankerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Bank Manager') {
							component.set('v.bankingManager', responseBean1[i].name);
							component.set(
								'v.bankingManagerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Credit Manager') {
							component.set('v.creditManager', responseBean1[i].name);
							component.set(
								'v.creditManagerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Credit Analyst') {
							component.set('v.creditAnalyst', responseBean1[i].name);
							component.set(
								'v.creditAnalystHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Relationship Manager') {
							component.set('v.relationshipBanker', responseBean1[i].name);
							component.set(
								'v.relationshipBankerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Private Banker') {
							component.set('v.privateBanker', responseBean1[i].name);
							component.set(
								'v.privateBankerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Transactional Banker') {
							component.set('v.transactionalBanker', responseBean1[i].name);
							component.set(
								'v.transactionalBankerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'WealthSupport Officer') {
							component.set('v.wealthSupportOfficer', responseBean1[i].name);
							component.set(
								'v.wealthSupportOfficerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Business Manager') {
							component.set('v.businessManager', responseBean1[i].name);
							component.set(
								'v.businessManagerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Wealth Planner') {
							component.set('v.wealthPlanner', responseBean1[i].name);
							component.set(
								'v.wealthPlannerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Small Buss Relationship Manager') {
							component.set('v.relationshipManager', responseBean1[i].name);
							component.set(
								'v.relationshipManagerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Financial Planner') {
							component.set('v.financialPlanner', responseBean1[i].name);
							component.set(
								'v.financialPlannerHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'AGRI Specialist') {
							component.set('v.AGRISpecialist', responseBean1[i].name);
							component.set(
								'v.AGRISpecialistHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						} else if (responseBean1[i].role == 'Small Business') {
							component.set('v.smallBusiness', responseBean1[i].name);
							component.set(
								'v.smallBusinessHelperText',
								responseBean1[i].name +
									'  ' +
									responseBean1[i].mobileNumber +
									'  ' +
									responseBean1[i].email
							);
						}
					}
				} else {
					component.set('v.showErrors', true);
					component.set('v.errorMessage', 'CIF Required / not linked to a banker');
				}
                    
                }else{
                    component.set('v.showErrors', true);
					component.set('v.errorMessage', 'Service Issue!! Please contact administrator');
                }
			}
		});

		$A.enqueueAction(action);
	}
});