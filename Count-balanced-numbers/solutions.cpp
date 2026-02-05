class Solution {
public:
    int countBalancedNumbers(vector<int>& nums) {
        int count = 0;
        for (int num : nums) {
            int oddSum = 0, evenSum = 0, pos = 1;
            while (num > 0) {
                int digit = num % 10;
                if (pos % 2 == 1) oddSum += digit;
                else evenSum += digit;
                num /= 10;
                pos++;
            }
            if (oddSum == evenSum) count++;
        }
        return count;
    }
};