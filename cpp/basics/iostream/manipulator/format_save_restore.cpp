#include <iostream>
#include <iomanip>

using namespace std;

int main()
{

    std::ios  state(NULL);
    state.copyfmt(std::cout);

	cout << std::hex;
    cout << "Hex of 42: "  << 42 << "\n";
    cout << "Hex of 84: "  << 82 << "\n";

    std::cout.copyfmt(state);

    cout << "This should not be in hex: " << 42 << "\n";
}

/*
 * output:
 * Hex of 42: 2a
 * Hex of 84: 52
 * This should not be in hex: 42
 */
