public class ProductService {
    public static void updateUuid(List<Product2> Products) {
        
        for (Product2 product : products) {
            UUID randomUuid = UUID.randomUUID();
            String uuidStr = randomUUID.toString();
            product.UUID__c = uuidStr;
        }
    }
}