global class MobileInventoryExtension {
   
    //Constructors.  Needed to use as an extension.
    public MobileInventoryExtension() {}
    public MobileInventoryExtension(ApexPages.StandardController c) {}
    public MobileInventoryExtension(ApexPages.StandardSetController c) {}
   
    @RemoteAction
    global static List<Merchandise__c> queryMerchandise() {
         return [SELECT Id, Name, Price__c, Quantity__c from Merchandise__c LIMIT 20];
    }
    
    //Remote Action function allows JavaScript to call Apex directly
    @RemoteAction
    global static String updateMerchandiseItem(String productId, Integer newInventory) {
         List<Merchandise__c> m = [SELECT Id, Name, Price__c, Description__c, Quantity__c from Merchandise__c WHERE Id =: productId LIMIT 1];
        if(m.size() > 0) {
            m[0].Quantity__c = newInventory;
            try {
                update m[0];
                return 'Item Updated';
            } catch (Exception e) {
                return e.getMessage();
            }  
        }
        else {
            return 'No item found with that ID';
        }  
    }    
    
    
    @RemoteAction
	global static String saveImage(String imageData, String prodId, string prodName) {
		Attachment prodImage = new Attachment();
		prodImage.parentid = prodId;
		prodImage.Name = prodName + ' Image';
		prodImage.body = EncodingUtil.base64Decode(imageData);
		upsert prodImage;
		return prodImage.Name;
	}
}