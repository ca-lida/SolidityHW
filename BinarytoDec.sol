// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
// @title Binary to Decimal convertor
// @author Calida
// @dev ie prof. implications of limiting to uint8 - limits input value to 255, 
// yay for memory, yay for limiting the mask to max of 8 shifts

contract BinaryManip {
    // @notice takes a (positive unsigned) binary string as input and returns decimal rep as output
    function BinaryToDecimal(string memory binary) public pure returns (uint) {
        uint result = 0; // Decimal just means integer because solidity doesnt really have decimals or fractions
        
        // looping through binary 
        uint i = 0; 
        while (i < bytes(binary).length) {
            require(bytes(binary)[i] == '0' || bytes(binary)[i] == '1', "Invalid binary number");
            
            // convert character to integer - subtracting ascii so 49-48 = 1 and 48-48 = 0
            uint8 digit = uint8(bytes(binary)[i]) - uint8(bytes1('0'));

            
            // multiply prev result by 2 and add the new digit -
            // this way the 1s from i=0,1 in 1100 would get multiplied 3 times and twice respectively
            result = result * 2 + digit;
            i++;
        }
        
        return result;
    }

    // inp and not memory cuz uint8 is really small and you can save the value
    function BitShiftMask(uint8 inp ) public pure returns (uint8[] memory){
        // @notice takes a number < 255 and masks it using a bit-shift
       uint8[] memory result = new uint8[](8); // initialising result
       // the masking
       uint8 mask = 1;
       for (uint8 i = 0; i < 8; i++) {
            if ((inp & mask)!=0){
                result[i] = mask;
            }
            // the 'shifting'
            mask = mask << 1;
        }
        return result;
    }
    }
