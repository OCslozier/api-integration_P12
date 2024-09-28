trigger ContractTrigger on Contract (before insert) {
    // Appel à la méthode updateUuid de la classe ContractService
    ContractService.updateUuid(trigger.new);
}