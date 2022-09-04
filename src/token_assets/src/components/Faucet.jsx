import React, { useState } from "react";
import { token, canisterId, createActor } from "../../../declarations/token";
import { AuthClient } from "@dfinity/auth-client";

function Faucet(props) {
  const [buttonName, setButtonName] = useState("Gimme gimme");
  const [isBlocked, setIsBlocked] = useState(false);

  async function handleClick(event) {
    setButtonName(true);

    const authClient = await AuthClient.create();
    const identity = await authClient.getIdentity();

    const authenticatedCanister = createActor(canisterId, {
      agentOptions: {
        identity,
      },
    });

    var res = await authenticatedCanister.chechOut();
    setButtonName(res);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>
        Get your free DCHI tokens here! Claim 10,000 DCHI coins to your{" "}
        {props.userPrincipals}.
      </label>
      <p className="trade-buttons">
        <button id="btn-payout" onClick={handleClick} disabled={isBlocked}>
          {buttonName}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
