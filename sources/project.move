module MyModule::PetAdoption {

    use aptos_framework::signer;
    use std::string;

    struct Pet has key, store {
        name: string::String,
        adopted: bool,
    }

    struct AdoptionNFT has key, store {
        pet_name: string::String,
        owner: address,
    }

    /// Register a pet for adoption
    public fun register_pet(account: &signer, name: string::String) {
        let pet = Pet {
            name,
            adopted: false,
        };
        move_to(account, pet);
    }

    /// Adopt a pet and mint a simulated NFT
    public fun adopt_pet(adopter: &signer, shelter: address) acquires Pet {
        let pet = borrow_global_mut<Pet>(shelter);
        assert!(!pet.adopted, 1); // Ensure pet is not already adopted

        pet.adopted = true;

        let nft = AdoptionNFT {
            pet_name: pet.name,
            owner: signer::address_of(adopter),
        };
        move_to(adopter, nft);
    }
}
