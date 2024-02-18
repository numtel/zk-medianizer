pragma circom 2.1.5;

include "comparators.circom";

/*
 * From https://hackmd.io/@namra/ryKnBrq0i
 * This is essentially a clever technique that lets us overcome the limitation
 * in Circom where we cannot index arrays using signals. Instead we simply use
 * helper circuits that sum all the signals in the array multiplied by whether
 * their index is equal to the target index we are looking for.
 */

template AtIndex(N) {
    signal input array[N];
    signal input index;

    signal output out;

    component result = CalculateTotal(N);
    for (var i = 0; i < N; i++) {
        // Check if i == index
        var isEqual = IsEqual()([i, index]);
        // Pass the element in as non-zero value if isEqual == true
        result.in[i] <== isEqual * array[i];
    }

    out <== result.out; // Return the
}

template CalculateTotal(N) {
    signal input in[N];
    signal output out;

    signal outs[N];
    outs[0] <== in[0];

    for (var i=1; i < N; i++) {
        outs[i] <== outs[i - 1] + in[i];
    }

    out <== outs[N - 1];
}

