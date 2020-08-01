Floating point rapresentation IEEE 754 works is a 32 bit rapresentation of floting number as a sign-magnitude mantissa and an exponenet.
Numerically a floating point value X is rapresented as:
         X = (-1)^S*|M|2^(E - 127)
where M is the mantissa, E the exponent. The mantissa module rapresent the 23 bits behind the LSB, this means that there is an hidden bit (conventionally set to 1) that rapresent the LSB (1. m23 m22 m21 m20 .... m0) this is known as normalized form.
The exponent value is instead biased by -127, this lead to un unsigned rapresentation for the exponent.

IEEE 754 rapresentation of number:

![rapresentation](/img/IEEE754.jpg)

To perfom un addition or a subctraction between two numbers X1 = (M1, E1), X2 = (M2, E2) three stages are required:

    -Alignment stage: the difference betweeen exponenet is computed (output exponent is the biggest one) and the mantissa are shifted by the respecting distance; in this stage the two mantissa are considered with the hidden bit, so the shifting is perfomed on 24 bits.

    -Computation stage: perform the operation Add/Sub between the shhifted mantissas.

    -Normalization: bit 23 must be one (hidden bit) by convection so if after computation stage this bit is zero perform a shift (left/right) and adjust the exponent.


![operation](/img/add_sub_op.png)


Example:

![example](/img/example.png)


The final hardware implementation is the following:

![scheme](/img/scheme.png)

The OMZ is used to detect all zero pattern in the output mantissa, is used for the normalization coordination.

Using OMZ and Overflow bit a signed comparator unit has been implemented, this unit relies only when subctraction is perfomed.
