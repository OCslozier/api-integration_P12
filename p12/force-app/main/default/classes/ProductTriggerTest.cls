@IsTest
public class ProductTriggerTest {

    @IsTest
    static void testUpdateUuidOnProductInsert() {

        // Création d'un produit sans l'insérer immédiatement
        Product2 testProduct = new Product2(
            Name = 'Velo',
            ProductCode = 'Velo5000',
            IsActive = true,
            Family = 'none',
            UUID__c = null
        );

        Test.startTest();
        insert testProduct; // exécution du trigger before insert
        Test.stopTest();

        // Récupération du produit inséré pour vérification
        Product2 insertedProduct = [SELECT Id, UUID__c FROM Product2 WHERE Id = :testProduct.Id];

        // Vérifier si UUID__c est alimenté
        Assert.isNotNull(insertedProduct.UUID__c, 'UUID__c doit être renseigné.');
        Assert.AreEqual(36, insertedProduct.UUID__c.length(), 'UUID__c doit être composé de 36 caractères');
    }
}