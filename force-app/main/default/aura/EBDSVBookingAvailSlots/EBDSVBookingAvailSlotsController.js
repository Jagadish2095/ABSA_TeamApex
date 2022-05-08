({
	doInit: function (component, event, helper) {
		var deliveryType = component.get("v.deliveryType");
		var cardNumber = component.get("v.cardNumber");
		var regNumber = component.get("v.regNumber");
		var productCode = regNumber.replace(/[^a-zA-Z\s]/g, "").replace(/\s\s/g, " ");
		component.set("v.prodCode", productCode);
		var message;

		//component.set("v.isBookingConfirmation", true);
		if (deliveryType != "Branch") {
			var addressData = JSON.parse(component.get("v.addressData"));
			var deliveryAddressLine1 = addressData.Shipping_Street__c;
			var deliveryAddressLine2 = addressData.Shipping_Street_2__c;
			var suburb = addressData.Shipping_Suburb__c;
			var city = addressData.Shipping_City__c;
			var postalCode = addressData.Shipping_Zip_Postal_Code__c;
			var country = addressData.Shipping_Country__c;
			component.set("v.city", city);
			component.set("v.deliveryCountry", country);
			component.set("v.deliveryAddressLine1", deliveryAddressLine1);
			component.set("v.deliveryAddressLine2", deliveryAddressLine2);
			component.set("v.postalCode", postalCode);
			component.set("v.suburbSelected", suburb);
			message =
				"Card no: " +
				cardNumber +
				" " +
				" Address: " +
				deliveryAddressLine1 +
				" " +
				deliveryAddressLine2 +
				" " +
				suburb +
				" " +
				city +
				" " +
				postalCode;
			if (deliveryType == "Face To Face") {
				var slotDataList = JSON.parse(component.get("v.bookAvailSlots"));
				helper.dateAndTimeSlotHelper(component, event, helper);
				component.set("v.optionsDates", slotDataList.BookingAvailabilitySlots);
				component.set("v.isFaceToFaceBooking", true);
			} else if (deliveryType == "Knock and Drop") {
				component.set("v.isBookingConfirmation", true);
			}
		} else {
			//Delivery type is Branch
			var branch = JSON.parse(component.get("v.branchCode"));
			component.set("v.isBookingConfirmation", true);
			message = "Card no: " + cardNumber + " Location: " + branch.Name;

			if(branch.Street__c){
				message += ". " + branch.Street__c;
			}
			if(branch.Suburb__c){
				message += ". " + branch.Suburb__c;
			}
			if(branch.City__c){
				message += ". " + branch.City__c;
			}
			if(branch.State_Province__c){
				message += ". " + branch.State_Province__c;
			}
			if(branch.Postal_Code__c){
				message += ". " + branch.Postal_Code__c;
			}
		}
		component.set("v.cardDeliveryConfirmationMessage", message);
	},

	bookFaceToFace: function (component) {
		var selectedDate = component.get("v.selectedDateValue");
		var selectedTimeSlot = component.get("v.selectedTimeSlot");

		var bookingData = component.get("v.optionsDates");

		for (var i = 0; i < bookingData.length; i++) {
			if (bookingData[i].ServiceDate == selectedDate && bookingData[i].ServiceTime == selectedTimeSlot) {
				component.set("v.tripSheet", bookingData[i].DailyTripID);
				component.set("v.townCode", bookingData[i].TownCode);
				component.set("v.suburbSelected", bookingData[i].SuburbName);
			}
		}

		component.set("v.isBookingConfirmation", true);
		component.set("v.isFaceToFaceBooking", false);
	},

	confirmBookingRequest: function (component, event, helper) {
		component.set("v.isBookingConfirmation", false);
		var deliveryType = component.get("v.deliveryType");
		if (deliveryType == "Face To Face") {
			helper.faceToFaceBookingHelper(component, event, helper);
		} else {
			helper.requestArrayBookingHelper(component, event, helper, deliveryType);
		}
	},

	onDeliveryDateChange: function (component, event, helper) {
		var dateValueKey = event.getSource().get("v.value"); // get selected date field value
		var timeSlotValuesMap = component.get("v.timeSlotValuesMap");

		component.set("v.selectedDateValue", dateValueKey);
		if (dateValueKey != "--- None ---") {
			var timeSlotList = timeSlotValuesMap[dateValueKey];

			if (timeSlotList.length > 0) {
				helper.fetchTimeValuesHelper(component, timeSlotList);
			} else {
				component.set("v.timeSlotValueList", ["--- None ---"]);
			}
		}
	},

	backToAddressSection: function (component, event, helper) {
		helper.navigateBack(component, event);
	}
});