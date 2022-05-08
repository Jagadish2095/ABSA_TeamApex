({
    init : function(component, event, helper) {
        var opp =  component.get('v.opportunityId');
        var hasPremiumInfo = component.get('v.hasPremiumInfo');
        var isNotMainMember = component.get('v.isNotMainMember');
        var gridData = component.get('v.gridData');
        
        var actions = [{'label': 'Edit', 'iconName': 'utility:edit','name': 'edit'},];
                       
                       var colums = [
                       {label: 'Name', fieldName: 'Name', type: 'text'},
                       {label: 'Surname', fieldName: 'Surname', type: 'text'},
                       {label: 'ID Number', fieldName: 'IDNumber', type: 'text'}
                      ]
        
        if(isNotMainMember){
            colums.push({label: 'Relationship', fieldName: 'Relationship', type: 'text'});
            actions.push({'label': 'Delete','iconName': 'utility:delete','name': 'delete'})
        }
        
        
        if(hasPremiumInfo){
            colums.push({label: 'Cover Option', fieldName: 'CoverOption', type: 'text'});
            colums.push({label: 'Premium', fieldName: 'Premium', type: 'text'});
        }
        colums.push({label: 'Action', type: 'action', typeAttributes: {rowActions: actions}});       
        
        component.set('v.columns', colums);
        
        helper.fetchTranslationValues(component, 'v.memberIdTypeOptions', 'CIF','Identity Type','Outbound');
        helper.fetchTranslationValues(component, 'v.memberGenderOptions', 'CIFCodesList','Gender','Outbound');        
    },
    handleClick : function(component, event, helper) {
        var hasPremiumInfo = component.get('v.hasPremiumInfo');
        var isNotMainMember = component.get('v.isNotMainMember');
        var isDisabled = component.get('v.isDisabled');

        component.set('v.errorMessage','');

        if(isNotMainMember){
            component.set('v.itemId','0');
            component.set('v.memberName','');
            component.set('v.memberSurname','');
            component.set('v.memberIdTypeOption','')
            component.set('v.memberIdText','');
            component.set('v.memberRelationship','');
            component.set('v.memberGender','');
            component.set('v.memberDateOfBirth','');
            component.set('v.memberType','');
            component.set('v.memberCoverOption','0');
            component.set('v.memberPremium',0);
            
            component.set('v.currentIndex',-1);
            
            component.set('v.formLabel', 'Add Member');
            
            helper.LoadRalationshipsFor(component, !hasPremiumInfo);
        }
        else
        {
            component.set('v.memberRelationship', 'Main Member');

            component.set('v.formLabel', 'Edit Member');
            
            component.set('v.currentIndex',0);
            
            var gridData = component.get('v.gridData');
            helper.BindFieldsFromRow(component, gridData[0]);
        
            helper.SetCoverOptionsByRelationShip(component);
                    
        }

        component.set('v.premiumCalculated', false);
        component.set("v.isModalOpen", true);

    },
    onChangeCoverOption: function(comp,event,helper){
        helper.handleOnChangeCoverOptionsEvent(comp,event,helper);
    },
    onChangeRelationship: function(comp,event,helper){
        helper.SetCoverOptionsByRelationShip(comp);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    submitDetails : function(component, event, helper) {
        
        var hasPremiumInfo = component.get('v.hasPremiumInfo');
        var premiumCalculated = component.get('v.premiumCalculated');
        
        if(premiumCalculated){
            var tempSession = component.get('v.tempSession');
            component.set('v.policySession', tempSession);
            component.set('v.itemId', tempSession.MemberId);
        }
        
        var newMember = helper.createJsonFromView(component);
        
        if(!hasPremiumInfo){
            helper.addBenefisiary(component, newMember, helper)
        }
        else{
            helper.completeSubmit(component, newMember);
        }

        var isNotMainMember = component.get('v.isNotMainMember');
        if(!isNotMainMember){
            var wasNotInformed = component.get('v.wasNotInformed');
            if(wasNotInformed){
                var session = component.get('v.policySession');
                var messageDetails = helper.getCustomeMessageDetailsForProduct(component);
                component.set("v.customMessageHeader", messageDetails.Header);
                component.set("v.customMessage", messageDetails.Message);
                component.set("v.isCustomMessageModalOpen", messageDetails.displayDialog);
            }
        }
    },
    getValueFromComponentEvent: function(comp,event,helper){
        var ShowOppoResultValue = event.getParam('opportunityIdResult');     
        comp.set('v.opportunityId', ShowResultValue);
    },
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');   
        var gridData = component.get('v.gridData');
        var hasPremiumInfo = component.get('v.hasPremiumInfo');
        
        component.set('v.currentIndex',gridData.indexOf(row));

        switch (action.name ) {
            case 'delete':

                if(!hasPremiumInfo){
                   helper.DeleteBeneficiaryDetails(component,row, helper);
                }else{
                  helper.DeleteDependantDetails(component,row, helper);
                }

                break;
            case 'edit':
                helper.LoadRalationshipsFor(component, !hasPremiumInfo);
                helper.BindFieldsFromRow(component, row);        
                helper.SetCoverOptionsByRelationShip(component);
                component.set('v.formLabel', 'Edit Member');
                component.set("v.isModalOpen", true);
                break; 
            default:
                break;
        }
        
        
    },
    IDNumberCaptured:function(component, event, helper){
        var theIDnumber = component.get('v.memberIdText');
        
  		var ex = /^(((\d{2}((0[13578]|1[02])(0[1-9]|[12]\d|3[01])|(0[13456789]|1[012])(0[1-9]|[12]\d|30)|02(0[1-9]|1\d|2[0-8])))|([02468][048]|[13579][26])0229))(( |-)(\d{4})( |-)(\d{3})|(\d{7}))/;     
        if (ex.test(theIDnumber) == true) {

            var currentYear = (new Date).getFullYear();
            var yearpart = parseInt(theIDnumber.substring(0, 2))
            if(currentYear - (yearpart + 1900) > 100){
                yearpart = yearpart + 2000;
            }

             var tempDate = new Date(yearpart, theIDnumber.substring(2, 4) - 1, theIDnumber.substring(4, 6));
            component.set('v.memberDateOfBirth', $A.localizationService.formatDate(tempDate, "YYYY-MM-DD"));
            
            component.set('v.dataOfBirthDisabled', true);
            
            var genderCode = theIDnumber.substring(6, 10);
    		var gender = parseInt(genderCode) < 5000 ? "Female" : "Male";
            
            component.set('v.memberIdTypeOption','01'); // 01 for SA Identity Document
            component.set('v.memberGender', gender);
        }
        else{
           component.set('v.dataOfBirthDisabled', false); 
        }
    },
    handleOkButton : function(component, event, helper) {
        component.set('v.isCustomMessageModalOpen', false)
        component.set('v.wasNotInformed', false)
    }
})