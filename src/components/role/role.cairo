// Role identifiers
const MINTER_ROLE: felt252 = selector!("Minter");
const OFFSETER_ROLE: felt252 = selector!("Offsetter");
const OWNER_ROLE: felt252 = selector!("Owner");

#[starknet::component]
mod RoleComponent {
    // Starknet imports
    use starknet::ContractAddress;

    // External imports
    use openzeppelin::access::accesscontrol::AccessControlComponent;

    // Internal imports
    use super::{MINTER_ROLE, OFFSETER_ROLE, OWNER_ROLE};

    #[storage]
    struct Storage {
        access_control: AccessControlComponent::Storage
    }

    #[event]
    #[derive(Drop, PartialEq, starknet::Event)]
    enum Event {
        RoleGranted: accesscontrol::Event::RoleGranted,
        RoleRevoked: accesscontrol::Event::RoleRevoked,
        RoleAdminChanged: accesscontrol::Event::RoleAdminChanged
    }

    #[embeddable_as(RoleImpl)]
    impl Role<
        TContractState, +HasComponent<TContractState>, +Drop<TContractState>
    > of IRole<ComponentState<TContractState>> {
        fn grant_minter_role(ref self: ComponentState<TContractState>, address: ContractAddress) {
            // [Effect] Grant the minter role to the address
            self.accesscontrol.grant_role(MINTER_ROLE, address);
        }

        fn grant_offsetter_role(
            ref self: ComponentState<TContractState>, address: ContractAddress
        ) {
            // [Effect] Grant the offsetter role to the address
            self.accesscontrol.grant_role(OFFSETER_ROLE, address);
        }

        fn grant_owner_role(ref self: ComponentState<TContractState>, address: ContractAddress) {
            // [Effect] Grant the owner role to the address
            self.accesscontrol.grant_role(OWNER_ROLE, address);
        }

        fn revoke_minter_role(ref self: ComponentState<TContractState>, address: ContractAddress) {
            // [Effect] Revoke the minter role from the address
            self.accesscontrol.revoke_role(MINTER_ROLE, address);
        }

        fn revoke_offsetter_role(
            ref self: ComponentState<TContractState>, address: ContractAddress
        ) {
            // [Effect] Revoke the offsetter role from the address
            self.accesscontrol.revoke_role(OFFSETER_ROLE, address);
        }

        fn revoke_owner_role(ref self: ComponentState<TContractState>, address: ContractAddress) {
            // [Effect] Revoke the owner role from the address
            self.accesscontrol.revoke_role(OWNER_ROLE, address);
        }
    }

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>, +Drop<TContractState>
    > of InternalTrait<TContractState> {
        fn setup_admin_role(ref self: ComponentState<TContractState>) {
            // [Effect] Set the admin role of every single role to the owner role
            self.accesscontrol._set_role_admin(MINTER_ROLE, OWNER_ROLE);
            self.accesscontrol._set_role_admin(OFFSETER_ROLE, OWNER_ROLE);
            self.accesscontrol._set_role_admin(OWNER_ROLE, OWNER_ROLE);
        }

        fn only_minter(self: @ComponentState<TContractState>) {
            // [Require] The caller must have the minter role
            self.accesscontrol.assert_only_role(MINTER_ROLE);
        }

        fn only_offsetter(self: @ComponentState<TContractState>) {
            // [Require] The caller must have the offsetter role
            self.accesscontrol.assert_only_role(OFFSETER_ROLE);
        }

        fn only_owner(self: @ComponentState<TContractState>) {
            // [Require] The caller must have the owner role
            self.accesscontrol.assert_only_role(OWNER_ROLE);
        }
    }
}
