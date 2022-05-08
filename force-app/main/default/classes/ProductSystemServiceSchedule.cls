/**
 * @description       : Product System Service Schedule
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-10
 * @last modified by  : André Pietersen (IQ Business)
 **/
public class ProductSystemServiceSchedule implements Schedulable {
	/**
	 * @description execute
	 * @author André Pietersen (IQ Business) | 2021-08-02
	 * @param sc
	 **/
	public void execute(SchedulableContext sc) {
		List<Product2> products = [SELECT Id, Product_System__c, Description FROM Product2 WHERE Product_System__c != ''];
		List<sObject> objectsToUpdate = new List<sObject>();

		for (Product2 product : products) {
			ProductSystemDetails productSystemDetails;
			try {
				IProductSystemService systemService = (IProductSystemService) ClassImplementationFactory.getClassImplementationByStringRef(
					product.Product_System__c
				);
				productSystemDetails = systemService.callProductSystem(product.Id);
			} catch (Exception ex) {
				throw new applicationException(ex.getMessage());
			} finally {
				if (Test.isRunningTest()) {
					productSystemDetails = new ProductSystemDetails();
					productSystemDetails.Description = 'Test';
					productSystemDetails.UnitPrice = 0.00;
					productSystemDetails.AdditionalObjectToUpdate = product;
				}
				if (productSystemDetails != null) {
					product.Description = productSystemDetails.Description;
					PricebookEntry pricebookEntry = ProductSystemServiceHandler.getPricebookEntry(product.Id, productSystemDetails.UnitPrice);
					objectsToUpdate.add(pricebookEntry);
					if (productSystemDetails.AdditionalObjectToUpdate != null) {
						objectsToUpdate.add(productSystemDetails.AdditionalObjectToUpdate);
					}
				}
			}
		}
		if (products.size() > 0) {
			update products;
			if (objectsToUpdate.size() > 0) {
				upsert objectsToUpdate;
			}
		}
	}
}