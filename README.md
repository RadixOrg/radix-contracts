# Radix Smart Contracts

This repository contains the smart contracts for the Radix Project.

## Getting Started

To get started, install the necessary dependancies:

```bash
npm install
```

## Testing

To run the tests:

```bash
npx hardhat test
```

To have a picture of the blockchain calls you can run the tests in the following way:

Start a local node:

```bash
npx hardhat node
```

Run the tests with the `--network localhost` flag:

```bash
npx hardhat test --network localhost
```

## Deployment

To deploy the contracts to a local node:

First start a local node:

```bash
npm run node
```

Then deploy the contracts:

```bash
npx hardhat ignition deploy ignition/modules/Radix.js --network localhost
```

## Scripts

There are two scripts in the `scripts` directory to show how the creation of a product tag works and how to check if a product have a valid tag.

To run the scripts after deploying the contracts to a local node:

```bash
npx hardhat run scripts/createProductTag.js --network localhost
npx hardhat run scripts/checkProductTag.js --network localhost
```