#include <stdio.h>

void PrintBits(unsigned int x)
{
	int i;
	for (i = 8 * sizeof(x) - 1; i >= 0; i--)
	{
		(x & (1 << i)) ? putchar('1') : putchar('0');
	}
	printf("\n");
}
void PrintBitsOfByte(unsigned int x)
{
	int i;
	for (i = 7; i >= 0; i--)
	{
		(x & (1 << i)) ? putchar('1') : putchar('0');
	}
	printf("\n");
}

// 1.1
int bitOr(int x, int y)
{
	//PrintBits(x);
	//PrintBits(y);
	return ~(~x & ~y);
}

// 1.2
int negative(int x)
{
	 return ~x+0b1;
    // chuyển sang dạng bù 2: bù 1 cộng 1
}

// 1.3
int getHexcha(int x, int n)
{
	return (x >> (4 * n)) & 0xF;
	// Dịch phải x đi (4 * n) bit để đưa nibble thứ n về cuối.
    // Sau đó AND với 0xF (0000 1111) để giữ lại đúng 4 bit cuối.
}

// 1.4
int flipByte(int x, int n)
{
	 // Tạo mặt nạ (mask) cho byte thứ n: 0xFF << (8*n)
    int mask = 0xFF << (8 * n);

    // Lấy ra giá trị của byte thứ n
    int byteVal = (x & mask) >> (8 * n);

    // Lật (nghịch đảo) tất cả bit trong byte (0 -> 1, 1 -> 0)
    int flippedByte = (~byteVal) & 0xFF;

    // Xóa byte cũ trong x (AND với phủ định của mask)
    x &= ~mask;

    // Chèn byte mới đã lật vào đúng vị trí
    x |= (flippedByte << (8 * n));

    return x;
}

// 1.5
int divpw2(int x, int n)
{
	 return x << (-n);  // Dịch trái tương ứng nhân với 2^(-n)
}



// 2.1
int isEqual(int x, int y)
{
	 // Nếu x ^ y = 0 => x == y
    return !(x ^ y);
}

// 2.2
int is16x(int x)
{
	// Nếu 4 bit cuối bằng 0 thì chia hết cho 16
    return !(x & 0xF);
}

// 2.3
int isPositive(int x)
{
	// Trả về 1 nếu x dương
    return x > 0;
}

// 2.4
int isGE2n(int x, int y)
{
	 // Kiểm tra x >= 2^y
    return x >= (1 << y);
}

int main()
{
	int score = 0;
	printf("Your evaluation result:");
	printf("\n1.1 bitOr");
	if (bitOr(3, -9) == (3 | -9))
	{
		printf("\tPass.");
		score += 1;
	}
	else
		printf("\tFailed.");

	printf("\n1.2 negative");
	if (negative(0) == 0 && negative(9) == -9 && negative(-5) == 5)
	{
		printf("\tPass.");
		score += 1;
	}
	else
		printf("\tFailed.");

	//1.3
	printf("\n1.3 getHexcha");
	if (getHexcha(26, 0) == 0xa && getHexcha(0x11223344, 1) == 0x4)
	{
		printf("\tPass.");
		score += 2;
	}
	else
		printf("\tFailed.");

	printf("\n1.4 flipByte");
	if (flipByte(10, 0) == 245 && flipByte(0, 1) == 65280 && flipByte(0x5501, 1) == 0xaa01)
	{
		printf("\tPass.");
		score += 3;
	}
	else
		printf("\tFailed.");
	//1.5
	printf("\n1.5 divpw2");
	if (divpw2(10, -1) == 20 && divpw2(15, -2) == 60 && divpw2(2, -4) == 32)
	{
		if (divpw2(10, 1) == 5 && divpw2(50, 2) == 12)
		{
			printf("\tAdvanced Pass.");
			score += 4;
		}
		else
		{
			printf("\tPass.");
			score += 3;
		}
	}
	else
		printf("\tFailed.");

	printf("\n2.1 isEqual");
	if (isEqual(4, 2) == 0 && isEqual(-4, -4) == 1 && isEqual(0, 10) == 0)
	{
		printf("\tPass.");
		score += 2;
	}
	else
		printf("\tFailed.");

	//2.2
	printf("\n2.2 is16x");
	if (is16x(16) == 1 && is16x(23) == 0 && is16x(0) == 1)
	{
		printf("\tPass.");
		score += 2;
	}
	else
		printf("\tFailed.");

	printf("\n2.3 isPositive");
	if (isPositive(10) == 1 && isPositive(-5) == 0 && isPositive(0) == 0)
	{
		printf("\tPass.");
		score += 3;
	}
	else
		printf("\tFailed.");


	//2.4
	printf("\n2.4 isGE2n");
	if (isGE2n(12, 4) == 0 && isGE2n(8, 3) == 1 && isGE2n(15, 2) == 1)
	{
		printf("\tPass.");
		score += 3;
	}
	else
		printf("\tFailed.");

	printf("\n--- FINAL RESULT ---");
	printf("\nScore: %.1f", (float)score / 2);
	if (score < 5)
		printf("\nTrouble when solving these problems? Contact your instructor to get some hints :)");
	else
	{
		if (score < 8)
			printf("\nNice work. But try harder.");
		else
		{
			if (score >= 10)
				printf("\nExcellent. We found a master in bit-wise operations :D");
			else
				printf("\nYou're almost there. Think more carefully in failed problems.");
		}
	}

	printf("\n\n\n");
}