#include <stdio.h>
#include <stdlib.h>

unsigned char header[16] = {
	0x4e, 0x45, 0x53, 0x1a, 0x04, 0x00, 0x22, 0x08, 
	0x00, 0x00, 0x07, 0x07, 0x00, 0x00, 0x00, 0x00
};

int main(const int argc, const char **argv)
{
	if (argc < 6)
	{
		printf("Arguments: <PRG-ROM0.BIN> <PRG-ROM1.BIN> <PRG-ROM2.BIN> <PRG-ROM3.BIN> <PRG-ROM4.BIN> <PRG-ROM5.BIN> <PRG-ROM6.BIN> <PRG-ROM7.BIN> <OUTPUT.NES>\n");
		
		return 0;
	}

	FILE *output = NULL;

	output = fopen(argv[5], "wt");
	if (!output)
	{
		printf("Error opening %s\n", argv[5]);
		return 0;
	}

	// HEADER

	for (int i=0; i<16; i++)
	{
		fprintf(output, "%c", header[i]);
	}

	FILE *prg_rom = NULL;

	unsigned char buffer = 0;

	for (int i=1; i<=8; i++)
	{
		// PRG-ROM

		prg_rom = NULL;

		prg_rom = fopen(argv[i], "rb");
		if (!prg_rom)
		{
			printf("Error opening %s\n", argv[i]);

			return 0;
		}

		for (int i=0; i<16384; i++)
		{
			fscanf(prg_rom, "%c", &buffer);

			fprintf(output, "%c", buffer);
		}

		fclose(prg_rom);
	}

	fclose(output);

	return 1;
}
