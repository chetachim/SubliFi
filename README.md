# SubliFi

SubliFi is a decentralized platform built on Ethereum that facilitates flexible, cryptocurrency-based subscription payments for digital services like streaming, SaaS, and premium content. The platform leverages smart contracts to provide transparent, commitment-free subscriptions.

## Features

- **Create Subscriptions**: Subscribers can easily initiate recurring payments to service providers.
- **Cancel Subscriptions**: Flexible cancellation options ensure no long-term commitments.
- **Automated Payments**: Smart contracts handle recurring payments seamlessly.
- **Decentralized**: Operates on the Ethereum blockchain, ensuring transparency and security.

## Prerequisites

- [Node.js](https://nodejs.org/)
- [Hardhat](https://hardhat.org/)
- [ethers.js](https://docs.ethers.io/)
- An Ethereum wallet (e.g., MetaMask)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/sublifi.git
   cd sublifi
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Compile the smart contracts:

   ```bash
   npx hardhat compile
   ```

4. Run the tests:
   ```bash
   npx hardhat test
   ```

## Deployment

To deploy the SubliFi contract to a local or test network:

1. Configure your network settings in `hardhat.config.js`.
2. Deploy the contract:
   ```bash
   npx hardhat run scripts/deploy.js --network yourNetwork
   ```

## Usage

- **Create Subscription**: Call the `createSubscription` function with the provider's address, subscription amount, and duration.
- **Cancel Subscription**: Use the `cancelSubscription` function to deactivate a subscription.
- **Process Payment**: Execute the `processPayment` function to settle a subscription payment when due.

## Testing

SubliFi includes a comprehensive test suite to ensure contract functionality. Run the tests using:

```bash
npx hardhat test
```

## Contributing

Contributions are welcome! Please fork the repository, create a feature branch, and submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

### Disclaimer

SubliFi is a decentralized platform. Users are responsible for securing their wallets and private keys. Use at your own risk.
