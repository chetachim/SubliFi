import { ethers } from "hardhat";
import { expect } from "chai";

describe("SubliFi", function () {
  let subliFi: any;

  beforeEach(async () => {
    const SubliFi = await ethers.getContractFactory("SubliFi");
    subliFi = await SubliFi.deploy();
    await subliFi.deployed();
  });

  it("should create a subscription", async function () {
    const [subscriber, provider] = await ethers.getSigners();
    const amount = ethers.utils.parseEther("1"); // 1 ETH
    const duration = 30 * 24 * 60 * 60; // 30 days in seconds

    const tx = await subliFi
      .connect(subscriber)
      .createSubscription(provider.address, amount, duration, {
        value: amount,
      });
    await tx.wait();

    const subscription = await subliFi.subscriptions(
      subscriber.address,
      provider.address
    );

    expect(subscription.amount).to.equal(amount);
    expect(subscription.duration).to.equal(duration);
    expect(subscription.nextPayment).to.be.greaterThan(0);
    expect(subscription.active).to.be.true;
  });

  it("should cancel a subscription", async function () {
    const [subscriber, provider] = await ethers.getSigners();
    const amount = ethers.utils.parseEther("1");
    const duration = 30 * 24 * 60 * 60;

    await subliFi
      .connect(subscriber)
      .createSubscription(provider.address, amount, duration, {
        value: amount,
      });

    const tx = await subliFi
      .connect(subscriber)
      .cancelSubscription(provider.address);
    await tx.wait();

    const subscription = await subliFi.subscriptions(
      subscriber.address,
      provider.address
    );

    expect(subscription.active).to.be.false;
  });

  it("should process a subscription payment", async function () {
    const [subscriber, provider] = await ethers.getSigners();
    const amount = ethers.utils.parseEther("1");
    const duration = 1; // 1 second for test speed

    await subliFi
      .connect(subscriber)
      .createSubscription(provider.address, amount, duration, {
        value: amount,
      });

    // Wait for the duration to pass
    await new Promise((resolve) => setTimeout(resolve, 2000));

    const initialBalance = await ethers.provider.getBalance(provider.address);

    const tx = await subliFi.processPayment(
      subscriber.address,
      provider.address
    );
    await tx.wait();

    const finalBalance = await ethers.provider.getBalance(provider.address);
    const subscription = await subliFi.subscriptions(
      subscriber.address,
      provider.address
    );

    expect(finalBalance.sub(initialBalance)).to.equal(amount);
    expect(subscription.nextPayment).to.be.greaterThan(0);
  });
});
