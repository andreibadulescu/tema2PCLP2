#include <stdio.h>

#define NO_TASKS 10

extern void base64(char *a, int n, char *target, int *ptr_len);

void readInput(char *filename, char *a, int *ptr_n)
{
	FILE *input = fopen(filename, "r");

	fscanf(input, "%d\n", ptr_n);
	fgets(a, 256, input);

	fclose(input);
}

void readRef(char *filename, char *ref_buffer, int *ptr_ref_n)
{
	FILE *ref = fopen(filename, "r");

	fscanf(ref, "%d\n", ptr_ref_n);
	fgets(ref_buffer, 256, ref);

	fclose(ref);
}

void printOutput(char *filename, char *out_buffer, int out_n)
{
	FILE *output = fopen(filename, "w");

	fprintf(output, "%d\n", out_n);
	for (int i = 0; i < out_n; ++i) {
		fprintf(output, "%c ", out_buffer[i]);
	}
	fprintf(output, "\n");

	fclose(output);
}

int check(char *out_buffer, int out_n, char *ref_buffer, int ref_n)
{
	if (out_n != ref_n) {
		return 0;
	}

	for (int i = 0; i < out_n; ++i) {
		if (out_buffer[i] != ref_buffer[i]) {
			return 0;
		}
	}

	return 1;
}

int main(int argc, char **argv)
{
	float score = 0;
	unsigned int x, ref;
	char input_file[30], output_file[30], ref_file[30];

	printf("--------------TASK 3--------------\n");

	char in_buffer[256], out_buffer[256], ref_buffer[256];
	int in_n, out_n = 0, ref_n;

	for (int i = 0; i < NO_TASKS; i++) {
		/* read input */
		sprintf(input_file, "./input/base64_%d.in", i + 1);
		sprintf(ref_file, "./ref/base64_%d.ref", i + 1);

		readInput(input_file, in_buffer, &in_n);
		readRef(ref_file, ref_buffer, &ref_n);

		base64(in_buffer, in_n, out_buffer, &out_n);

		sprintf(output_file, "./output/base64_%d.out", i + 1);
		printOutput(output_file, out_buffer, out_n);

		if (check(out_buffer, out_n, ref_buffer, ref_n)) {
			printf("Test %02d.................PASSED: %.1fp\n", i + 1, 2.5);
			score += 2.5;
		}
		else {
			printf("Test %02d.................FAILED: %.1fp\n", i + 1, 0.0);
		}
	}

	printf("\nTASK 3 SCORE: %.2f / 25.00\n\n", score);

	return 0;
}