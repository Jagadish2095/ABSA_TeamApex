({
	isServicesSwitcherLabel : function(label) {

		let labels = [
			$A.get("$Label.c.Category_Change"),
			$A.get("$Label.c.Price_Scheme_Change")
		];

		let isServicesSwitcherLabel = labels.some(item => {
			return item.toUpperCase() === label.toUpperCase();
		});

		return isServicesSwitcherLabel;
	}
})