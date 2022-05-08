({
    relationShipMaping : [
        { Relationship :'Aunt', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Brother', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Cheuffer', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Child', WIMAL00103 : 'Child', WIMAL00102  : 'Child'},
        { Relationship :'Cousin', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Daughter', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Daughter in law', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Ex-husband', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Ex-wife', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Father', WIMAL00103 : 'Extended Family Member', WIMAL00102  : 'Parent'},
        { Relationship :'Father in-law', WIMAL00103 : 'Extended Family Member', WIMAL00102  : 'Parent'},
        { Relationship :'Fiance', WIMAL00103 : 'Spouse', WIMAL00102  : ''},
        { Relationship :'Gardener or Caretaker ', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Godfather', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Godmother', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grand child', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grand daughter', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grand father', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grand father in-law', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grand mother', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grand mother-in-law', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Grandson', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'House Maid ', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Mother', WIMAL00103 : 'Extended Family Member', WIMAL00102  : 'Parent'},
        { Relationship :'Mother-in-law', WIMAL00103 : 'Extended Family Member', WIMAL00102  : 'Parent'},
        { Relationship :'Nephew', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Niece', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Sister', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Son', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Son in law', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Spouse', WIMAL00103 : 'Spouse', WIMAL00102  : 'Spouse'},
        { Relationship :'Step brother', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Stepmother', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Step sister', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Step daughter', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Stepfather', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Stepson', WIMAL00103 : 'Child', WIMAL00102  : ''},
        { Relationship :'Uncle', WIMAL00103 : 'Extended Family Member', WIMAL00102  : ''},
        { Relationship :'Wife ', WIMAL00103 : 'Spouse', WIMAL00102  : ''},
    ],
    fetchTranslationValues: function(component, listName, systemName, valueType, direction){
        var action = component.get('c.getTranslationValues');
        component.set("v.showSpinner", true);
        action.setParams({
            'systemName': systemName,
            'valueType': valueType,
            'direction': direction}
                        );
        action.setCallback(this, function(response){
            var mapValues = response.getReturnValue();
            var listValues = [];
            for(var itemValue in mapValues){
                listValues.push({key: itemValue, value: mapValues[itemValue]});
            }
            listValues.sort();
            component.set(listName,listValues);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    handleOnChangeCoverOptionsEvent : function(component, event, helper){
        
        component.set("v.isCalculating", true);
        component.set('v.premiumCalculated', false);
        var opporProductId = component.get('v.opportunityProductId');
        var session = component.get('v.policySession');
        var memberData = helper.createJsonFromView(component)
        var policyString =JSON.stringify(session);
        var memberString = JSON.stringify(memberData);
        
        var action = component.get('c.calculateMembersPremium');  
        action.setParams({
            policyData: policyString,
            newMemberData: memberString,
            opportunityProductId: opporProductId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var newSession = response.getReturnValue();
                component.set('v.tempSession', newSession);
                component.set('v.memberPremium', newSession.CalculatedPremium);
                component.set('v.premiumCalculated', true);
            }
            else{
                component.set('v.premiumCalculated', false);
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                        component.set('v.errorMessage', errors[0].message);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
            component.set("v.isCalculating", false);
        });
        
        $A.enqueueAction(action);
    },
    SetCoverOptionsByRelationShip: function (component){
        var session = component.get('v.policySession');
        var relationship = component.get('v.memberRelationship');
        var relationshipType = 'Main Member';
        var session = component.get('v.policySession');
        var items = [];

        this.relationShipMaping.forEach(function(item){
            if(item[session.ProductCode] != '' && item.Relationship == relationship){
                relationshipType = item[session.ProductCode];
                return;
            }
        });

        session.ProductDetails.MemberTypes.forEach(function (element){
            if(element.MemberTypeName == relationshipType){
                var valueData = [];
                for(var item in element.CoverOptions) {
                    valueData.push({key : element.CoverOptions[item].label, value: element.CoverOptions[item].value});
                }
                component.set('v.memberCoverOptions', valueData);
                component.set('v.memberType', element.MemberTypeName);
                return;
            }
        });
        
    },
    BindFieldsFromRow: function(component, row){
        component.set('v.itemId',row.PartyId);
        component.set('v.memberName',row.Name);
        component.set('v.memberSurname',row.Surname);
        component.set('v.memberIdTypeOption',row.IdType)
        component.set('v.memberIdText',row.IDNumber);
        component.set('v.memberGender',row.Gender);
        component.set('v.memberDateOfBirth',row.DateOfBirth);
        component.set('v.memberCoverOption',row.CoverOption);
        component.set('v.memberPremium',row.Premium);
        component.set('v.memberType',row.MemberType);
        component.set('v.memberRelationship',row.Relationship);
    },
    createJsonFromView: function(component){
        var hasPremiumInfo = component.get('v.hasPremiumInfo');
        var isNotMainMember = component.get('v.isNotMainMember');        
        
        var itemId = component.get('v.itemId');
        var memberName = component.get('v.memberName');
        var memberSurname = component.get('v.memberSurname');
        var memberIdTypeOption = component.get('v.memberIdTypeOption')
        var memberIdText = component.get('v.memberIdText');
        var memberGender = component.get('v.memberGender');
        var memberDateOfBirth = component.get('v.memberDateOfBirth');
        var memberType = component.get('v.memberType');
        
        var memberCoverOption = "0";
        var memberPremium = "0";
        var memberRelationship = "Main Member";
        
        if(isNotMainMember){
            memberRelationship = component.get('v.memberRelationship');
        }
        
        if(hasPremiumInfo){
            memberCoverOption = component.get('v.memberCoverOption');
            memberPremium = component.get('v.memberPremium')
        }
        
        var newMember ={ 
            'PartyId':itemId,
            'Name': memberName,
            'Surname': memberSurname,
            'Relationship': memberRelationship,
            'IDNumber': memberIdText,
            'IdType': memberIdTypeOption,
            'Gender': memberGender,
            'DateOfBirth': memberDateOfBirth,
            'CoverOption': memberCoverOption,
            'Premium': memberPremium,
            'MemberType': memberType
        };
        return newMember;
    }, 
    addBenefisiary: function(component, newMember, helper){
        component.set("v.showSpinner", true);
        component.set('v.premiumCalculated', false);
        
        var session = component.get('v.policySession');
        var policyString =JSON.stringify(session);
        var memberString = JSON.stringify(newMember);
        var opporProductId = component.get('v.opportunityProductId');

        var action = component.get('c.addOrUpdateBeneficiaries');  
        action.setParams({
            policyData: policyString,
            newMemberData: memberString,
            opportunityProductId: opporProductId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var newSession = response.getReturnValue();
                component.get('v.currentIndex', 0);
                component.set('v.policySession', newSession);
                component.set('v.itemId', newSession.MemberId);
                newMember.PartyId = newSession.MemberId;
                helper.completeSubmit(component, newMember);
            }
            else{
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                        component.set('v.errorMessage', errors[0].message);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    DeleteDependantDetails: function(component, memberData, helper){
        
        var session = component.get('v.policySession');
        var policyString =JSON.stringify(session);
        var memberString = JSON.stringify(memberData);
        var action = component.get('c.deleteDependentFromPolicy');  
        action.setParams({
            policyData: policyString,
            memberData: memberString
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var newSession = response.getReturnValue();
                component.set('v.policySession', newSession);
                helper.completeRemove(component);
            }
            else{
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                        component.set('v.errorMessage', errors[0].message);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
            
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    DeleteBeneficiaryDetails: function(component, memberData, helper){
        
        var session = component.get('v.policySession');
        var policyString =JSON.stringify(session);
        var memberString = JSON.stringify(memberData);
        var action = component.get('c.deletePolicyBeneficiary');  
        action.setParams({
            policyData: policyString,
            memberData: memberString
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var newSession = response.getReturnValue();
                component.set('v.policySession', newSession);
                helper.completeRemove(component);
            }
            else{
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                        component.set('v.errorMessage', errors[0].message);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    }, 
    LoadRalationshipsFor: function(component, isBeneficiary){
        var session = component.get('v.policySession');
        var items = [];

        this.relationShipMaping.forEach(function(item){
            if(item[session.ProductCode] != '' || isBeneficiary){
                items.push({ key: item.Relationship, value: item[session.ProductCode] });
            }
        });
        
        component.set('v.memberRelationshipOptions',items )
    },   
    completeSubmit: function(component, newMember){

        var index = component.get('v.currentIndex');

        var hasPremiumInfo = component.get('v.hasPremiumInfo');

        var gridData = component.get('v.gridData');
    
        if(index == -1){
            gridData.push(newMember);
        }
        else{
            gridData[index] = newMember;
        }

        component.set('v.gridData', gridData);
        
        
        if(!hasPremiumInfo && gridData.length > 0){
            component.set("v.isDisabled", true);
        }

        component.set("v.isModalOpen", false);
    },
    completeRemove: function(component){
        var index = component.get('v.currentIndex');
        var gridData = component.get('v.gridData');
        var hasPremiumInfo = component.get('v.hasPremiumInfo');

        if(index > -1){
            gridData.splice(index, 1);
        }
        component.set('v.gridData', gridData);

        if(!hasPremiumInfo && gridData.length == 0){
            component.set("v.isDisabled", false);
        }
    },
    getCustomeMessageDetailsForProduct: function(component){
        var session = component.get('v.policySession');
        var details = {
            displayDialog : false,
            Message : '',
            Header : ''
        };

        switch(session.ProductCode){
            case 'WIMAL00103':
                details.displayDialog = true;
                details.Header = 'Add Extended Family Members';
                details.Message = '<p>Have you imformed the customer that he/she can add 8 extended family members on his/her policy</p><br />'
                break;
            case 'WIMAL00102':
                details.displayDialog = true;
                details.Header = 'Additional Family Members';
                details.Message = '<p>Have you imformed the customer that he/she can add 8 family members on his/her policy</p><br />'
                break;
        }

        details.Message =  details.Message + '<ul>'
        this.relationShipMaping.forEach(function(item){
            if(item[session.ProductCode] != ''){
                details.Message =  details.Message + '<li style="margin-left: 10px;">' + item.Relationship  + '</li>';
                return;
            }
        });
        details.Message =  details.Message + '</ul>'

        return details;
    }
})