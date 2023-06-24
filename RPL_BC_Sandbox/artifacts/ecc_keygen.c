#include <stdio.h>
#include <stdlib.h>
#include <openssl/ec.h>
#include <openssl/obj_mac.h>
#include <openssl/rand.h>

int main() {
    EC_KEY *key;
    EVP_PKEY *evp_key;
    int curve_name;

    // Set the curve name to NIST P-256
    curve_name = NID_X9_62_prime256v1;

    // Create a new EC key
    key = EC_KEY_new_by_curve_name(curve_name);
    if (key == NULL) {
        fprintf(stderr, "Error creating EC key\n");
        return 1;
    }

    // Generate the key pair
    if (EC_KEY_generate_key(key) != 1) {
        fprintf(stderr, "Error generating EC key\n");
        EC_KEY_free(key);
        return 1;
    }

    // Convert the EC key to an EVP_PKEY structure
    evp_key = EVP_PKEY_new();
    if (evp_key == NULL) {
        fprintf(stderr, "Error creating EVP_PKEY structure\n");
        EC_KEY_free(key);
        return 1;
    }
    if (EVP_PKEY_set1_EC_KEY(evp_key, key) != 1) {
        fprintf(stderr, "Error converting EC key to EVP_PKEY\n");
        EVP_PKEY_free(evp_key);
        EC_KEY_free(key);
        return 1;
    }

    // Print the private key
    printf("Private Key:\n");
    PEM_write_PrivateKey(stdout, evp_key, NULL, NULL, 0, NULL, NULL);

    // Print the public key
    printf("\nPublic Key:\n");
    PEM_write_PUBKEY(stdout, evp_key);

    // Cleanup
    EVP_PKEY_free(evp_key);
    EC_KEY_free(key);

    return 0;
}
