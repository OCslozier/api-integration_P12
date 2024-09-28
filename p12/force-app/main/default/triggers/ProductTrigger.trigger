trigger ProductTrigger on Product2 (before insert) {
    // Appel à la méthode updateUuid de la classe ContractService
    ProductService.updateUuid(trigger.new);

}