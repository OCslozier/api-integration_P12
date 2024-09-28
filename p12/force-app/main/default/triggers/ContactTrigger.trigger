trigger ContactTrigger on Contact (before insert) {
    // Appel à la méthode updateUuid de la classe ContactService
    ContactService.updateUuid(trigger.new);
}