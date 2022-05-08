({
    /*
@description gets all absa advantage data for given client
@author Humbelani Denge
@created dated 2021/05/11
*/
    getClientChallengeData: function (component) {
        this.getAllClientChallenges(component);
        this.getVoucherHistoryOfCustomer(component);
    },
    
    setTableColumns: function(component){
        component.set("v.columns", [
            { label: "Campaign Name", fieldName: "shortDescription", type: "text" },
            { label: "Date", fieldName: "challengeStartDate", type: "text" },
            { label: "Info", fieldName: "longDescription", type: "text" },
            { label: "Start Date", fieldName: "challengeStartDate", type: "text" },
            { label: "End Date", fieldName: "challengeEndDate", type: "text" },
            { label: "Status", fieldName: "status", type: "text" },
            { label: "Progress", fieldName: "progress", type: "percent" }
        ]);
        
        component.set("v.voucherHistoryColumns", [
            { label: "Voucher Issue Date", fieldName: "redemptionDateTime", type: "text" },
            { label: "Reward Type", fieldName: "offerDescription", type: "text" },
            { label: "Reward Status", fieldName: "offerStatus", type: "text" },
            { label: "Voucher Type Selected", fieldName: "voucherSelectedType", type: "text" },
            { label: "Voucher Value", fieldName: "offerRandValue", type: "currency" },
            { label: "Voucher Pin", fieldName: "rewardPinVoucher", type: "text" },
            { label: "Expiry Date", fieldName: "offerExpiryDateTime", type: "text" }
        ]);
    },
    
    /*
@description getAllClientChallenges gets all absa advantage voucher challenges from service side request call
@author Humbelani Denge
@created dated 2021/05/11
*/
    getAllClientChallenges: function (component) {
        this.showSpinner(component);
        var action = component.get("c.getAllChallenges");
        console.log('cifFromFlow==> '+ component.get("v.cifFromFlow"));
        action.setParams({ cifKey: component.get("v.cifFromFlow")});//FRIENLM001
        action.setCallback(this, function (response) {
            var state = response.getState();
            var responseValue = response.getReturnValue();
            console.log('challenges==>'+JSON.stringify(responseValue));
            var challenges = responseValue.challenges;
            if (state === "SUCCESS") {
                if ($A.util.isUndefinedOrNull(responseValue)) {
                    component.set("v.errorMessage", "Service returned a blank response : " + JSON.stringify(responseValue));
                }
                
                if (responseValue.statusCode != 200) {
                    component.set("v.errorMessage", responseValue.message);
                }
                
                if (!$A.util.isUndefinedOrNull(challenges) && challenges.length > 0) {
                    var currCampaignsEngaged = [];
                    var currCampaignsNotEngaged = [];
                    var prevCampaignsNotEngaged = [];
                    var prevCampaignsEngaged = [];
                    
                    for (var key in challenges) {
                        
                        if(!$A.util.isUndefinedOrNull(challenges[key].customerChallengeStatus )){
                            var challengeStatus = challenges[key].customerChallengeStatus.status.toLowerCase();
                            var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-dd");
                            var challengeEndDate = $A.localizationService.formatDate(challenges[key].challengeEndDate, "yyyy-MM-dd");
                            var voucherAllocationStatus = challenges[key].customerChallengeStatus.voucherAllocationStatus;
                            //Map client subscribed challenges
                            if (
                                challengeStatus === "accepted" ||
                                challengeStatus === "in_progress" ||
                                challengeStatus === "completed"
                            ) {
                                if (challengeEndDate > today && challenges[key].customerChallengeStatus.voucherForChallenge) {
                                    currCampaignsEngaged.push({
                                        shortDescription: challenges[key].shortDescription,
                                        longDescription: challenges[key].longDescription,
                                        progress: challenges[key].customerChallengeStatus.progress,
                                        challengeId: challenges[key].challengeId,
                                        status: challenges[key].customerChallengeStatus.status,
                                        challengeEndDate: challenges[key].challengeEndDate,
                                        challengeStartDate: challenges[key].challengeStartDate,
                                        completedOnDate: challenges[key].customerChallengeStatus.completedOnDate,
                                        voucherPin: challenges[key].customerChallengeStatus.voucherForChallenge.voucherPin,
                                        voucherPartnerID: challenges[key].customerChallengeStatus.voucherForChallenge.voucherPartnerID,
                                        voucherIssueDate: challenges[key].customerChallengeStatus.voucherForChallenge.voucherIssueDate.substring(0, 10),
                                        voucherType: challenges[key].customerChallengeStatus.voucherForChallenge.voucherType,
                                        voucherValue: challenges[key].customerChallengeStatus.voucherForChallenge.voucherValue,
                                        voucherExpiryDate: challenges[key].customerChallengeStatus.voucherForChallenge.voucherExpiryDate.substring(0, 10),
                                        voucherStatus: challenges[key].customerChallengeStatus.voucherForChallenge.voucherStatus,
                                        hasVoucher: true,
                                        
                                    });
                                }
                                
                                if(challengeEndDate > today && $A.util.isUndefinedOrNull(challenges[key].customerChallengeStatus.voucherForChallenge)){
                                    currCampaignsEngaged.push({
                                        shortDescription: challenges[key].shortDescription,
                                        longDescription: challenges[key].longDescription,
                                        challengeId: challenges[key].challengeId,
                                        progress: challenges[key].customerChallengeStatus.progress,
                                        status: challenges[key].customerChallengeStatus.status,
                                        challengeEndDate: challenges[key].challengeEndDate,
                                        challengeStartDate: challenges[key].challengeStartDate,
                                        completedOnDate: challenges[key].customerChallengeStatus.completedOnDate,
                                        hasVoucher: false,
                                    });
                                }
                            }
                            //Map unsubscribed current challenges
                            else if (challengeStatus === "new" || challengeStatus === "expired" ) {
                                if (challengeEndDate > today ) {
                                    currCampaignsNotEngaged.push({
                                        shortDescription: challenges[key].shortDescription,
                                        longDescription: challenges[key].longDescription,
                                        challengeId: challenges[key].challengeId,
                                        progress: challenges[key].customerChallengeStatus.progress,
                                        status: challenges[key].customerChallengeStatus.status,
                                        challengeEndDate: challenges[key].challengeEndDate,
                                        challengeStartDate: challenges[key].challengeStartDate,
                                        completedOnDate: challenges[key].customerChallengeStatus.completedOnDate,
                                    });
                                }
                            }
                            
                            //Map client subscribed previous campaigns
                            if (challengeStatus === "accepted" || challengeStatus === "in_progress" || challengeStatus === "completed" && voucherAllocationStatus != "FORFEIT" || voucherAllocationStatus != "AVAILABLE" || voucherAllocationStatus !="NOT_ELIGIBLE") {
                                if (challengeEndDate < today && challenges[key].customerChallengeStatus.voucherForChallenge) {
                                    prevCampaignsEngaged.push({
                                        shortDescription: challenges[key].shortDescription,
                                        longDescription: challenges[key].longDescription,
                                        challengeId: challenges[key].challengeId,
                                        progress: challenges[key].customerChallengeStatus.progress,
                                        status: challenges[key].customerChallengeStatus.status,
                                        challengeEndDate: challenges[key].challengeEndDate,
                                        challengeStartDate: challenges[key].challengeStartDate,
                                        completedOnDate: challenges[key].customerChallengeStatus.completedOnDate,
                                        voucherPin: challenges[key].customerChallengeStatus.voucherForChallenge.voucherPin,
                                        voucherPartnerID: challenges[key].customerChallengeStatus.voucherForChallenge.voucherPartnerID,
                                        voucherIssueDate: challenges[key].customerChallengeStatus.voucherForChallenge.voucherIssueDate.substring(0, 10),
                                        voucherType: challenges[key].customerChallengeStatus.voucherForChallenge.voucherType,
                                        voucherValue: challenges[key].customerChallengeStatus.voucherForChallenge.voucherValue,
                                        voucherExpiryDate: challenges[key].customerChallengeStatus.voucherForChallenge.voucherExpiryDate.substring(0, 10),
                                        voucherStatus: challenges[key].customerChallengeStatus.voucherForChallenge.voucherStatus,
                                        hasVoucher: true,
                                    });
                                }
                                
                                if (challengeEndDate < today && $A.util.isUndefinedOrNull(challenges[key].customerChallengeStatus.voucherForChallenge)) {
                                    prevCampaignsEngaged.push({
                                        shortDescription: challenges[key].shortDescription,
                                        longDescription: challenges[key].longDescription,
                                        challengeId: challenges[key].challengeId,
                                        progress: challenges[key].customerChallengeStatus.progress,
                                        status: challenges[key].customerChallengeStatus.status,
                                        challengeEndDate: challenges[key].challengeEndDate,
                                        challengeStartDate: challenges[key].challengeStartDate,
                                        completedOnDate: challenges[key].customerChallengeStatus.completedOnDate,
                                        hasVoucher: false,
                                    });
                                }
                                
                            }
                            //Map client unsubscribed previous campaigns
                            else if (challengeStatus === "new" || challengeStatus === "expired") {
                                if (challengeEndDate < today) {
                                    prevCampaignsNotEngaged.push({
                                        shortDescription: challenges[key].shortDescription,
                                        longDescription: challenges[key].longDescription,
                                        challengeId: challenges[key].challengeId,
                                        progress: challenges[key].customerChallengeStatus.progress,
                                        status: challenges[key].customerChallengeStatus.status,
                                        challengeEndDate: challenges[key].challengeEndDate,
                                        challengeStartDate: challenges[key].challengeStartDate,
                                        completedOnDate: challenges[key].customerChallengeStatus.completedOnDate,
                                    });
                                }
                            }
                        }
                    }
                    
                    //Set all table data from server side.
                    component.set("v.currCampaignsEngaged", currCampaignsEngaged);
                    component.set("v.currCampaignsNotEngaged", currCampaignsNotEngaged);
                    component.set("v.prevCampaignsEngaged", prevCampaignsEngaged);
                    component.set("v.prevCampaignsNotEngaged", prevCampaignsNotEngaged);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("AbsaRewardsHelper.getAllClientChallenges - Error message : " + JSON.stringify(errors));
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    console.log("Error message: " + "AbsaRewardsHelper.getAllClientChallenges - Unknown error : " + JSON.stringify(state));
                    component.set("v.errorMessage", "AbsaRewardsHelper.getAllClientChallenges - Unknown error");
                }
            }
            this.hideSpinner(component);
        });
        
        $A.enqueueAction(action);
    },
    
    /*
@author Humbelani Denge
@created dated 2021/05/11
*/
    getVoucherHistoryOfCustomer: function (component) {
        this.showSpinner(component);
        var action = component.get("c.getVoucherHistoryOfCustomer");
        console.log('cifFromFlow==> '+ component.get("v.cifFromFlow"));
        console.log('idNumberFromFlow==> '+ component.get("v.idNumberFromFlow"));
        action.setParams({ cifKey: component.get("v.cifFromFlow"),
                            idNumber: component.get("v.idNumberFromFlow")}); //"FRIENLM001"
        action.setCallback(this, function (response) {
            var state = response.getState();
            var responseValue = response.getReturnValue();
            console.log('voucherHistory==>'+JSON.stringify(responseValue));
            if (state === "SUCCESS") {
                if ($A.util.isUndefinedOrNull(responseValue)) {
                    component.set("v.errorMessage", "Server returned a blank response" + JSON.stringify(responseValue));
                }
                if (responseValue.statusCode != 200) {
                    component.set("v.errorMessage", responseValue.message);
                }
                
                if (!$A.util.isUndefinedOrNull(responseValue.customerVoucherHistory) && responseValue.customerVoucherHistory.length > 0) {
                    var vouchers = [];
                    var voucherCollection = responseValue.customerVoucherHistory;
                    for (var key in voucherCollection) {
                        var partnerId = voucherCollection[key].partnerId;
                        for (var secondkey in voucherCollection[key]) {
                            if (Array.isArray(voucherCollection[key][secondkey])) {
                                var rewards = voucherCollection[key][secondkey];
                                for (var key in rewards) {
                                    vouchers.push({
                                        partnerId: partnerId,
                                        redemptionDateTime: rewards[key].redemptionDateTime.substring(0, 10),
                                        channel: rewards[key].channel,
                                        rewardPinVoucher: rewards[key].rewardPinVoucher,
                                        offerTier: rewards[key].offerTier,
                                        offerDescription: rewards[key].offerDescription,
                                        offerExpiryDays: rewards[key].offerExpiryDays,
                                        offerExpiryDateTime: rewards[key].offerExpiryDateTime.substring(0, 10),
                                        offerStatus: rewards[key].offerStatus,
                                        offerRandValue: rewards[key].offerRandValue,
                                        voucherSelectedType: rewards[key].partnerName,
                                    });
                                }
                            }
                        }
                    }
                    component.set("v.vouchersHistory", vouchers);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("AbsaRewardsHelper.getVoucherHistoryOfCustomer - Error message : " + JSON.stringify(errors));
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    console.log("Error message: " + "AbsaRewardsHelper.getVoucherHistoryOfCustomer - Unknown error : " + JSON.stringify(state));
                    component.set("v.errorMessage", "AbsaRewardsHelper.getVoucherHistoryOfCustomer - Unknown error");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    isPinClaimedInTime: function (component, selectedRows) {
        var vouchers = component.get("v.vouchersHistory");
        for (var key in vouchers) {
            if (
                vouchers[key].partnerId == selectedRows[0].voucherPartnerID &&
                vouchers[key].rewardPinVoucher.substring(3, vouchers[key].rewardPinVoucher.length) ==
                selectedRows[0].voucherPin.substring(3, selectedRows[0].voucherPin.length)
            ) {
                if (vouchers[key].redemptionDateTime - selectedRows[0].completedOnDate > 5) return "Yes";
                else return "No";
            }
        }
    },
    
    getVoucherPartner: function (component, selectedRows) {
        var vouchers = component.get("v.vouchersHistory");
        for (var key in vouchers) {
            if (
                vouchers[key].partnerId == selectedRows[0].voucherPartnerID &&
                vouchers[key].rewardPinVoucher.substring(3, vouchers[key].rewardPinVoucher.length) ==
                selectedRows[0].voucherPin.substring(3, selectedRows[0].voucherPin.length)
            ) {
                if (vouchers[key].voucherSelectedType) return vouchers[key].voucherSelectedType;
                else return "No Related Partner";
            }
        }
    },
    
    mapCampaigneChallengeModalView: function(component, selectedRows){
        if(!selectedRows[0].hasVoucher){
            component.set("v.customerChallengeEndDate", "N/A");
            component.set("v.challengeCompletedInTime", "N/A");
            component.set("v.pinClaimedWithinAppointedTime", "N/A");
        }
        else{
            component.set("v.pinClaimedWithinAppointedTime", this.isPinClaimedInTime(component, selectedRows));
            component.set("v.customerChallengeEndDate", selectedRows[0].completedOnDate);
            component.set("v.challengeCompletedInTime", selectedRows[0].customerChallengeEndDate - selectedRows[0].challengeEndDate <= 14 ? 'Yes' : 'No');
        }
        component.set("v.challengeName", selectedRows[0].shortDescription);
        component.set("v.challengeDescription", selectedRows[0].longDescription);
        component.set("v.challengeProgress", selectedRows[0].progress * 100);
        component.set("v.challengeStartDate", selectedRows[0].challengeStartDate);
        
    },
    
    mapCampaigneRewardModalView: function (component, selectedRows) {
        component.set("v.rewardStatus", selectedRows[0].voucherStatus);
        component.set("v.rewardType", selectedRows[0].voucherType);
        component.set("v.voucherIssueDate", selectedRows[0].voucherIssueDate);
        component.set("v.voucherTypeSelected", this.getVoucherPartner(component, selectedRows)); 
        component.set("v.voucherValue", selectedRows[0].voucherValue);
        component.set("v.voucherPin", selectedRows[0].voucherPin);
        component.set("v.expiryDate", selectedRows[0].voucherExpiryDate);
        
    },
    
    mapCampaigneRewardCreate: function(component, selectedRows){ 
        console.log('selectedRows ==> '+JSON.stringify(selectedRows));
        component.find("rewardType").set("v.value", selectedRows[0].voucherType);
        component.find("rewardStatus").set("v.value", selectedRows[0].voucherStatus);
        component.find("voucherIssueDate").set("v.value", selectedRows[0].voucherIssueDate.substring(0, 10));
        //component.find("voucherTypeSelected").set("v.value", component.get("v.voucherTypeSelected")); commented out by SMath to store the partnerId below
        component.find("voucherTypeSelected").set("v.value", selectedRows[0].voucherPartnerID);
        component.find("voucherValue").set("v.value", parseFloat(selectedRows[0].voucherValue));
        component.find("voucherPin").set("v.value", selectedRows[0].voucherPin);
        component.find("expiryDate").set("v.value", selectedRows[0].voucherExpiryDate.substring(0, 10));
        component.find("challengeCompletedInTime").set("v.value", component.get("v.challengeCompletedInTime"));
        component.find("pinClaimedInTime").set("v.value", component.get("v.pinClaimedWithinAppointedTime"));
        component.find("challengeId").set("v.value", selectedRows[0].challengeId);
        component.find("caseId").set("v.value", component.get("v.caseIdFromFlow"));
    },
    
    mapRewardModalView: function (component, selectedRows) {
        component.set("v.rewardStatus", selectedRows[0].offerStatus);
        component.set("v.rewardType", selectedRows[0].offerDescription);
        component.set("v.voucherIssueDate", selectedRows[0].redemptionDateTime.substring(0, 10));
        component.set("v.voucherTypeSelected", selectedRows[0].voucherSelectedType); 
        component.set("v.voucherValue", selectedRows[0].offerRandValue);
        component.set("v.voucherPin", selectedRows[0].rewardPinVoucher);
        component.set("v.expiryDate", selectedRows[0].offerExpiryDateTime);
        component.set("v.pinClaimedWithinAppointedTime", "N/A");
        
        
    },
    
    
    
    mapRewardRecordCreate: function(component, selectedRows){
        component.find("rewardType").set("v.value", selectedRows[0].offerDescription);
        component.find("rewardStatus").set("v.value", selectedRows[0].offerStatus);
        component.find("voucherIssueDate").set("v.value", selectedRows[0].redemptionDateTime.substring(0, 10));
        component.find("voucherTypeSelected").set("v.value", selectedRows[0].voucherSelectedType);
        component.find("voucherValue").set("v.value", parseFloat(selectedRows[0].offerRandValue));
        component.find("voucherPin").set("v.value", selectedRows[0].rewardPinVoucher);
        component.find("expiryDate").set("v.value", selectedRows[0].offerExpiryDateTime.substring(0, 10));
        component.find("pinClaimedInTime").set("v.value", "N/A");
        component.find("challengeCompletedInTime").set("v.value", component.get("v.challengeCompletedInTime"));
        component.find("caseId").set("v.value", component.get("v.caseIdFromFlow"));  
    },
    
    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },
    
    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
    },
    
    fireToastEvent: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
});