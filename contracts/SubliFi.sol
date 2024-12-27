// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SubliFi
 * @dev A decentralized subscription platform enabling payments for streaming, SaaS, or premium content via cryptocurrency.
 */
contract SubliFi {
    // Event to emit when a new subscription is created
    event SubscriptionCreated(address indexed subscriber, address indexed provider, uint256 amount, uint256 duration);

    // Event to emit when a subscription is canceled
    event SubscriptionCanceled(address indexed subscriber, address indexed provider);

    // Event to emit when a subscription payment is processed
    event PaymentProcessed(address indexed subscriber, address indexed provider, uint256 amount);

    // Struct to store subscription details
    struct Subscription {
        uint256 amount; // Amount to be paid per cycle (in wei)
        uint256 duration; // Duration of one subscription cycle (in seconds)
        uint256 nextPayment; // Timestamp of the next payment
        bool active; // Whether the subscription is active
    }

    // Mapping of subscriber to provider to subscription details
    mapping(address => mapping(address => Subscription)) public subscriptions;

    /**
     * @dev Creates a new subscription.
     * @param provider The address of the service provider.
     * @param amount The amount to be paid per subscription cycle.
     * @param duration The duration of one subscription cycle in seconds.
     */
    function createSubscription(address provider, uint256 amount, uint256 duration) external payable {
        require(msg.value >= amount, "Insufficient payment for the first cycle");
        require(subscriptions[msg.sender][provider].active == false, "Subscription already exists");

        // Create the subscription
        subscriptions[msg.sender][provider] = Subscription({
            amount: amount,
            duration: duration,
            nextPayment: block.timestamp + duration,
            active: true
        });

        // Transfer the initial payment to the provider
        payable(provider).transfer(amount);

        emit SubscriptionCreated(msg.sender, provider, amount, duration);
    }

    /**
     * @dev Cancels an active subscription.
     * @param provider The address of the service provider.
     */
    function cancelSubscription(address provider) external {
        Subscription storage subscription = subscriptions[msg.sender][provider];
        require(subscription.active, "Subscription is not active");

        // Deactivate the subscription
        subscription.active = false;

        emit SubscriptionCanceled(msg.sender, provider);
    }

    /**
     * @dev Processes a subscription payment if the cycle has ended.
     * @param subscriber The address of the subscriber.
     * @param provider The address of the service provider.
     */
    function processPayment(address subscriber, address provider) external {
        Subscription storage subscription = subscriptions[subscriber][provider];
        require(subscription.active, "Subscription is not active");
        require(block.timestamp >= subscription.nextPayment, "Payment cycle not yet ended");

        // Update the next payment time
        subscription.nextPayment += subscription.duration;

        // Transfer the payment to the provider
        payable(provider).transfer(subscription.amount);

        emit PaymentProcessed(subscriber, provider, subscription.amount);
    }
}
